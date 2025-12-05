import 'package:uuid/uuid.dart';

/// Represents a single tab in an [AATabTemplate] for Android Auto.
///
/// According to Android Auto docs:
/// - Each tab requires a title and an icon
/// - The contentId is used to identify which tab content to display
/// - TabTemplate supports 2-4 tabs
///
/// Design guidelines:
/// - Use short, descriptive labels for tabs
/// - Icons should clearly represent the tab's purpose
/// - Keep the number of tabs minimal for easier driver interaction
class AATab {
  /// Unique id of the object used as contentId for tab identification.
  final String _elementId;

  /// The title text displayed on the tab.
  /// Should be short and descriptive.
  final String title;

  /// Icon path - supports Flutter assets.
  /// This icon is displayed on the tab.
  final String icon;

  /// Creates [AATab] to represent a single tab.
  ///
  /// [title] - The text displayed on the tab
  /// [icon] - The icon displayed on the tab (Flutter asset path)
  AATab({
    required this.title,
    required this.icon,
  }) : _elementId = const Uuid().v4();

  /// The unique identifier for this tab, used as contentId.
  String get contentId => _elementId;

  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'title': title,
        'icon': icon,
      };
}
