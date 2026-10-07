import 'package:uuid/uuid.dart';

class AAHeaderAction {
  final String _elementId;

  final String title;

  final void Function() onPressed;

  AAHeaderAction._({required this.title, required this.onPressed})
    : _elementId = const Uuid().v4();

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
