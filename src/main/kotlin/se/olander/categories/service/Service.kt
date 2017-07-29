package se.olander.categories.service

import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.apache.ApacheHttpTransport
import com.google.api.client.json.jackson2.JacksonFactory
import org.apache.commons.lang3.StringUtils
import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Component
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.client.HttpClientErrorException
import org.springframework.web.context.request.RequestAttributes
import org.springframework.web.context.request.RequestContextHolder
import se.olander.categories.dto.GameModel
import se.olander.categories.dto.ParticipantModel
import se.olander.categories.dto.ParticipantStatus
import se.olander.categories.dto.Stats
import se.olander.categories.exception.ResourceNotFoundException
import se.olander.categories.jooq.categories.Keys
import se.olander.categories.jooq.categories.Tables
import se.olander.categories.jooq.categories.tables.daos.*
import se.olander.categories.jooq.categories.tables.pojos.*
import java.sql.Timestamp
import java.util.*
import kotlin.collections.HashMap
import kotlin.collections.HashSet

@Component
class Service (@Autowired val dslContext: DSLContext) {

    companion object {
        val PROFILE_PICTURES = listOf(
                "/images/avatars/chicken.png",
                "/images/avatars/cow.png",
                "/images/avatars/dog.png",
                "/images/avatars/dragon.png",
                "/images/avatars/goat.png",
                "/images/avatars/horse.png",
                "/images/avatars/monkey.png",
                "/images/avatars/mouse.png",
                "/images/avatars/pig.png",
                "/images/avatars/rabbit.png",
                "/images/avatars/snake.png",
                "/images/avatars/tiger.png"
        )

        private val random = Random()

        fun getRandomProfilePicture(): String {
            return PROFILE_PICTURES[random.nextInt(PROFILE_PICTURES.size)]
        }
    }

    val categoryDao = CategoryDao(dslContext.configuration())

    val categoryItemDao = CategoryItemDao(dslContext.configuration())

    val userDao = UserDao(dslContext.configuration())

    val gameDao = GameDao(dslContext.configuration())

    val participantDao = ParticipantDao(dslContext.configuration())

    val guessDao = GuessDao(dslContext.configuration())

    val accountDao = AccountDao(dslContext.configuration())

    val googleAccountDao = GoogleAccountDao(dslContext.configuration())

    val spellingDao = CategoryItemAlternativeSpellingDao(dslContext.configuration())

    fun getCategories() : List<Category> {
        return categoryDao.findAll()
    }

    fun getCategory(categoryId: Int): Category {
        return categoryDao.fetchOneById(categoryId) ?: throw ResourceNotFoundException(categoryId, ResourceNotFoundException.Type.CATEGORY)
    }

    fun getCategoryItems(categoryId: Int): List<CategoryItem> {
        return categoryItemDao.fetchByCategoryId(categoryId)
    }

    fun getGames(): List<Game> {
        return gameDao.findAll()
    }

    fun getNotEndedGameModels(): List<GameModel> {
        return dslContext
                .selectFrom(Tables.GAME)
                .where(Tables.GAME.TIME_END.isNull)
                .fetch { record -> getGameModel(record.id) }
    }

    fun getGame(gameId: Int): Game {
        return gameDao.fetchOneById(gameId) ?: throw ResourceNotFoundException(gameId, ResourceNotFoundException.Type.GAME)
    }

    fun getParticipants(gameId: Int): List<Participant> {
        return participantDao.fetchByGameId(gameId)
    }

    fun joinGame(gameId: Int) {
        val user = getSessionUser()
        assertGameNotStarted(gameId)
        dslContext.insertInto(Tables.PARTICIPANT)
                .set(Tables.PARTICIPANT.GAME_ID, gameId)
                .set(Tables.PARTICIPANT.USER_ID, user.id)
                .set(Tables.PARTICIPANT.ADMIN, 0)
                .execute()
    }

