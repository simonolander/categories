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

    fun canJoin(userId: Int): Boolean {
        return hasNotStarted() && !isParticipant(userId)
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

    fun isParticipant(userId: Int): Boolean {
        return participants.any { participant -> participant.userId == userId }
    }

    fun getCategoryItem(categoryItemId: Int?): CategoryItem? {
        return categoryItems.firstOrNull { it.id == categoryItemId }
    }

    fun getParticipant(userId: Int): ParticipantModel {
        return participants.first { it.userId == userId }
    }

    fun getGuessModels(): List<GuessModel> {
        return guesses.sortedBy { it.id }
                .map { GuessModel(it, categoryItems.firstOrNull { item -> item.id == it.categoryItemId }) }
    }

    fun getRemainingCategoryItems(): List<CategoryItem> {
        return categoryItems.filter { item -> guesses.none { it.categoryItemId == item.id } }
    }
}
