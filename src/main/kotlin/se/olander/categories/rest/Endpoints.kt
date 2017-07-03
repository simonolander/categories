package se.olander.categories.rest

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*
import se.olander.categories.service.Service
import se.olander.categories.jooq.categories.tables.pojos.*

@RestController
@RequestMapping("rest")
class Endpoints @Autowired constructor(val service: Service) {

    @GetMapping("categories")
    fun getCategories() : List<Category> {
        return service.getCategories()
    }

    @GetMapping("categories/{id}")
    fun getCategory(@PathVariable("id") categoryId: Int?): Category {
        return service.getCategory(categoryId)
    }

    @GetMapping("categories/{id}/items")
    fun getCategoryItems(@PathVariable("id") categoryId: Int?): List<CategoryItem> {
        return service.getCategoryItems(categoryId)
    }

    @GetMapping("games")
    fun getGames(): List<Game> {
        return service.getGames()
    }

    @GetMapping("games/{id}")
    fun getGame(@PathVariable("id") gameId: Int): Game {
        return service.getGame(gameId)
    }

    @GetMapping("games/{id}/participants")
    fun getParticipants(@PathVariable("id") gameId: Int): List<Participant> {
        return service.getParticipants(gameId)
    }

    @PostMapping("games/{id}/participants")
    fun joinGame(@PathVariable("id") gameId: Int) {
        service.joinGame(gameId)
    }

    @PostMapping("games")
    fun createGame(categoryId: Int, name: String): Game {
        return service.createGame(categoryId, name)
    }

    @PostMapping("games/{id}/start")
    fun startGame(@PathVariable("id") gameId: Int) {
        service.assertAdmin(gameId)
        service.assertGameNotStarted(gameId)
        service.startGame(gameId)
    }

    @PostMapping("games/{id}/guesses")
    fun makeGuess(@PathVariable("id") gameId: Int, @RequestBody guess: String): Guess {
        service.assertParticipant(gameId)
        service.assertGameOngoing(gameId)
        return service.makeGuess(gameId, guess)
    }

    @GetMapping("games/{id}/guesses")
    fun getGuesses(@PathVariable("id") gameId: Int): List<Guess> {
        return service.getGuesses(gameId)
    }

    @GetMapping("games/{id}/latestUpdated")
    fun getGameLatestUpdated(@PathVariable("id") gameId: Int): Long {
        return service.getGameLatestUpdated(gameId).time
    }
}
