package com.oguzhnatly.flutter_android_auto.models.grid

/**
 * Represents a grid template for Android Auto.
 * Maps to the Dart AAGridTemplate model.
 *
 * According to Android Auto docs:
 * - GridTemplate displays items in a grid layout
 * - Minimum 6 items can be shown (limit varies by vehicle)
 * - Each item can have an image, title, and optional text
 */
data class FAAGridTemplate(
    val elementId: String,
    val title: String,
    val items: List<FAAGridItem>,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAGridTemplate {
            val elementId = map["_elementId"] as? String ?: ""
            val title = map["title"] as? String ?: ""
            val items = (map["items"] as? List<*>)?.mapNotNull {
                (it as? Map<*, *>)?.mapKeys { entry -> entry.key.toString() }
                    ?.let { itemMap ->
                        @Suppress("UNCHECKED_CAST")
                        FAAGridItem.fromJson(itemMap as Map<String, Any?>)
                    }
            } ?: emptyList()

            return FAAGridTemplate(
                elementId = elementId,
                title = title,
                items = items
            )
        }
    }
}
