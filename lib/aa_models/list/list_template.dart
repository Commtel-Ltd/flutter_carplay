import 'package:uuid/uuid.dart';

import '../header_action.dart';
import '../template.dart';
import 'list_section.dart';

class AAListTemplate implements AATemplate {
  /// Unique id of the object.
  final String _elementId;

  /// A title displayed in the template's header/navigation bar.
  final String title;

  /// The list of sections containing items to display.
  final List<AAListSection> sections;

  /// The header action button displayed in the navigation bar.
  /// Can be a back button or a custom action with title/icon.
  final AAHeaderAction? headerAction;

  AAListTemplate({
    required this.title,
    required this.sections,
    this.headerAction,
  }) : _elementId = const Uuid().v4();

  @override
  String get uniqueId => _elementId;

  @override
  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'title': title,
        'sections':
            sections.map((AAListSection section) => section.toJson()).toList(),
        'headerAction': headerAction?.toJson(),
      };
}
