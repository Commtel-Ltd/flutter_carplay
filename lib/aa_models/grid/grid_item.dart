import 'package:uuid/uuid.dart';

/// A grid item object displayed on a grid template for Android Auto.
///
/// Each grid item can have:
/// - A title (required)
/// - Optional secondary text
/// - An image (Flutter asset, URL, base64, or file path)
/// - A tap handler
///
/// According to Android Auto docs:
/// - GridItem requires either a title or an image
/// - Images are scaled to fit 64x64 dp bounding box (IMAGE_TYPE_LARGE)
class AAGridItem {
  /// Unique id of the object.
  final String _elementId;

  /// The primary title text displayed on the grid item.
  final String title;

  /// Optional secondary text displayed below the title.
  final String? text;

  /// Image path - supports Flutter assets, URLs, base64, and file paths.
  /// For example: 'assets/images/icon.png' or 'https://example.com/icon.png'
  final String? image;

  /// A Boolean value that enables and disables the grid item.
  /// Defaults to true.
  final bool isEnabled;

  /// A Boolean value that shows a loading spinner instead of the image.
  /// When true, the grid item displays a loading indicator.
  /// Note: Cannot set loading state and image at the same time in Android Auto.
  /// Defaults to false.
  final bool isLoading;

  /// Fired after the user taps the grid item.
  /// The callback receives a completion function that should be called
  /// when the action is complete, and a reference to self.
  final Function(Function() complete, AAGridItem self)? onPress;

  AAGridItem({
    required this.title,
    this.text,
    this.image,
    this.isEnabled = true,
    this.isLoading = false,
    this.onPress,
  }) : _elementId = const Uuid().v4();

  String get uniqueId => _elementId;

  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'title': title,
        'text': text,
        'image': image,
        'isEnabled': isEnabled,
        'isLoading': isLoading,
        'onPress': onPress != null,
      };
}
