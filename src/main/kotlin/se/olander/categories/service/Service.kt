package se.olander.categories.service

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
import se.olander.categories.jooq.categories.Keys
import se.olander.categories.jooq.categories.Tables
import se.olander.categories.jooq.categories.tables.daos.*
import se.olander.categories.jooq.categories.tables.pojos.*
import java.sql.Timestamp

@Component
class Service (@Autowired val dslContext: DSLContext) {

    val categoryDao = CategoryDao(dslContext.configuration())

    val categoryItemDao = CategoryItemDao(dslContext.configuration())

    val userDao = UserDao(dslContext.configuration())

    val gameDao = GameDao(dslContext.configuration())

    val participantDao = ParticipantDao(dslContext.configuration())

    val guessDao = GuessDao(dslContext.configuration())

    val accountDao = AccountDao(dslContext.configuration())

    fun getCategories() : List<Category> {
        return categoryDao.findAll()
    }

    fun getCategory(categoryId: Int?): Category {
        return categoryDao.fetchOneById(categoryId)
    }

    fun getCategoryItems(categoryId: Int?): List<CategoryItem> {
        return categoryItemDao.fetchByCategoryId(categoryId)
    }

    fun getGames(): List<Game> {
        return gameDao.findAll()
    }

    fun getActiveGameModels(): List<GameModel> {
        return dslContext
                .selectFrom(Tables.GAME)
                .where(Tables.GAME.TIME_END.isNull)
                .fetch { record -> getGameModel(record.id) }
    }

    fun getGame(gameId: Int): Game {
        return gameDao.fetchOneById(gameId)
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

        val categoryItem = getMatchingCategoryItem(gameId, guessRaw)
        val categoryItemId = if (guessDao.fetchByGameId(gameId).any { guess -> guess.categoryItemId == categoryItem?.id }) {
            null
        } else {
            categoryItem?.id
        }

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
            var allCategoryItems = categoryItemDao.fetchByCategoryId(game.categoryId)
            var guessedCategoryItems = guessDao.fetchByGameId(gameId)
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
                    .filter { participant -> participant.status == ParticipantStatus.WAITING }

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

    fun setSessionUserId(userId: Int?) {
        RequestContextHolder.currentRequestAttributes().setAttribute("user_id", userId, RequestAttributes.SCOPE_SESSION)
    }

    fun getSessionUser() : User {
        var userId = RequestContextHolder.currentRequestAttributes().getAttribute("user_id", RequestAttributes.SCOPE_SESSION) as Int?
        if (userId != null) {
            return userDao.fetchOneById(userId)
        }
        else {
            userId = dslContext.insertInto(Tables.USER)
                    .defaultValues()
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

    fun getMatchingCategoryItem(gameId: Int, guess: String): CategoryItem? {
        val game = getGame(gameId)
        val categoryItems = getCategoryItems(game.categoryId)
        return categoryItems
                .filter { categoryMatches(it, guess) }
                .firstOrNull()
    }

    fun categoryMatches(categoryItem: CategoryItem, guess: String): Boolean {
        return categoryItem.name.replace(" ", "").toLowerCase() == guess.replace(" ", "").toLowerCase()
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

    fun  getStats(): Stats {
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
}
