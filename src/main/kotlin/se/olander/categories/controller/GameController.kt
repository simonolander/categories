package se.olander.categories.controller;

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import se.olander.categories.jooq.categories.tables.pojos.Game
import se.olander.categories.service.Service

@Controller
class GameController @Autowired constructor(val service: Service) {

    @GetMapping("/")
    fun dashboard(model: MutableMap<String, Any>): String {
        model.put("user", service.getSessionUser())
        model.put("stats", service.getStats())

        return "dashboard"
    }

    @GetMapping("/createGame")
    fun createGame(model: MutableMap<String, Any>): String {
        model.put("user", service.getSessionUser())
        model.put("categories", service.getCategories())

        return "form_create_game"
    }

    @PostMapping("/createGame")
    fun createGame(model: MutableMap<String, Any>, game: Game): String {
        val createdGame = service.createGame(game.categoryId, game.name)
        return "redirect:/games/${createdGame.id}"
    }

    @GetMapping("/games/{id}")
    fun getGame(@PathVariable("id") gameId: Int, model: MutableMap<String, Any>): String {
        model.put("user", service.getSessionUser())
        model.put("game", service.getGameModel(gameId))

        return "game"
    }

    @GetMapping("games/{id}/guesses")
    fun getGuesses(@PathVariable("id") gameId: Int, model: MutableMap<String, Any>): String {
        model.put("user", service.getSessionUser())
        model.put("game", service.getGameModel(gameId))

        return "fragments/game/guesses :: guesses"
    }

    @GetMapping("games/{id}/information")
    fun getInformation(@PathVariable("id") gameId: Int, model: MutableMap<String, Any>): String {
        model.put("user", service.getSessionUser())
        model.put("game", service.getGameModel(gameId))

        return "fragments/game/information :: information"
    }

    @GetMapping("games/{id}/participants")
    fun getParticipants(@PathVariable("id") gameId: Int, model: MutableMap<String, Any>): String {
        model.put("user", service.getSessionUser())
        model.put("game", service.getGameModel(gameId))

        return "fragments/game/participants :: participants"
    }
}
