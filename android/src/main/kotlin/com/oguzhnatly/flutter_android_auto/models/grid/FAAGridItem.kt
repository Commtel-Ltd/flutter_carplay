package com.oguzhnatly.flutter_android_auto.models.grid

/**
 * Represents a grid item for Android Auto's GridTemplate.
 * Maps to the Dart AAGridItem model.
 */
data class FAAGridItem(
    val elementId: String,
    val title: String,
    val text: String? = null,
    val image: String? = null,
    val isEnabled: Boolean = true,
    val isOnPressListenerActive: Boolean,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAGridItem {
            val elementId = map["_elementId"] as? String ?: ""
            val title = map["title"] as? String ?: ""
            val text = map["text"] as? String
            val image = map["image"] as? String
            val isEnabled = map["isEnabled"] as? Boolean ?: true
            val isOnPressListenerActive = map["onPress"] as? Boolean ?: false

            return FAAGridItem(
                elementId = elementId,
                title = title,
                text = text,
                image = image,
                isEnabled = isEnabled,
                isOnPressListenerActive = isOnPressListenerActive
            )
        }
    }
}
