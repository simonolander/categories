/*
 * This file is generated by jOOQ.
*/
package se.olander.categories.jooq.categories.tables.daos;


import java.sql.Timestamp;
import java.util.List;

import javax.annotation.Generated;

import org.jooq.Configuration;
import org.jooq.impl.DAOImpl;

import se.olander.categories.jooq.categories.tables.Game;
import se.olander.categories.jooq.categories.tables.records.GameRecord;


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
public class GameDao extends DAOImpl<GameRecord, se.olander.categories.jooq.categories.tables.pojos.Game, Integer> {

    /**
     * Create a new GameDao without any configuration
     */
    public GameDao() {
        super(Game.GAME, se.olander.categories.jooq.categories.tables.pojos.Game.class);
    }

    /**
     * Create a new GameDao with an attached configuration
     */
    public GameDao(Configuration configuration) {
        super(Game.GAME, se.olander.categories.jooq.categories.tables.pojos.Game.class, configuration);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    protected Integer getId(se.olander.categories.jooq.categories.tables.pojos.Game object) {
        return object.getId();
    }

    /**
     * Fetch records that have <code>id IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Game> fetchById(Integer... values) {
        return fetch(Game.GAME.ID, values);
    }

    /**
     * Fetch a unique record that has <code>id = value</code>
     */
    public se.olander.categories.jooq.categories.tables.pojos.Game fetchOneById(Integer value) {
        return fetchOne(Game.GAME.ID, value);
    }

    /**
     * Fetch records that have <code>name IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Game> fetchByName(String... values) {
        return fetch(Game.GAME.NAME, values);
    }

    /**
     * Fetch records that have <code>category_id IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Game> fetchByCategoryId(Integer... values) {
        return fetch(Game.GAME.CATEGORY_ID, values);
    }

    /**
     * Fetch records that have <code>time_start IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Game> fetchByTimeStart(Timestamp... values) {
        return fetch(Game.GAME.TIME_START, values);
    }

    /**
     * Fetch records that have <code>time_end IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Game> fetchByTimeEnd(Timestamp... values) {
        return fetch(Game.GAME.TIME_END, values);
    }

    /**
     * Fetch records that have <code>updated_time IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Game> fetchByUpdatedTime(Timestamp... values) {
        return fetch(Game.GAME.UPDATED_TIME, values);
    }
}
