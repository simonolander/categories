package se.olander.categories.dto

import se.olander.categories.jooq.categories.tables.pojos.*

/**
 * Created by sios on 2017-07-03.
 */
class GameModel (val game: Game, val participants: List<ParticipantModel>, val category: Category, val categoryItems: List<CategoryItem>, val guesses: List<Guess>) {

    fun getAdmin(): ParticipantModel? {
        return participants.firstOrNull { participantModel -> participantModel.admin == 1 }
    }

    fun hasNotStarted(): Boolean {
        return game.timeStart == null
    }

    fun isOngoing(): Boolean {
        return game.timeStart != null && game.timeEnd == null
    }

    fun hasEnded(): Boolean {
        return game.timeEnd != null
    }

    fun canStart(userId: Int): Boolean {
        return hasNotStarted() && getAdmin()?.userId == userId
    }

    fun latestGuess(userId: Int): GuessModel {
        val guess = guesses
                .sortedBy { guess -> guess.createdTime }
                .lastOrNull { guess -> guess.userId == userId }

        val categoryItem = categoryItems.firstOrNull { categoryItem -> categoryItem.id == guess?.categoryItemId }
        return GuessModel(
                guess = guess,
                categoryItem = categoryItem
        )
    }

    fun getCurrentAnswering(): Int? {
        return participants.firstOrNull { participantModel -> participantModel.status == ParticipantStatus.ANSWERING }?.userId
    }
}
