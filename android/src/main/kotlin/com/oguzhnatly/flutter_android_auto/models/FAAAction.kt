package com.oguzhnatly.flutter_android_auto.models

/**
 * Represents an action button for Android Auto templates.
 * Maps to the Dart AAAction model.
 */
data class FAAAction(
    val elementId: String,
    val title: String,
    val isOnPressedListenerActive: Boolean,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAAction {
            val elementId = map["_elementId"] as? String ?: ""
            val title = map["title"] as? String ?: ""
            val isOnPressedListenerActive = map["onPressed"] as? Boolean ?: false

            return FAAAction(
                elementId = elementId,
                title = title,
                isOnPressedListenerActive = isOnPressedListenerActive
            )
        }
    }
}
