import 'package:flutter_carplay/models/button/bar_button.dart';
import 'package:flutter_carplay/models/grid/grid_button.dart';
import 'package:flutter_carplay/models/tabbar/tabbar_child_template.dart';
import 'package:uuid/uuid.dart';

import '../template.dart';

/// A template object that displays and manages a grid of items.
class CPGridTemplate implements CPTemplate, CPTabBarChildTemplate {
  /// Unique id of the object.
  final String _elementId = const Uuid().v4();

  /// A title will be shown in the navigation bar.
  final String title;

  /// The array of grid buttons as [CPGridButton] displayed on the template.
  final List<CPGridButton> buttons;

  /// Back button object
  final CPBarButton? backButton;

  /// A system icon which will be used in a image that represents the content of the tab.
  ///
  /// SF Symbols provides a set of over 3,100 consistent, highly configurable symbols.
  /// This is only used when this template is part of a [CPTabBarTemplate].
  ///
  /// **See**: [SF Symbols Apple Website](https://developer.apple.com/sf-symbols/)
  @override
  final String systemIcon;

  /// An indicator you use to call attention to the tab.
  ///
  /// When true, a small red indicator will be displayed on the tab.
  /// CarPlay only displays this indicator when the template is part of a tab bar.
  @override
  final bool showsTabBadge;

  /// Creates [CPGridTemplate] in order to display a grid of items as buttons.
  /// When creating the grid template, provide an array of [CPGridButton] objects.
  /// Each button must contain a title that is shown in the grid template's navigation bar.
  CPGridTemplate({
    required this.title,
    required this.buttons,
    this.backButton,
    this.systemIcon = 'square.grid.2x2',
    this.showsTabBadge = false,
  });

  @override
  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'title': title,
        'buttons': buttons.map((e) => e.toJson()).toList(),
        'backButton': backButton?.toJson(),
        'systemIcon': systemIcon,
        'showsTabBadge': showsTabBadge,
      };

  @override
  String get uniqueId {
    return _elementId;
  }
}
