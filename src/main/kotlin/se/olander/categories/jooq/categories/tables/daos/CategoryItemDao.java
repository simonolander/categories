/*
 * This file is generated by jOOQ.
*/
package se.olander.categories.jooq.categories.tables.daos;


import java.util.List;

import javax.annotation.Generated;

import org.jooq.Configuration;
import org.jooq.impl.DAOImpl;

import se.olander.categories.jooq.categories.tables.CategoryItem;
import se.olander.categories.jooq.categories.tables.records.CategoryItemRecord;


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
public class CategoryItemDao extends DAOImpl<CategoryItemRecord, se.olander.categories.jooq.categories.tables.pojos.CategoryItem, Integer> {

    /**
     * Create a new CategoryItemDao without any configuration
     */
    public CategoryItemDao() {
        super(CategoryItem.CATEGORY_ITEM, se.olander.categories.jooq.categories.tables.pojos.CategoryItem.class);
    }

    /**
     * Create a new CategoryItemDao with an attached configuration
     */
    public CategoryItemDao(Configuration configuration) {
        super(CategoryItem.CATEGORY_ITEM, se.olander.categories.jooq.categories.tables.pojos.CategoryItem.class, configuration);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    protected Integer getId(se.olander.categories.jooq.categories.tables.pojos.CategoryItem object) {
        return object.getId();
    }

    /**
     * Fetch records that have <code>id IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.CategoryItem> fetchById(Integer... values) {
        return fetch(CategoryItem.CATEGORY_ITEM.ID, values);
    }

    /**
     * Fetch a unique record that has <code>id = value</code>
     */
    public se.olander.categories.jooq.categories.tables.pojos.CategoryItem fetchOneById(Integer value) {
        return fetchOne(CategoryItem.CATEGORY_ITEM.ID, value);
    }

    /**
     * Fetch records that have <code>name IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.CategoryItem> fetchByName(String... values) {
        return fetch(CategoryItem.CATEGORY_ITEM.NAME, values);
    }

    /**
     * Fetch records that have <code>category_id IN (values)</code>
     */
    public List<se.olander.categories.jooq.categories.tables.pojos.CategoryItem> fetchByCategoryId(Integer... values) {
        return fetch(CategoryItem.CATEGORY_ITEM.CATEGORY_ID, values);
    }
}
