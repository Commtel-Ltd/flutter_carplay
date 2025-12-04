import 'package:uuid/uuid.dart';

/// Types of header actions available for Android Auto templates.
enum AAHeaderActionType {
  /// The standard back action that pops the current screen.
  back,

  /// A custom action with a title and optional icon.
  custom,
}

/// A header action button for Android Auto templates.
///
/// Header actions appear in the navigation bar at the top of templates.
/// You can use the standard back action or create a custom action with
/// a title and callback.
class AAHeaderAction {
  /// Unique id of the object.
  final String _elementId;

  /// The type of header action.
  final AAHeaderActionType type;

  /// The title displayed on the action button.
  /// Required for custom actions, ignored for back action.
  final String? title;

  /// The icon to display on the action button (asset path or URL).
  /// Optional, only used for custom actions.
  final String? icon;

  /// Callback fired when the custom action is pressed.
  /// Only used for custom actions.
  final Function()? onPressed;

  /// Creates a back header action.
  ///
  /// This creates the standard Android Auto back button that pops
  /// the current screen from the navigation stack.
  AAHeaderAction.back()
      : _elementId = const Uuid().v4(),
        type = AAHeaderActionType.back,
        title = null,
        icon = null,
        onPressed = null;

  /// Creates a custom header action with a title and callback.
  ///
  /// [title] - The text displayed on the action button
  /// [icon] - Optional icon asset path or URL
  /// [onPressed] - Callback fired when the action is pressed
  AAHeaderAction.custom({
    required String this.title,
    this.icon,
    required Function() this.onPressed,
  })  : _elementId = const Uuid().v4(),
        type = AAHeaderActionType.custom;

  /// The unique identifier for this action.
  String get uniqueId => _elementId;

  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'type': type.name,
        'title': title,
        'icon': icon,
      };
}
