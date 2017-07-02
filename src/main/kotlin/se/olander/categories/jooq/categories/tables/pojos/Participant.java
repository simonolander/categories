/*
 * This file is generated by jOOQ.
*/
package se.olander.categories.jooq.categories.tables.pojos;


import java.io.Serializable;

import javax.annotation.Generated;


/**
 * This class is generated by jOOQ.
 */
@Generated(
    value = {
        "http://www.jooq.org",
        "jOOQ version:3.9.3"
    },
    comments = "This class is generated by jOOQ"
)
@SuppressWarnings({ "all", "unchecked", "rawtypes" })
public class Participant implements Serializable {

    private static final long serialVersionUID = -561197761;

    private Integer id;
    private Integer userId;
    private Integer gameId;
    private Byte    admin;

    public Participant() {}

    public Participant(Participant value) {
        this.id = value.id;
        this.userId = value.userId;
        this.gameId = value.gameId;
        this.admin = value.admin;
    }

    public Participant(
        Integer id,
        Integer userId,
        Integer gameId,
        Byte    admin
    ) {
        this.id = id;
        this.userId = userId;
        this.gameId = gameId;
        this.admin = admin;
    }

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return this.userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getGameId() {
        return this.gameId;
    }

    public void setGameId(Integer gameId) {
        this.gameId = gameId;
    }

    public Byte getAdmin() {
        return this.admin;
    }

    public void setAdmin(Byte admin) {
        this.admin = admin;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Participant (");

        sb.append(id);
        sb.append(", ").append(userId);
        sb.append(", ").append(gameId);
        sb.append(", ").append(admin);

        sb.append(")");
        return sb.toString();
    }
}
