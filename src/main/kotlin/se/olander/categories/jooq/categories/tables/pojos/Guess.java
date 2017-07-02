/*
 * This file is generated by jOOQ.
*/
package se.olander.categories.jooq.categories.tables.pojos;


import java.io.Serializable;
import java.sql.Timestamp;

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
public class Guess implements Serializable {

    private static final long serialVersionUID = 1473232035;

    private Integer   id;
    private Integer   userId;
    private Integer   gameId;
    private String    guessRaw;
    private Integer   categoryItemId;
    private Timestamp timeGuess;

    public Guess() {}

    public Guess(Guess value) {
        this.id = value.id;
        this.userId = value.userId;
        this.gameId = value.gameId;
        this.guessRaw = value.guessRaw;
        this.categoryItemId = value.categoryItemId;
        this.timeGuess = value.timeGuess;
    }

    public Guess(
        Integer   id,
        Integer   userId,
        Integer   gameId,
        String    guessRaw,
        Integer   categoryItemId,
        Timestamp timeGuess
    ) {
        this.id = id;
        this.userId = userId;
        this.gameId = gameId;
        this.guessRaw = guessRaw;
        this.categoryItemId = categoryItemId;
        this.timeGuess = timeGuess;
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

    public String getGuessRaw() {
        return this.guessRaw;
    }

    public void setGuessRaw(String guessRaw) {
        this.guessRaw = guessRaw;
    }

    public Integer getCategoryItemId() {
        return this.categoryItemId;
    }

    public void setCategoryItemId(Integer categoryItemId) {
        this.categoryItemId = categoryItemId;
    }

    public Timestamp getTimeGuess() {
        return this.timeGuess;
    }

    public void setTimeGuess(Timestamp timeGuess) {
        this.timeGuess = timeGuess;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Guess (");

        sb.append(id);
        sb.append(", ").append(userId);
        sb.append(", ").append(gameId);
        sb.append(", ").append(guessRaw);
        sb.append(", ").append(categoryItemId);
        sb.append(", ").append(timeGuess);

        sb.append(")");
        return sb.toString();
    }
}