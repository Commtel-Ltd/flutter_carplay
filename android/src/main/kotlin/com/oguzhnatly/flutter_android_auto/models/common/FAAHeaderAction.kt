package com.oguzhnatly.flutter_android_auto

data class FAAHeaderAction(
    val elementId: String,
    val title: String,
    val isOnPressListenerActive: Boolean = false,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAHeaderAction {
            val elementId = map["_elementId"] as? String ?: ""
            val title = map["title"] as? String ?: ""
            val isOnPressListenerActive = map["onPressed"] as? Boolean ?: false
            return FAAHeaderAction(elementId, title, isOnPressListenerActive)
        }
    }
}
