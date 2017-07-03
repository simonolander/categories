package se.olander.categories.rest

import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*
import org.springframework.web.client.HttpClientErrorException
import org.springframework.web.context.request.RequestAttributes
import org.springframework.web.context.request.RequestContextHolder
import se.olander.categories.dto.ParticipantStatus
import se.olander.categories.jooq.categories.Tables
import se.olander.categories.jooq.categories.tables.daos.*
import se.olander.categories.jooq.categories.tables.pojos.*
import java.sql.Timestamp

@RestController
@RequestMapping("rest")
class Endpoints @Autowired constructor(final val dslContext: DSLContext) {

    val categoryDao = CategoryDao(dslContext.configuration())

    val categoryItemDao = CategoryItemDao(dslContext.configuration())

    val userDao = UserDao(dslContext.configuration())

    val gameDao = GameDao(dslContext.configuration())

    val participantDao = ParticipantDao(dslContext.configuration())

    val guessDao = GuessDao(dslContext.configuration())

    @GetMapping("categories")
    fun getCategories() : List<Category> {
        return categoryDao.findAll()
    }

    @GetMapping("categories/{id}")
    fun getCategory(@PathVariable("id") categoryId: Int?): Category {
        return categoryDao.fetchOneById(categoryId)
    }

    @GetMapping("categories/{id}/items")
    fun getCategoryItems(@PathVariable("id") categoryId: Int?): List<CategoryItem> {
        return categoryItemDao.fetchByCategoryId(categoryId)
    }

    @GetMapping("games")
    fun getGames(): List<Game> {
        return gameDao.findAll()
    }

    @GetMapping("games/{id}")
    fun getGame(@PathVariable("id") gameId: Int): Game {
        return gameDao.fetchOneById(gameId)
    }

    @GetMapping("games/{id}/participants")
    fun getParticipants(@PathVariable("id") gameId: Int): List<Participant> {
        return participantDao.fetchByGameId(gameId)
    }

    @PostMapping("games/{id}/participants")
    fun joinGame(@PathVariable("id") gameId: Int) {
        val user = getSessionUser()
        dslContext.insertInto(Tables.PARTICIPANT)
                .set(Tables.PARTICIPANT.GAME_ID, gameId)
                .set(Tables.PARTICIPANT.USER_ID, user.id)
                .set(Tables.PARTICIPANT.ADMIN, 0)
                .execute()
    }

    @PostMapping("games")
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

    @PostMapping("games/{id}/start")
    fun startGame(@PathVariable("id") gameId: Int) {
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

    @PostMapping("games/{id}/guesses")
    fun makeGuess(@PathVariable("id") gameId: Int, @RequestBody guess: String): Guess {
        assertParticipant(gameId)
        assertGameOngoing(gameId)

        val user = getSessionUser()

        val participant = getParticipants(gameId)
                .first({ participant -> participant.userId == user.id })

        if (participant.status != ParticipantStatus.ANSWERING) {
            throw HttpClientErrorException(HttpStatus.PRECONDITION_FAILED, "Participant not currently answering")
        }

        val categoryItem = getMatchingCategoryItem(gameId, guess)
        val nextStatus = if (categoryItem == null) ParticipantStatus.ELIMINATED else ParticipantStatus.WAITING

        val guessId = dslContext.insertInto(Tables.GUESS)
                .set(Tables.GUESS.USER_ID, user.id)
                .set(Tables.GUESS.GAME_ID, gameId)
                .set(Tables.GUESS.GUESS_RAW, guess)
                .set(Tables.GUESS.CATEGORY_ITEM_ID, categoryItem?.id)
                .returning()
                .fetchOne()
                .id

        val nextParticipant = getNextParticipant(gameId, participant.id)

        dslContext.update(Tables.PARTICIPANT)
                .set(Tables.PARTICIPANT.STATUS, nextStatus)
                .where(Tables.PARTICIPANT.ID.eq(participant.id))
                .execute()

        dslContext.update(Tables.PARTICIPANT)
                .set(Tables.PARTICIPANT.STATUS, ParticipantStatus.ANSWERING)
                .where(Tables.PARTICIPANT.ID.eq(nextParticipant?.id))
                .execute()

        return guessDao.fetchOneById(guessId)
    }

    @GetMapping("games/{id}/guesses")
    fun getGuesses(@PathVariable("id") gameId: Int): List<Guess> {
        return guessDao.fetchByGameId(gameId)
    }

    /**
     * Helper methods
     */

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
            RequestContextHolder.currentRequestAttributes().setAttribute("user_id", userId, RequestAttributes.SCOPE_SESSION)
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
}
