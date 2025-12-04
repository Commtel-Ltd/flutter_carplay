//
//  FCPTabBarTemplate.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPTabBarTemplate {
  private(set) var elementId: String
  private var title: String?
  private var templates: [CPTemplate]
  private var objcTemplates: [FCPTabBarChildTemplate]

  init(obj: [String : Any]) {
    self.elementId = obj["_elementId"] as! String
    self.title = obj["title"] as? String
    self.objcTemplates = (obj["templates"] as! Array<[String: Any]>).map {
      FCPTabBarTemplate.createChildTemplate(from: $0)
    }
    self.templates = self.objcTemplates.map {
      $0.get
    }
  }

  /// Creates the appropriate child template based on the template data.
  /// Detects the template type by checking for type-specific properties.
  private static func createChildTemplate(from obj: [String: Any]) -> FCPTabBarChildTemplate {
    // Check for CPListTemplate - has 'sections' property
    if obj["sections"] != nil {
      return FCPListTemplate(obj: obj, templateType: FCPListTemplateTypes.PART_OF_GRID_TEMPLATE)
    }
    // Check for CPGridTemplate - has 'buttons' property
    else if obj["buttons"] != nil {
      return FCPGridTemplate(obj: obj)
    }
    // Check for CPInformationTemplate - has 'informationItems' and 'layout' properties
    else if obj["informationItems"] != nil && obj["layout"] != nil {
      return FCPInformationTemplate(obj: obj)
    }
    // Check for CPPointOfInterestTemplate - has 'poi' property
    else if obj["poi"] != nil {
      return FCPPointOfInterestTemplate(obj: obj)
    }
    // Default to list template for backward compatibility
    else {
      return FCPListTemplate(obj: obj, templateType: FCPListTemplateTypes.PART_OF_GRID_TEMPLATE)
    }
  }

  var get: CPTemplate {
    let tabBarTemplate = CPTabBarTemplate.init(templates: templates)
    tabBarTemplate.tabTitle = title
    tabBarTemplate.elementId = self.elementId
    return tabBarTemplate
  }

  public func getTemplates() -> [FCPTabBarChildTemplate] {
    return objcTemplates
  }

  public func getRawTemplates() -> [CPTemplate] {
    return templates
  }

  public func updateTemplates(templates: [FCPTabBarChildTemplate]) {
    var existingMap = Dictionary(uniqueKeysWithValues: zip(self.objcTemplates.map { $0.elementId }, self.templates))

    self.objcTemplates = templates
    self.templates = templates.map { template in
      if let existing = existingMap[template.elementId] {
        return existing // reuse existing template
      } else {
        return template.get // create new template
      }
    }
  }
}

@available(iOS 14.0, *)
extension FCPTabBarTemplate: FCPRootTemplate { }
