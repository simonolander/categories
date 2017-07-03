package se.olander.categories.dto

object ParticipantStatus {
    val WAITING = 0
    val ANSWERING = 1
    val BANNED = 2
    val ELIMINATED = 3
    val WINNER = 4

    fun translate(status: Int?): String {
        return when (status) {
            WAITING -> "Waiting"
            ANSWERING -> "Answering"
            BANNED -> "Banned"
            ELIMINATED -> "Eliminated"
            WINNER -> "Winner"
            else -> "Unknown"
        }
    }
}
