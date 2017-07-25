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
import se.olander.categories.jooq.categories.tables.records.CategoryItemAlternativeSpellingRecord;


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
public class CategoryItemAlternativeSpelling extends TableImpl<CategoryItemAlternativeSpellingRecord> {

    private static final long serialVersionUID = 1382858090;

    /**
     * The reference instance of <code>categories.category_item_alternative_spelling</code>
     */
    public static final CategoryItemAlternativeSpelling CATEGORY_ITEM_ALTERNATIVE_SPELLING = new CategoryItemAlternativeSpelling();

    /**
     * The class holding records for this type
     */
    @Override
    public Class<CategoryItemAlternativeSpellingRecord> getRecordType() {
        return CategoryItemAlternativeSpellingRecord.class;
    }

    /**
     * The column <code>categories.category_item_alternative_spelling.id</code>.
     */
    public final TableField<CategoryItemAlternativeSpellingRecord, Integer> ID = createField("id", org.jooq.impl.SQLDataType.INTEGER.nullable(false), this, "");

    /**
     * The column <code>categories.category_item_alternative_spelling.category_id</code>.
     */
    public final TableField<CategoryItemAlternativeSpellingRecord, Integer> CATEGORY_ID = createField("category_id", org.jooq.impl.SQLDataType.INTEGER.nullable(false), this, "");

    /**
     * The column <code>categories.category_item_alternative_spelling.category_item_id</code>.
     */
    public final TableField<CategoryItemAlternativeSpellingRecord, Integer> CATEGORY_ITEM_ID = createField("category_item_id", org.jooq.impl.SQLDataType.INTEGER.nullable(false), this, "");

    /**
     * The column <code>categories.category_item_alternative_spelling.spelling</code>.
     */
    public final TableField<CategoryItemAlternativeSpellingRecord, String> SPELLING = createField("spelling", org.jooq.impl.SQLDataType.VARCHAR.length(255), this, "");

    /**
     * Create a <code>categories.category_item_alternative_spelling</code> table reference
     */
    public CategoryItemAlternativeSpelling() {
        this("category_item_alternative_spelling", null);
    }

    /**
     * Create an aliased <code>categories.category_item_alternative_spelling</code> table reference
     */
    public CategoryItemAlternativeSpelling(String alias) {
        this(alias, CATEGORY_ITEM_ALTERNATIVE_SPELLING);
    }

    private CategoryItemAlternativeSpelling(String alias, Table<CategoryItemAlternativeSpellingRecord> aliased) {
        this(alias, aliased, null);
    }

    private CategoryItemAlternativeSpelling(String alias, Table<CategoryItemAlternativeSpellingRecord> aliased, Field<?>[] parameters) {
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
    public Identity<CategoryItemAlternativeSpellingRecord, Integer> getIdentity() {
        return Keys.IDENTITY_CATEGORY_ITEM_ALTERNATIVE_SPELLING;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public UniqueKey<CategoryItemAlternativeSpellingRecord> getPrimaryKey() {
        return Keys.KEY_CATEGORY_ITEM_ALTERNATIVE_SPELLING_PRIMARY;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<UniqueKey<CategoryItemAlternativeSpellingRecord>> getKeys() {
        return Arrays.<UniqueKey<CategoryItemAlternativeSpellingRecord>>asList(Keys.KEY_CATEGORY_ITEM_ALTERNATIVE_SPELLING_PRIMARY, Keys.KEY_CATEGORY_ITEM_ALTERNATIVE_SPELLING_UNIQ__CATEGORY_ID__SPELLING);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<ForeignKey<CategoryItemAlternativeSpellingRecord, ?>> getReferences() {
        return Arrays.<ForeignKey<CategoryItemAlternativeSpellingRecord, ?>>asList(Keys.CATEGORY_ITEM_ALTERNATIVE_SPELLING_IBFK_1, Keys.CATEGORY_ITEM_ALTERNATIVE_SPELLING_IBFK_2);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public CategoryItemAlternativeSpelling as(String alias) {
        return new CategoryItemAlternativeSpelling(alias, this);
    }

    /**
     * Rename this table
     */
    @Override
    public CategoryItemAlternativeSpelling rename(String name) {
        return new CategoryItemAlternativeSpelling(name, null);
    }
}
