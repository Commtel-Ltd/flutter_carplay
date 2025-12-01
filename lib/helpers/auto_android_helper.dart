import 'package:flutter_carplay/aa_models/grid/grid_item.dart';
import 'package:flutter_carplay/aa_models/grid/grid_template.dart';
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

      /*if (t.runtimeType.toString() == (AATabBarTemplate).toString()) {
        for (var template in t.templates) {
          listTemplates.add(template);
        }
      } else*/
      if (t is AAListTemplate) {
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

      /*if (t.runtimeType.toString() == (AATabBarTemplate).toString()) {
        for (var template in t.templates) {
          if (template is AAGridTemplate) {
            gridTemplates.add(template);
          }
        }
      } else*/
      if (t is AAGridTemplate) {
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

  String makeFAAChannelId({String event = ''}) =>
      'com.oguzhnatly.flutter_android_auto$event';
}
