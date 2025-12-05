package com.oguzhnatly.flutter_android_auto.models.tab

/**
 * Represents a single tab in an Android Auto TabTemplate.
 * Maps to the Dart AATab model.
 *
 * According to Android Auto docs:
 * - Each tab requires a title and an icon
 * - The contentId (elementId) is used to identify which tab content to display
 * - TabTemplate supports 2-4 tabs
 */
data class FAATab(
    val elementId: String,
    val title: String,
    val icon: String,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAATab {
            val elementId = map["_elementId"] as? String ?: ""
            val title = map["title"] as? String ?: ""
            val icon = map["icon"] as? String ?: ""

            return FAATab(
                elementId = elementId,
                title = title,
                icon = icon
            )
        }
    }
}
