/*
 * This file is generated by jOOQ.
*/
package se.olander.categories.jooq.categories.tables;


import java.util.Arrays;
import java.util.List;

import javax.annotation.Generated;

import org.jooq.Field;
import org.jooq.ForeignKey;
import org.jooq.Identity;
import org.jooq.Schema;
import org.jooq.Table;
import org.jooq.TableField;
import org.jooq.UniqueKey;
import org.jooq.impl.TableImpl;

import se.olander.categories.jooq.categories.Categories;
import se.olander.categories.jooq.categories.Keys;
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
public class CategoryItem extends TableImpl<CategoryItemRecord> {

    private static final long serialVersionUID = -116180344;

    /**
     * The reference instance of <code>categories.category_item</code>
     */
    public static final CategoryItem CATEGORY_ITEM = new CategoryItem();

    /**
     * The class holding records for this type
     */
    @Override
    public Class<CategoryItemRecord> getRecordType() {
        return CategoryItemRecord.class;
    }

    /**
     * The column <code>categories.category_item.id</code>.
     */
    public final TableField<CategoryItemRecord, Integer> ID = createField("id", org.jooq.impl.SQLDataType.INTEGER.nullable(false), this, "");

    /**
     * The column <code>categories.category_item.name</code>.
     */
    public final TableField<CategoryItemRecord, String> NAME = createField("name", org.jooq.impl.SQLDataType.VARCHAR.length(255).nullable(false), this, "");

    /**
     * The column <code>categories.category_item.category_id</code>.
     */
    public final TableField<CategoryItemRecord, Integer> CATEGORY_ID = createField("category_id", org.jooq.impl.SQLDataType.INTEGER, this, "");

    /**
     * The column <code>categories.category_item.extra_information</code>.
     */
    public final TableField<CategoryItemRecord, String> EXTRA_INFORMATION = createField("extra_information", org.jooq.impl.SQLDataType.VARCHAR.length(255), this, "");

    /**
     * The column <code>categories.category_item.image_url</code>.
     */
    public final TableField<CategoryItemRecord, String> IMAGE_URL = createField("image_url", org.jooq.impl.SQLDataType.VARCHAR.length(255), this, "");

    /**
     * Create a <code>categories.category_item</code> table reference
     */
    public CategoryItem() {
        this("category_item", null);
    }

    /**
     * Create an aliased <code>categories.category_item</code> table reference
     */
    public CategoryItem(String alias) {
        this(alias, CATEGORY_ITEM);
    }

    private CategoryItem(String alias, Table<CategoryItemRecord> aliased) {
        this(alias, aliased, null);
    }

    private CategoryItem(String alias, Table<CategoryItemRecord> aliased, Field<?>[] parameters) {
        super(alias, null, aliased, parameters, "");
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Schema getSchema() {
        return Categories.CATEGORIES;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Identity<CategoryItemRecord, Integer> getIdentity() {
        return Keys.IDENTITY_CATEGORY_ITEM;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public UniqueKey<CategoryItemRecord> getPrimaryKey() {
        return Keys.KEY_CATEGORY_ITEM_PRIMARY;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<UniqueKey<CategoryItemRecord>> getKeys() {
        return Arrays.<UniqueKey<CategoryItemRecord>>asList(Keys.KEY_CATEGORY_ITEM_PRIMARY);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<ForeignKey<CategoryItemRecord, ?>> getReferences() {
        return Arrays.<ForeignKey<CategoryItemRecord, ?>>asList(Keys.CATEGORY_ITEM_IBFK_1);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public CategoryItem as(String alias) {
        return new CategoryItem(alias, this);
    }

    /**
     * Rename this table
     */
    @Override
    public CategoryItem rename(String name) {
        return new CategoryItem(name, null);
    }
}