    fun createGame(categoryId: Int, name: String): Game {
        val user = getSessionUser()
        val gameId = dslContext.insertInto(Tables.GAME)
                .set(Tables.GAME.CATEGORY_ID, categoryId)
                .set(Tables.GAME.NAME, name)
                .returning()
                .fetchOne()
                .id

        dslContext.insertInto(Tables.PARTICIPANT)
                .set(Tables.PARTICIPANT.GAME_ID, gameId)
                .set(Tables.PARTICIPANT.USER_ID, user.id)
                .set(Tables.PARTICIPANT.ADMIN, 1)
                .execute()

        return gameDao.fetchOneById(gameId)
    }

    fun startGame(gameId: Int) {
        assertAdmin(gameId)
        assertGameNotStarted(gameId)
        dslContext.update(Tables.GAME)
                .set(Tables.GAME.TIME_START, now())
                .where(Tables.GAME.ID.eq(gameId))
                .execute()

        val user = getSessionUser()
        dslContext.update(Tables.PARTICIPANT)
                .set(Tables.PARTICIPANT.STATUS, ParticipantStatus.ANSWERING)
                .where(Tables.PARTICIPANT.USER_ID.eq(user.id))
                .execute()
    }

    fun makeGuess(gameId: Int, @RequestBody guessRaw: String): Guess {
        assertParticipant(gameId)
        assertGameOngoing(gameId)

        val user = getSessionUser()

        val participant = getParticipants(gameId)
                .first({ participant -> participant.userId == user.id })

        if (participant.status != ParticipantStatus.ANSWERING) {
            throw HttpClientErrorException(HttpStatus.PRECONDITION_FAILED, "Participant not currently answering")
        }

        val categoryItemId = getMatchingCategoryItemId(gameId, guessRaw)
                .takeUnless { id -> guessDao.fetchByGameId(gameId).any { it.categoryItemId == id } }

        val guessId = dslContext.insertInto(Tables.GUESS)
                .set(Tables.GUESS.USER_ID, user.id)
                .set(Tables.GUESS.GAME_ID, gameId)
                .set(Tables.GUESS.GUESS_RAW, guessRaw)
                .set(Tables.GUESS.CATEGORY_ITEM_ID, categoryItemId)
                .returning()
                .fetchOne()
                .id

        if (categoryItemId != null) { // Correct guess

            // Check if all items are guessed
            val game = gameDao.fetchOneById(gameId)
            val allCategoryItems = categoryItemDao.fetchByCategoryId(game.categoryId)
            val guessedCategoryItems = guessDao.fetchByGameId(gameId)
                    .filter { guess -> guess.categoryItemId != null }
                    .map { guess -> guess.categoryItemId }
            if (guessedCategoryItems.size == allCategoryItems.size) {
                dslContext.update(Tables.PARTICIPANT)
                        .set(Tables.PARTICIPANT.STATUS, ParticipantStatus.WINNER)
                        .where(Tables.PARTICIPANT.GAME_ID.eq(gameId))
                        .and(Tables.PARTICIPANT.STATUS.`in`(ParticipantStatus.ANSWERING, ParticipantStatus.WAITING))
                        .execute()
                dslContext.update(Tables.GAME)
                        .set(Tables.GAME.TIME_END, now())
                        .where(Tables.GAME.ID.eq(gameId))
                        .execute()
            }
            else {
                dslContext.update(Tables.PARTICIPANT)
                        .set(Tables.PARTICIPANT.STATUS, ParticipantStatus.WAITING)
                        .where(Tables.PARTICIPANT.GAME_ID.eq(gameId))
                        .and(Tables.PARTICIPANT.USER_ID.eq(user.id))
                        .execute()
            }

            val nextParticipant = getNextParticipant(gameId, participant.id)

            dslContext.update(Tables.PARTICIPANT)
                    .set(Tables.PARTICIPANT.STATUS, ParticipantStatus.ANSWERING)
                    .where(Tables.PARTICIPANT.ID.eq(nextParticipant?.id))
                    .execute()
        }
        else { // Incorrect Guess
            dslContext.update(Tables.PARTICIPANT)
                    .set(Tables.PARTICIPANT.STATUS, ParticipantStatus.ELIMINATED)
                    .where(Tables.PARTICIPANT.GAME_ID.eq(gameId))
                    .and(Tables.PARTICIPANT.USER_ID.eq(user.id))
                    .execute()

            val participants = participantDao.fetchByGameId(gameId)
            val waitingParticipants = participants
                    .filter { part -> part.status == ParticipantStatus.WAITING }

            if (waitingParticipants.size == 1) {
                dslContext.update(Tables.PARTICIPANT)
                        .set(Tables.PARTICIPANT.STATUS, ParticipantStatus.WINNER)
                        .where(Tables.PARTICIPANT.ID.eq(waitingParticipants.first().id))
                        .execute()
                dslContext.update(Tables.GAME)
                        .set(Tables.GAME.TIME_END, now())
                        .where(Tables.GAME.ID.eq(gameId))
                        .execute()
            }
            else if (waitingParticipants.isEmpty()) {
                dslContext.update(Tables.GAME)
                        .set(Tables.GAME.TIME_END, now())
                        .where(Tables.GAME.ID.eq(gameId))
                        .execute()
            }
            else {
                val nextParticipant = getNextParticipant(gameId, participant.id)

                dslContext.update(Tables.PARTICIPANT)
                        .set(Tables.PARTICIPANT.STATUS, ParticipantStatus.ANSWERING)
                        .where(Tables.PARTICIPANT.ID.eq(nextParticipant?.id))
                        .execute()
            }
        }

        return guessDao.fetchOneById(guessId)
    }

