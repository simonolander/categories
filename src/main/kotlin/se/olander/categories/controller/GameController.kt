package se.olander.categories.controller;

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import se.olander.categories.exception.ResourceNotFoundException
import se.olander.categories.jooq.categories.tables.pojos.Game
import se.olander.categories.service.Service

@Controller
class GameController @Autowired constructor(val service: Service) {

    @GetMapping("/")
    fun dashboard(model: MutableMap<String, Any>): String {
        val user = service.getSessionUser()
        val notEndedGames = service.getNotEndedGameModels()
        model.put("user", user)
        model.put("stats", service.getStats())
        model.put("notStartedGames", notEndedGames.filter { game -> game.canJoin(user.id) })
        model.put("myNotEndedGames", notEndedGames.filter { game -> game.isParticipant(user.id) })
        model.put("categories", service.getCategories().sortedBy { category -> category.name })
        model.put("hasAccount", service.hasAccount(user.id))

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

    @GetMapping("/joinGame")
    fun joinGame(model: MutableMap<String, Any>): String {
        model.put("user", service.getSessionUser())

        return "form_join_game"
    }

    @PostMapping("/joinGame")
    fun joinGame(model: MutableMap<String, Any>, gameId: Int): String {
        service.joinGame(gameId)
        return "redirect:/games/$gameId"
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

    @GetMapping("login")
    fun getLogin(model: MutableMap<String, Any>): String {
        return "login"
    }

    @PostMapping("login")
    fun postLogin(model: MutableMap<String, Any>, emailAddress: String, password: String): String {
        service.login(emailAddress, password)
        return "redirect:/"
    }

    @PostMapping("updateUserName")
    fun updateUserName(model: MutableMap<String, Any>, name: String): String {
        service.updateUserName(name)
        return "redirect:/"
    }

    @PostMapping("createAccount")
    fun createAccount(model: MutableMap<String, Any>, emailAddress: String, password: String): String {
        val user = service.getSessionUser()
        service.createAccount(user.id, emailAddress, password)
        return "redirect:/"
    }

    @ExceptionHandler(ResourceNotFoundException::class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    fun handleResourceNotFoundException(e: ResourceNotFoundException): String {
        return "errors/not_found"
    }
}
