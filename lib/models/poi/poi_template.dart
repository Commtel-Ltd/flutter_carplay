import 'package:flutter_carplay/models/tabbar/tabbar_child_template.dart';
import 'package:uuid/uuid.dart';

import '../template.dart';
import 'poi.dart';

/// A template object that displays point of interest.
class CPPointOfInterestTemplate implements CPTemplate, CPTabBarChildTemplate {
  /// Unique id of the object.
  final String _elementId = const Uuid().v4();

  /// A title will be shown in the navigation bar.
  final String title;
  final List<CPPointOfInterest> poi;

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

  /// Creates [CPPointOfInterestTemplate]
  CPPointOfInterestTemplate({
    required this.title,
    required this.poi,
    this.systemIcon = 'mappin.circle',
    this.showsTabBadge = false,
  });

  @override
  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'title': title,
        'poi': poi.map((e) => e.toJson()).toList(),
        'systemIcon': systemIcon,
        'showsTabBadge': showsTabBadge,
      };

  @override
  String get uniqueId {
    return _elementId;
  }
}
