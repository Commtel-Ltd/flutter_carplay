import 'package:uuid/uuid.dart';

import '../template.dart';
import 'grid_item.dart';

/// A template object that displays and manages a grid of items for Android Auto.
///
/// According to Android Auto docs:
/// - GridTemplate displays items in a grid layout
/// - Minimum 6 items can be shown (limit varies by vehicle)
/// - Each item can have an image, title, and optional text
/// - Use ConstraintManager to determine the specific limit for each vehicle
///
/// Design guidelines:
/// - Associate an action with each grid item
/// - Clearly indicate item state through image, icon, or text variations
/// - Avoid combining action strip and floating action button
class AAGridTemplate implements AATemplate {
  /// Unique id of the object.
  final String _elementId;

  /// A title displayed in the template's header/navigation bar.
  final String title;

  /// The array of grid items displayed on the template.
  /// Note: There is a minimum of 6 items that can be shown,
  /// but the actual limit varies by vehicle.
  final List<AAGridItem> items;

  /// Creates [AAGridTemplate] to display a grid of items.
  ///
  /// [title] - The title shown in the header
  /// [items] - List of [AAGridItem] objects to display in the grid
  AAGridTemplate({
    required this.title,
    required this.items,
  }) : _elementId = const Uuid().v4();

  @override
  String get uniqueId => _elementId;

  @override
  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'title': title,
        'items': items.map((AAGridItem item) => item.toJson()).toList(),
      };
}
