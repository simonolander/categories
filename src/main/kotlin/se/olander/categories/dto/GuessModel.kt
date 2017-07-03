package se.olander.categories.dto

import se.olander.categories.jooq.categories.tables.pojos.CategoryItem
import se.olander.categories.jooq.categories.tables.pojos.Guess
import se.olander.categories.jooq.categories.tables.pojos.Participant
import se.olander.categories.jooq.categories.tables.pojos.User
import java.sql.Timestamp

class GuessModel(val guess: Guess?, val categoryItem: CategoryItem?) {

}
