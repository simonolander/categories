package se.olander.categories.controller;

import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import se.olander.categories.dto.GameModel
import se.olander.categories.dto.ParticipantModel
import se.olander.categories.dto.Stats
import se.olander.categories.jooq.categories.Keys
import se.olander.categories.jooq.categories.Tables
import se.olander.categories.jooq.categories.tables.pojos.Participant
import se.olander.categories.jooq.categories.tables.pojos.User
import se.olander.categories.rest.Endpoints

@Controller
class GameController(@Autowired val dslContext: DSLContext) {

    val endpoints = Endpoints(dslContext)

    @GetMapping("/")
    fun dashboard(model: MutableMap<String, Any>): String {
        model.put("user", endpoints.getSessionUser())
        model.put("stats", Stats(
                totalNumberOfUsers = dslContext.selectCount()
                        .from(Tables.USER)
                        .fetchOneInto(Int::class.java),
                totalNumberOfGames = dslContext.selectCount()
                        .from(Tables.GAME)
                        .fetchOneInto(Int::class.java),
                totalNumberOfGuesses = dslContext.selectCount()
                        .from(Tables.GUESS)
                        .fetchOneInto(Int::class.java)
        ))

        return "dashboard"
    }

    @GetMapping("/games/{id}")
    fun getGame(@PathVariable("id") gameId: Int, model: MutableMap<String, Any>): String {
        model.put("user", endpoints.getSessionUser())

        val game = endpoints.getGame(gameId)
        val category = endpoints.getCategory(game.categoryId)
        val categoryItems = endpoints.getCategoryItems(game.categoryId)
        val participants = dslContext
                .selectFrom(Tables.PARTICIPANT.join(Tables.USER).onKey(Keys.PARTICIPANT_IBFK_1))
                .where(Tables.PARTICIPANT.GAME_ID.eq(gameId))
                .fetch({ record -> ParticipantModel(
                        record.into(Tables.PARTICIPANT).into(Participant::class.java),
                        record.into(Tables.USER).into(User::class.java)
                )})
        val guesses = endpoints.getGuesses(gameId)
        model.put("game", GameModel(
                game = game,
                category = category,
                categoryItems = categoryItems,
                guesses = guesses,
                participants = participants
        ))

        return "game"
    }

    @PostMapping("/games/{id}/start")
    fun startGame(@PathVariable("id") gameId: Int, model: MutableMap<String, Any>): String {
        endpoints.startGame(gameId)
        return getGame(gameId, model)
    }
}
