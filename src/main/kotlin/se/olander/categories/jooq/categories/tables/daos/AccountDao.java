/*
 * This file is generated by jOOQ.
*/
package se.olander.categories.jooq.categories.tables.daos;


import java.sql.Timestamp;
import java.util.List;

import javax.annotation.Generated;

import org.jooq.Configuration;
import org.jooq.impl.DAOImpl;

import se.olander.categories.jooq.categories.tables.Account;
import se.olander.categories.jooq.categories.tables.records.AccountRecord;


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
public class AccountDao extends DAOImpl<AccountRecord, se.olander.categories.jooq.categories.tables.pojos.Account, Integer> {

    /**
     * Create a new AccountDao without any configuration
     */
    public AccountDao() {
        super(Account.ACCOUNT, se.olander.categories.jooq.categories.tables.pojos.Account.class);
    }

    /**
     * Create a new AccountDao with an attached configuration
     */
    public AccountDao(Configuration configuration) {
        super(Account.ACCOUNT, se.olander.categories.jooq.categories.tables.pojos.Account.class, configuration);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    protected Integer getId(se.olander.categories.jooq.categories.tables.pojos.Account object) {
        return object.getId();
    }

    /**
     * Fetch records that have <code>id IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Account> fetchById(Integer... values) {
        return fetch(Account.ACCOUNT.ID, values);
    }

    /**
     * Fetch a unique record that has <code>id = value</code>
     */
    public se.olander.categories.jooq.categories.tables.pojos.Account fetchOneById(Integer value) {
        return fetchOne(Account.ACCOUNT.ID, value);
    }

    /**
     * Fetch records that have <code>user_id IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Account> fetchByUserId(Integer... values) {
        return fetch(Account.ACCOUNT.USER_ID, values);
    }

    /**
     * Fetch records that have <code>email_address IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Account> fetchByEmailAddress(String... values) {
        return fetch(Account.ACCOUNT.EMAIL_ADDRESS, values);
    }

    /**
     * Fetch a unique record that has <code>email_address = value</code>
     */
    public se.olander.categories.jooq.categories.tables.pojos.Account fetchOneByEmailAddress(String value) {
        return fetchOne(Account.ACCOUNT.EMAIL_ADDRESS, value);
    }

    /**
     * Fetch records that have <code>password IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Account> fetchByPassword(String... values) {
        return fetch(Account.ACCOUNT.PASSWORD, values);
    }

    /**
     * Fetch records that have <code>created_time IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.Account> fetchByCreatedTime(Timestamp... values) {
        return fetch(Account.ACCOUNT.CREATED_TIME, values);
    }
}