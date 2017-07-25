package se.olander.categories.exception

class ResourceNotFoundException(id: Int, type: Type) : RuntimeException("Resource of type $type with id $id not found.") {
    enum class Type {
        GAME,
        CATEGORY,
        USER
    }
}
