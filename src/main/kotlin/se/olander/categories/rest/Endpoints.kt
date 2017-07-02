package se.olander.categories.rest

import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*
import org.springframework.web.context.request.RequestAttributes
import org.springframework.web.context.request.RequestContextHolder
import se.olander.categories.jooq.categories.Tables
import se.olander.categories.jooq.categories.tables.daos.*
import se.olander.categories.jooq.categories.tables.pojos.*

@RestController
@RequestMapping("rest")
class Endpoints @Autowired constructor(final val dslContext: DSLContext) {

    val categoryDao = CategoryDao(dslContext.configuration())

    val categoryItemDao = CategoryItemDao(dslContext.configuration())

    val userDao = UserDao(dslContext.configuration())

    val gameDao = GameDao(dslContext.configuration())

    val participantDao = ParticipantDao(dslContext.configuration())

    @GetMapping("categories")
    fun getCategories() : List<Category> {
        return categoryDao.findAll()
    }

    @GetMapping("categories/{id}")
    fun getCategory(@PathVariable("id") categoryId: Int): Category {
        return categoryDao.fetchOneById(categoryId)
    }

    @GetMapping("categories/{id}/items")
    fun getCategoryItems(@PathVariable("id") categoryId: Int): List<CategoryItem> {
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
    fun createGame(categoryId: Int): Game {
        val user = getSessionUser()
        val gameId = dslContext.insertInto(Tables.GAME)
                .set(Tables.GAME.CATEGORY_ID, categoryId)
                .returning()
                .fetchOne()
                .id

        dslContext.insertInto(Tables.PARTICIPANT)
                .set(Tables.PARTICIPANT.GAME_ID, gameId)
                .set(Tables.PARTICIPANT.USER_ID, user.id)
                .set(Tables.PARTICIPANT.ADMIN, 1)

        return gameDao.fetchOneById(gameId)
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
            RequestContextHolder.currentRequestAttributes().setAttribute("user_id", userId, RequestAttributes.SCOPE_SESSION)
            return userDao.fetchOneById(userId)
        }
    }
}
