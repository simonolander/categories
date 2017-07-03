package se.olander.categories.controller;

import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import se.olander.categories.dto.Stats
import se.olander.categories.jooq.categories.Tables
import se.olander.categories.rest.Endpoints

@Controller
class DashboardController(@Autowired val dslContext: DSLContext) {

    val endpoints = Endpoints(dslContext)

    @RequestMapping("/")
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

}
