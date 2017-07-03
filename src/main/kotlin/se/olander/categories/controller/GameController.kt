package se.olander.categories.controller;

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import se.olander.categories.service.Service

@Controller
class GameController @Autowired constructor(val service: Service) {

    @GetMapping("/")
    fun dashboard(model: MutableMap<String, Any>): String {
        model.put("user", service.getSessionUser())
        model.put("stats", service.getStats())

        return "dashboard"
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
