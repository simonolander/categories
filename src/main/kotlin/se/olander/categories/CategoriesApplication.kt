package se.olander.categories

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication

@SpringBootApplication
class CategoriesApplication

fun main(args: Array<String>) {
    SpringApplication.run(CategoriesApplication::class.java, *args)
}
