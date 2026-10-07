import 'package:uuid/uuid.dart';

/// A tappable action shown in the header (navigation bar) of an
/// [AAListTemplate] or [AAGridTemplate].
class AAHeaderAction {
  /// Unique id of the object.
  final String _elementId;

  /// The title displayed on the header action.
  final String title;

  /// Callback fired when the user taps the header action.
  final void Function() onPressed;

  AAHeaderAction._({required this.title, required this.onPressed})
    : _elementId = const Uuid().v4();

  /// Creates a custom header action with a [title] and an [onPressed] callback.
  factory AAHeaderAction.custom({
    required String title,
    required void Function() onPressed,
  }) => AAHeaderAction._(title: title, onPressed: onPressed);

  String get uniqueId => _elementId;

  Map<String, dynamic> toJson() => {
    '_elementId': _elementId,
    'title': title,
    'onPressed': true,
  };
}
