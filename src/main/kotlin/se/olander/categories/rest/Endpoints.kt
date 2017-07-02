package se.olander.categories.rest

import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import se.olander.categories.jooq.categories.Tables
import se.olander.categories.jooq.categories.tables.daos.CategoriesDao
import se.olander.categories.jooq.categories.tables.daos.CategoryItemsDao
import se.olander.categories.jooq.categories.tables.pojos.Categories
import se.olander.categories.jooq.categories.tables.pojos.CategoryItems

@RestController
@RequestMapping("rest")
class Endpoints @Autowired constructor(dslContext: DSLContext) {

    var dslContext = dslContext

    var categoriesDao = CategoriesDao(dslContext.configuration())

    var categoryItemsDao = CategoryItemsDao(dslContext.configuration())

    @GetMapping("categories")
    fun getCategories() : MutableList<MutableMap<String, Any>>? {
        return dslContext
                .selectFrom(Tables.CATEGORIES_)
                .fetchMaps()
    }

    @GetMapping("categories/{id}")
    fun getCategory(@PathVariable("id") categoryId: Int): Categories? {
        return categoriesDao.fetchOneById(categoryId)
    }

    @GetMapping("categories/{id}/items")
    fun getCategoryItems(@PathVariable("id") categoryId: Int): List<CategoryItems>? {
        return categoryItemsDao.fetchByCategoryId(categoryId)
    }g
}
