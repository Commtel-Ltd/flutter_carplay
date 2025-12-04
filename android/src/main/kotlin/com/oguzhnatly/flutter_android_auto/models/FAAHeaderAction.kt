package com.oguzhnatly.flutter_android_auto.models

/**
 * Types of header actions available for Android Auto templates.
 */
enum class FAAHeaderActionType {
    back,
    custom
}

/**
 * Represents a header action button for Android Auto templates.
 * Maps to the Dart AAHeaderAction model.
 */
data class FAAHeaderAction(
    val elementId: String,
    val type: FAAHeaderActionType,
    val title: String?,
    val icon: String?,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>?): FAAHeaderAction? {
            if (map == null) return null

            val elementId = map["_elementId"] as? String ?: ""
            val typeString = map["type"] as? String ?: "back"
            val type = try {
                FAAHeaderActionType.valueOf(typeString)
            } catch (e: IllegalArgumentException) {
                FAAHeaderActionType.back
            }
            val title = map["title"] as? String
            val icon = map["icon"] as? String

            return FAAHeaderAction(
                elementId = elementId,
                type = type,
                title = title,
                icon = icon
            )
        }
    }
}
