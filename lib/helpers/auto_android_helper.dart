import 'package:flutter_carplay/aa_models/template.dart';
import 'package:flutter_carplay/flutter_carplay.dart';

class FlutterAutoAndroidHelper {
  const FlutterAutoAndroidHelper();

  AAListItem? findAAListItem({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (var t in templates) {
      final List<AAListTemplate> listTemplates = [];

      if (t is AATabTemplate) {
        for (var content in t.tabContents.values) {
          if (content is AAListTemplate) {
            listTemplates.add(content);
          }
        }
      } else if (t is AAListTemplate) {
        listTemplates.add(t);
      }

      for (var list in listTemplates) {
        for (var section in list.sections) {
          for (var item in section.items) {
            if (item.uniqueId == elementId) {
              return item;
            }
          }
        }
      }
    }
    return null;
  }

  /// Finds an [AAGridItem] by its element ID within the template history.
  AAGridItem? findAAGridItem({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (var t in templates) {
      final List<AAGridTemplate> gridTemplates = [];

      if (t is AATabTemplate) {
        for (var content in t.tabContents.values) {
          if (content is AAGridTemplate) {
            gridTemplates.add(content);
          }
        }
      } else if (t is AAGridTemplate) {
        gridTemplates.add(t);
      }

      for (var grid in gridTemplates) {
        for (var item in grid.items) {
          if (item.uniqueId == elementId) {
            return item;
          }
        }
      }
    }
    return null;
  }

  /// Finds an [AAHeaderAction] by its element ID within the template history.
  AAHeaderAction? findAAHeaderAction({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (var t in templates) {
      if (t is AAGridTemplate && t.headerAction?.uniqueId == elementId) {
        return t.headerAction;
      }
      if (t is AAListTemplate && t.headerAction?.uniqueId == elementId) {
        return t.headerAction;
      }
      if (t is AAMessageTemplate && t.headerAction?.uniqueId == elementId) {
        return t.headerAction;
      }
    }
    return null;
  }

  /// Finds an [AAAction] by its element ID within the template history.
  AAAction? findAAAction({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (var t in templates) {
      if (t is AAMessageTemplate) {
        for (var action in t.actions) {
          if (action.uniqueId == elementId) {
            return action;
          }
        }
      }
    }
    return null;
  }

  String makeFAAChannelId({String event = ''}) =>
      'com.oguzhnatly.flutter_android_auto$event';
}
