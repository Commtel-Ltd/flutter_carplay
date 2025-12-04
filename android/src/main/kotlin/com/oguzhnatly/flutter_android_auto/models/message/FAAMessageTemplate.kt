package com.oguzhnatly.flutter_android_auto.models.message

import com.oguzhnatly.flutter_android_auto.models.FAAAction
import com.oguzhnatly.flutter_android_auto.models.FAAHeaderAction

/**
 * Represents a message template for Android Auto.
 * Maps to the Dart AAMessageTemplate model.
 *
 * According to Android Auto docs:
 * - MessageTemplate displays a message with optional title, icon, and actions
 * - Up to 2 action buttons can be added
 * - Can show a loading state instead of the message
 */
data class FAAMessageTemplate(
    val elementId: String,
    val message: String,
    val title: String? = null,
    val icon: String? = null,
    val headerAction: FAAHeaderAction? = null,
    val actions: List<FAAAction> = emptyList(),
    val isLoading: Boolean = false,
    val showBackButton: Boolean = true,
    val debugMessage: String? = null,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAMessageTemplate {
            val elementId = map["_elementId"] as? String ?: ""
            val message = map["message"] as? String ?: ""
            val title = map["title"] as? String
            val icon = map["icon"] as? String
            val isLoading = map["isLoading"] as? Boolean ?: false
            val showBackButton = map["showBackButton"] as? Boolean ?: true
            val debugMessage = map["debugMessage"] as? String

            @Suppress("UNCHECKED_CAST")
            val headerActionMap = map["headerAction"] as? Map<String, Any?>
            val headerAction = FAAHeaderAction.fromJson(headerActionMap)

            val actions = (map["actions"] as? List<*>)?.mapNotNull {
                (it as? Map<*, *>)?.mapKeys { entry -> entry.key.toString() }
                    ?.let { actionMap ->
                        @Suppress("UNCHECKED_CAST")
                        FAAAction.fromJson(actionMap as Map<String, Any?>)
                    }
            } ?: emptyList()

            return FAAMessageTemplate(
                elementId = elementId,
                message = message,
                title = title,
                icon = icon,
                headerAction = headerAction,
                actions = actions,
                isLoading = isLoading,
                showBackButton = showBackButton,
                debugMessage = debugMessage
            )
        }
    }
}
