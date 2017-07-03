package se.olander.categories.dto

import se.olander.categories.jooq.categories.tables.pojos.*

/**
 * Created by sios on 2017-07-03.
 */
class GameModel (val game: Game, val participants: List<ParticipantModel>, val category: Category, val categoryItems: List<CategoryItem>, val guesses: List<Guess>) {

    fun getAdmin(): ParticipantModel? {
        return participants.firstOrNull({ participantModel -> participantModel.admin == 1 })
    }
}
