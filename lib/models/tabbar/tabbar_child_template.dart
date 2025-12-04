import '../template.dart';

/// A marker interface for templates that can be used as children of [CPTabBarTemplate].
///
/// According to Apple's CarPlay documentation, the following templates are allowed
/// within a [CPTabBarTemplate]:
/// - [CPListTemplate]
/// - [CPGridTemplate]
/// - [CPInformationTemplate]
/// - [CPPointOfInterestTemplate]
///
/// This interface provides type safety to ensure only valid template types are used
/// in a tab bar.
abstract interface class CPTabBarChildTemplate implements CPTemplate {
  /// The system icon to display for this tab.
  ///
  /// SF Symbols provides a set of over 3,100 consistent, highly configurable symbols.
  ///
  /// **See**:
  /// - [SF Symbols Apple Website](https://developer.apple.com/sf-symbols/)
  String get systemIcon;

  /// An indicator you use to call attention to the tab.
  ///
  /// When true, a small red indicator will be displayed on the tab.
  /// CarPlay only displays this indicator when the template is part of a tab bar.
  bool get showsTabBadge;
}