    fun getGuesses(gameId: Int): List<Guess> {
        return guessDao.fetchByGameId(gameId)
    }

    fun login(emailAddress: String, password: String): Int? {
        val account = accountDao.fetchOneByEmailAddress(emailAddress)
        if (account.password == password) {
            setSessionUserId(account.userId)
            return account.userId
        }
        else {
            return null
        }
    }

    fun loginGoogle(token: String): Int {
        val verifier = GoogleIdTokenVerifier.Builder(ApacheHttpTransport(ApacheHttpTransport.newDefaultHttpClient()), JacksonFactory.getDefaultInstance())
                .setAudience(listOf("983770946916-v5f5pnjl30j9fuhvriufbkhmr3igrhdc.apps.googleusercontent.com"))
                .build()
        val googleIdToken = verifier.verify(token) ?: throw RuntimeException("Invalid token")
        val payload = googleIdToken.payload
        val externalId = payload.subject
        val account = googleAccountDao.fetchOneByExternalId(externalId)

        if (account != null) {
            val userId = account.userId
            setSessionUserId(userId)
            return userId
        }
        else {
            val userId = getSessionUser().id
            dslContext.insertInto(Tables.GOOGLE_ACCOUNT)
                    .set(Tables.GOOGLE_ACCOUNT.USER_ID, userId)
                    .set(Tables.GOOGLE_ACCOUNT.EXTERNAL_ID, externalId)
                    .execute()
            return userId
        }
    }

    fun setSessionUserId(userId: Int?) {
        RequestContextHolder.currentRequestAttributes().setAttribute("user_id", userId, RequestAttributes.SCOPE_SESSION)
    }

    fun getSessionUserId() : Int? {
        return RequestContextHolder.currentRequestAttributes().getAttribute("user_id", RequestAttributes.SCOPE_SESSION) as Int?
    }

