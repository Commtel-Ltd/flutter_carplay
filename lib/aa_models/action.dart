import 'package:uuid/uuid.dart';

/// An action button for Android Auto templates.
///
/// Actions are used in templates like MessageTemplate to provide
/// interactive buttons that users can tap.
class AAAction {
  /// Unique id of the object.
  final String _elementId;

  /// The title displayed on the action button.
  final String title;

  /// Callback fired when the action is pressed.
  final Function()? onPressed;

  /// Creates an action button.
  ///
  /// [title] - The text displayed on the button
  /// [onPressed] - Callback fired when the button is pressed
  AAAction({
    required this.title,
    this.onPressed,
  }) : _elementId = const Uuid().v4();

  /// The unique identifier for this action.
  String get uniqueId => _elementId;

  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'title': title,
        'onPressed': onPressed != null,
      };
}
