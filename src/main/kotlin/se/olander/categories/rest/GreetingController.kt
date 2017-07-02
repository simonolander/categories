package se.olander.categories.rest

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.context.request.RequestContextHolder

@RestController
@RequestMapping("/rest")
class GreetingController {

    @GetMapping("/greeting")
    fun greeting(@RequestParam("name") name: String) : String {
        return "Hello " + name
    }

    @GetMapping("session")
    fun session() : Any {
        return RequestContextHolder.currentRequestAttributes().sessionId
    }
}