    fun getSessionUser() : User {
        var userId = getSessionUserId()
        if (userId != null) {
            return userDao.fetchOneById(userId)
        }
        else {
            userId = dslContext.insertInto(Tables.USER)
                    .set(Tables.USER.PROFILE_PICTURE, getRandomProfilePicture())
                    .returning()
                    .fetchOne()
                    .id
            setSessionUserId(userId)
            return userDao.fetchOneById(userId)
        }
    }

    fun assertAdmin(gameId: Int) {
        val user = getSessionUser()
        if (!getParticipants(gameId).any { participant -> participant.userId == user.id && participant.admin == 1 }) {
            throw HttpClientErrorException(HttpStatus.UNAUTHORIZED, "User not admin")
        }
    }

    fun assertParticipant(gameId: Int) {
        val user = getSessionUser()
        if (!getParticipants(gameId).any { participant -> participant.userId == user.id }) {
            throw HttpClientErrorException(HttpStatus.UNAUTHORIZED, "User not a participant")
        }
    }

    fun assertGameOngoing(gameId: Int) {
        val game = getGame(gameId)
        if (game.timeStart == null) {
            throw HttpClientErrorException(HttpStatus.PRECONDITION_FAILED, "Game has not started")
        }
    }

    fun assertGameNotStarted(gameId: Int) {
        val game = getGame(gameId)
        if (game.timeStart != null) {
            throw HttpClientErrorException(HttpStatus.PRECONDITION_FAILED, "Game has started")
        }
    }

    fun now(): Timestamp {
        return Timestamp(System.currentTimeMillis())
    }

    private fun getMatchingCategoryItemId(gameId: Int, guess: String): Int? {
        val maxDistance = 2
        val sanitizedGuess = sanitize(guess)
        val game = getGame(gameId)

        val matches = (0..maxDistance).map { HashSet<Int>() }
        getCategoryItems(game.categoryId).forEach {
            val distance = StringUtils.getLevenshteinDistance(sanitize(it.name), sanitizedGuess, maxDistance)
            if (distance == 0) {
                return it.id
            }
            if (distance in 0..maxDistance) {
                matches[distance].add(it.id)
            }
        }

        spellingDao.fetchByCategoryId(game.categoryId).forEach {
            val distance = StringUtils.getLevenshteinDistance(sanitize(it.spelling), sanitizedGuess, maxDistance)
            if (distance == 0) {
                return it.categoryItemId
            }
            if (distance in 0..maxDistance) {
                matches[distance].add(it.categoryItemId)
            }
        }

        return (0..maxDistance)
                .firstOrNull { matches[it].size != 0 }
                ?.let {
                    if (matches[it].size == 1) {
                        matches[it].first()
                    } else {
                        null
                    }
                }
    }

    private fun sanitize(value: String): String {
        var result = StringUtils.trimToEmpty(value)
        result = StringUtils.stripAccents(result)
        result = StringUtils.lowerCase(result)
        return result
    }

    fun getNextParticipant(gameId: Int, currentParticipantId: Int): Participant? {
        val participants = getParticipants(gameId)
                .filter { participant -> participant.status == ParticipantStatus.WAITING || participant.status == ParticipantStatus.ANSWERING }
                .sortedBy { participant -> participant.id }

        var next = false
        for (participant in participants) {
            if (next) {
                return participant
            }
            if (participant.id == currentParticipantId) {
                next = true
            }
        }

        return participants.firstOrNull()
    }

    fun getGameModel (gameId: Int): GameModel {
        val game = getGame(gameId)
        val category = getCategory(game.categoryId)
        val categoryItems = getCategoryItems(game.categoryId)
        val participants = dslContext
                .selectFrom(Tables.PARTICIPANT.join(Tables.USER).onKey(Keys.PARTICIPANT_IBFK_1))
                .where(Tables.PARTICIPANT.GAME_ID.eq(gameId))
                .fetch({
                    record -> ParticipantModel(
                        record.into(Tables.PARTICIPANT).into(Participant::class.java),
                        record.into(Tables.USER).into(User::class.java))
                })
        val guesses = guessDao.fetchByGameId(gameId)

        return GameModel(
                game = game,
                category = category,
                categoryItems = categoryItems,
                guesses = guesses,
                participants = participants
        )
    }

