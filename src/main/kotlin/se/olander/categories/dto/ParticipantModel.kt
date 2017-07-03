package se.olander.categories.dto

import se.olander.categories.jooq.categories.tables.pojos.Participant
import se.olander.categories.jooq.categories.tables.pojos.User
import java.sql.Timestamp

class ParticipantModel(participant: Participant?, user: User?) {
    val participantId: Int? = participant?.id
    val gameId: Int? = participant?.gameId
    val admin: Int? = participant?.admin
    val status: Int? = participant?.status
    val statusText: String = ParticipantStatus.translate(status)
    val userId: Int? = participant?.userId
    val name: String? = user?.name
    val createdTime: Timestamp? = user?.createdTime
}
