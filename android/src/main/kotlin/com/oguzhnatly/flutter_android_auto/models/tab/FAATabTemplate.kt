package com.oguzhnatly.flutter_android_auto.models.tab

/**
 * Represents a tab template for Android Auto.
 * Maps to the Dart AATabTemplate model.
 *
 * According to Android Auto docs:
 * - TabTemplate requires 2-4 tabs
 * - Each tab can contain: ListTemplate, GridTemplate, MessageTemplate,
 *   PaneTemplate, SearchTemplate, or NavigationTemplate
 * - Requires CarApi level 6 or higher
 * - Header action must be APP_ICON type (not BACK)
 */
data class FAATabTemplate(
    val elementId: String,
    val tabs: List<FAATab>,
    val tabContents: Map<String, Map<String, Any?>>,
    val activeTabContentId: String,
    val isLoading: Boolean = false,
    val onTabSelected: Boolean = false,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAATabTemplate {
            val elementId = map["_elementId"] as? String ?: ""
            val activeTabContentId = map["activeTabContentId"] as? String ?: ""
            val isLoading = map["isLoading"] as? Boolean ?: false
            val onTabSelected = map["onTabSelected"] as? Boolean ?: false

            val tabs = (map["tabs"] as? List<*>)?.mapNotNull {
                (it as? Map<*, *>)?.mapKeys { entry -> entry.key.toString() }
                    ?.let { tabMap ->
                        @Suppress("UNCHECKED_CAST")
                        FAATab.fromJson(tabMap as Map<String, Any?>)
                    }
            } ?: emptyList()

            @Suppress("UNCHECKED_CAST")
            val tabContents = (map["tabContents"] as? Map<*, *>)?.mapKeys {
                it.key.toString()
            }?.mapValues {
                it.value as Map<String, Any?>
            } ?: emptyMap()

            return FAATabTemplate(
                elementId = elementId,
                tabs = tabs,
                tabContents = tabContents,
                activeTabContentId = activeTabContentId,
                isLoading = isLoading,
                onTabSelected = onTabSelected
            )
        }
    }
}