    fun getStats(): Stats {
        val user = getSessionUser()
        return Stats(
                totalNumberOfUsers = dslContext.selectCount()
                        .from(Tables.USER)
                        .fetchOneInto(Int::class.java),
                totalNumberOfUsersWithAccounts = dslContext.selectCount()
                        .from(Tables.USER)
                        .join(Tables.ACCOUNT).onKey(Keys.ACCOUNT_IBFK_1)
                        .fetchOneInto(Int::class.java),
                totalNumberOfGames = dslContext.selectCount()
                        .from(Tables.GAME)
                        .fetchOneInto(Int::class.java),
                totalNumberOfActiveGames = dslContext.selectCount()
                        .from(Tables.GAME)
                        .where(Tables.GAME.TIME_END.isNull)
                        .fetchOneInto(Int::class.java),
                totalNumberOfGuesses = dslContext.selectCount()
                        .from(Tables.GUESS)
                        .fetchOneInto(Int::class.java),
                totalNumberOfCorrectGuesses = dslContext.selectCount()
                        .from(Tables.GUESS)
                        .where(Tables.GUESS.CATEGORY_ITEM_ID.isNotNull)
                        .fetchOneInto(Int::class.java),
                totalNumberOfMyGames = dslContext.selectCount()
                        .from(Tables.PARTICIPANT)
                        .where(Tables.PARTICIPANT.USER_ID.eq(user.id))
                        .fetchOneInto(Int::class.java),
                totalNumberOfMyActiveGames = dslContext.selectCount()
                        .from(Tables.GAME)
                        .join(Tables.PARTICIPANT).onKey(Keys.PARTICIPANT_IBFK_2)
                        .where(Tables.PARTICIPANT.USER_ID.eq(user.id))
                        .and(Tables.GAME.TIME_END.isNull)
                        .fetchOneInto(Int::class.java)
        )
    }

    fun getGameLatestUpdated(gameId: Int): Timestamp {
        val gameUpdateTime = dslContext.select(Tables.GAME.UPDATED_TIME)
                .from(Tables.GAME)
                .where(Tables.GAME.ID.eq(gameId))
                .fetchOneInto(Timestamp::class.java)

        val participantUpdatedTime = dslContext
                .select(Tables.PARTICIPANT.UPDATED_TIME)
                .from(Tables.PARTICIPANT)
                .where(Tables.PARTICIPANT.GAME_ID.eq(gameId))
                .orderBy(Tables.PARTICIPANT.UPDATED_TIME.desc())
                .firstOrNull()
                ?.into(Timestamp::class.java)
                ?: Timestamp(0)

        return maxOf(gameUpdateTime, participantUpdatedTime)
    }

    fun updateUserName(name: String) {
        val user = getSessionUser()
        dslContext
                .update(Tables.USER)
                .set(Tables.USER.NAME, name)
                .where(Tables.USER.ID.eq(user.id))
                .execute()
    }

    fun hasAccount(userId: Int): Boolean {
        return accountDao.fetchByUserId(userId).isNotEmpty()
    }

    fun createAccount(userId: Int, emailAddress: String, password: String) {
        dslContext
                .insertInto(Tables.ACCOUNT)
                .set(Tables.ACCOUNT.USER_ID, userId)
                .set(Tables.ACCOUNT.EMAIL_ADDRESS, emailAddress)
                .set(Tables.ACCOUNT.PASSWORD, password)
                .execute()
    }

    fun logout() {
        val userId = getSessionUserId()
        if (userId != null) {
            val googleAccount = googleAccountDao.fetchByUserId(userId).firstOrNull()
            if (googleAccount != null) {

            }
            setSessionUserId(null)
        }
    }
}
