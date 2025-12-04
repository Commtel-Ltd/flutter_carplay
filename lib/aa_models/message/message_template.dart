import 'package:uuid/uuid.dart';

import '../action.dart';
import '../header_action.dart';
import '../template.dart';

/// A template that displays a message with optional actions for Android Auto.
///
/// According to Android Auto docs:
/// - MessageTemplate displays a message with optional title, icon, and actions
/// - Up to 2 action buttons can be added
/// - Can show a loading state instead of the message
/// - Useful for confirmation dialogs, error messages, or informational screens
///
/// Design guidelines:
/// - Keep messages concise and easy to read while driving
/// - Use action buttons for clear user choices
/// - Consider using loading state while fetching data
class AAMessageTemplate implements AATemplate {
  /// Unique id of the object.
  final String _elementId;

  /// The main message text displayed on the template.
  /// Required unless isLoading is true.
  final String message;

  /// A title displayed in the template's header/navigation bar.
  final String? title;

  /// Icon path - supports Flutter assets, URLs, base64, and file paths.
  /// Displayed alongside the message.
  final String? icon;

  /// The header action button displayed in the navigation bar.
  /// Can be a back button or a custom action with title/icon.
  final AAHeaderAction? headerAction;

  /// Action buttons displayed on the template.
  /// Android Auto supports up to 2 actions.
  final List<AAAction> actions;

  /// A Boolean value that shows a loading spinner instead of the message.
  /// When true, the template displays a loading indicator.
  /// Defaults to false.
  final bool isLoading;

  /// A debug message shown only in debug builds.
  /// Useful for development and testing.
  final String? debugMessage;

  /// Creates [AAMessageTemplate] to display a message with optional actions.
  ///
  /// [message] - The main message text (required unless loading)
  /// [title] - Optional title shown in the header
  /// [icon] - Optional icon displayed with the message
  /// [headerAction] - Optional header action button (back or custom)
  /// [actions] - List of action buttons (max 2)
  /// [isLoading] - Whether to show loading state
  /// [debugMessage] - Optional debug message for development
  AAMessageTemplate({
    required this.message,
    this.title,
    this.icon,
    this.headerAction,
    this.actions = const [],
    this.isLoading = false,
    this.debugMessage,
  }) : _elementId = const Uuid().v4();

  @override
  String get uniqueId => _elementId;

  @override
  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'message': message,
        'title': title,
        'icon': icon,
        'headerAction': headerAction?.toJson(),
        'actions': actions.map((AAAction action) => action.toJson()).toList(),
        'isLoading': isLoading,
        'debugMessage': debugMessage,
      };
}
