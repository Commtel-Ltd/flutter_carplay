import 'package:uuid/uuid.dart';

import '../template.dart';
import 'tab.dart';

/// A template that displays a tab bar with multiple content templates for Android Auto.
///
/// According to Android Auto docs:
/// - TabTemplate requires 2-4 tabs
/// - Each tab can contain: ListTemplate, GridTemplate, MessageTemplate,
///   PaneTemplate, SearchTemplate, or NavigationTemplate
/// - Requires CarApi level 6 or higher
/// - Header action must be APP_ICON type (not BACK)
///
/// Design guidelines:
/// - Use tabs to organize related content into logical groups
/// - Keep tab count minimal (2-4) for easier driver interaction
/// - Tab content should be immediately relevant without deep navigation
class AATabTemplate implements AATemplate {
  /// Unique id of the object.
  final String _elementId;

  /// The list of tabs to display in the tab bar.
  /// Must contain 2-4 tabs.
  final List<AATab> tabs;

  /// A map of tab contentId to template for each tab's content.
  /// Each tab's contentId should map to its corresponding template.
  final Map<String, AATemplate> tabContents;

  /// The contentId of the currently active/selected tab.
  /// Must match a contentId from one of the tabs.
  String _activeTabContentId;

  /// Whether to show a loading state instead of the tab content.
  final bool isLoading;

  /// Callback function that is triggered when a tab is selected.
  /// Receives the contentId of the selected tab.
  final Function(String tabContentId)? onTabSelected;

  /// Creates [AATabTemplate] to display a tabbed interface.
  ///
  /// [tabs] - List of [AATab] objects (2-4 required)
  /// [tabContents] - Map of tab contentId to template for each tab
  /// [activeTabContentId] - Optional initial active tab contentId (defaults to first tab)
  /// [isLoading] - Whether to show loading state
  /// [onTabSelected] - Callback when a tab is selected
  AATabTemplate({
    required this.tabs,
    required this.tabContents,
    String? activeTabContentId,
    this.isLoading = false,
    this.onTabSelected,
  })  : _elementId = const Uuid().v4(),
        _activeTabContentId = activeTabContentId ??
            (tabs.isNotEmpty ? tabs.first.contentId : '');

  @override
  String get uniqueId => _elementId;

  /// Gets the currently active tab's contentId.
  String get activeTabContentId => _activeTabContentId;

  /// Sets the active tab by contentId.
  /// This can be used to programmatically switch tabs.
  set activeTabContentId(String contentId) {
    _activeTabContentId = contentId;
  }

  /// Gets the template for the currently active tab.
  AATemplate? get activeTemplate => tabContents[_activeTabContentId];

  @override
  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'tabs': tabs.map((AATab tab) => tab.toJson()).toList(),
        'tabContents': tabContents.map(
          (String key, AATemplate value) => MapEntry(key, value.toJson()),
        ),
        'activeTabContentId': _activeTabContentId,
        'isLoading': isLoading,
        'onTabSelected': onTabSelected != null,
      };

  /// Updates the active tab and triggers the callback if set.
  void selectTab(String contentId) {
    _activeTabContentId = contentId;
    onTabSelected?.call(contentId);
  }
}
