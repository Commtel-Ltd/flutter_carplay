import 'package:flutter_carplay/controllers/android_auto_controller.dart';
import 'package:uuid/uuid.dart';

import '../../constants/private_constants.dart';
import '../header_action.dart';
import '../template.dart';

abstract class AAMessageTemplateBase implements AATemplate {
  /// Unique id of the object.
  final String _elementId;

  String title;
  String message;

  /// The header action button displayed in the navigation bar.
  /// Can be a back button or a custom action with title/icon.
  /// When not set, pushed templates show the standard back button.
  final AAHeaderAction? headerAction;

  AAMessageTemplateBase({
    required this.title,
    required this.message,
    this.headerAction,
    String? id,
  }) : _elementId = id ?? const Uuid().v4() {
    _validateMessage(message);
  }

  FAAChannelTypes get updateChannelType;

  @override
  String get uniqueId => _elementId;

  @override
  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'title': title,
        'message': message,
        'headerAction': headerAction?.toJson(),
      };

  /// Updates the template content on Android Auto.
  ///
  /// Android Auto templates are immutable. This method asks the native side to
  /// rebuild the message template and invalidate the current screen. Changing
  /// the title or message is treated by Android Auto as a new template step,
  /// not as a refresh of the existing template, and can count toward host
  /// template limits.
  ///
  /// [message] must not be empty. Native update errors are surfaced as
  /// [PlatformException]s from the MethodChannel call.
  Future<void> update({String? title, String? message}) async {
    final nextTitle = title ?? this.title;
    final nextMessage = message ?? this.message;
    _validateMessage(nextMessage);

    await FlutterAndroidAutoController.flutterToNativeModuleStatic(
      updateChannelType,
      {'elementId': _elementId, 'title': nextTitle, 'message': nextMessage},
    );

    updateTemplate(title: nextTitle, message: nextMessage);
  }

  Future<void> setTitle(String title) {
    return update(title: title);
  }

  Future<void> setMessage(String message) {
    return update(message: message);
  }

  void updateTemplate({required String title, required String message}) {
    _validateMessage(message);
    this.title = title;
    this.message = message;
  }

  static void _validateMessage(String message) {
    if (message.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Message cannot be empty');
    }
  }
}
