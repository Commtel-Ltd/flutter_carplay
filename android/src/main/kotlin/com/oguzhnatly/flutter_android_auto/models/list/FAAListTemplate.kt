package com.oguzhnatly.flutter_android_auto

import com.oguzhnatly.flutter_android_auto.models.FAAHeaderAction

data class FAAListTemplate(
    val elementId: String,
    val title: String,
    val sections: List<FAAListSection>,
    val headerAction: FAAHeaderAction?,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAListTemplate {
            val elementId = map["_elementId"] as? String ?: ""
            val title = map["title"] as? String ?: ""
            val sections = (map["sections"] as? List<*>)?.mapNotNull {
                (it as? Map<*, *>)?.mapKeys { entry -> entry.key.toString() }
                    ?.let { FAAListSection.fromJson(it) }
            } ?: emptyList()
            @Suppress("UNCHECKED_CAST")
            val headerActionMap = map["headerAction"] as? Map<String, Any?>
            val headerAction = FAAHeaderAction.fromJson(headerActionMap)

            return FAAListTemplate(elementId, title, sections, headerAction)
        }
    }
}
