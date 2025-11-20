import 'package:flutter_carplay/controllers/carplay_controller.dart';
import 'package:uuid/uuid.dart';

/// A grid button object displayed on a grid template.
class CPGridButton {
  /// Unique id of the object.
  final String _elementId = const Uuid().v4();

  /// An array of title variants for the button.
  /// When the system displays the button, it selects the title that best fits the available
  /// screen space, so arrange the titles from most to least preferred when creating a grid button.
  /// Also, localize each title for display to the user, and **be sure to include at least
  /// one title in the array.**
  List<String> titleVariants;

  /// Image asset path in pubspec.yaml file.
  /// For example: images/flutter_logo.png
  ///
  /// **[!] When creating a grid button, do NOT provide an animated image. If you do, the button
  /// uses the first image in the animation sequence.**
  final String image;

  /// A Boolean value that enables and disables the grid button.
  /// Defaults to true.
  bool isEnabled;

  /// Fired after the user taps the button.
  final Function() onPress;

  CPGridButton({
    required this.titleVariants,
    required this.image,
    required this.onPress,
    this.isEnabled = true,
  });

  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'titleVariants': titleVariants,
        'image': image,
        'isEnabled': isEnabled,
      };

  String get uniqueId {
    return _elementId;
  }

  /// Updates the enabled state of this grid button.
  /// Call this method to enable or disable the button in the CarPlay interface.
  void setEnabled(bool enabled) {
    isEnabled = enabled;
    FlutterCarPlayController.updateCPGridButton(this);
  }

  /// Updates the title of this grid button.
  /// When the system displays the button, it selects the title that best fits the available
  /// screen space, so provide a single title string or arrange multiple variants from most to least preferred.
  void updateTitle(String title) {
    titleVariants = [title];
    FlutterCarPlayController.updateCPGridButton(this);
  }

  /// Updates the title variants of this grid button.
  /// When the system displays the button, it selects the title that best fits the available
  /// screen space, so arrange the titles from most to least preferred.
  void updateTitleVariants(List<String> variants) {
    titleVariants = variants;
    FlutterCarPlayController.updateCPGridButton(this);
  }
}
