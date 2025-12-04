//
//  FCPGridTemplate.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPGridTemplate {
  private(set) var _super: CPGridTemplate?
  private(set) var elementId: String
  private var title: String
  private var buttons: [CPGridButton]
  private var objcButtons: [FCPGridButton]
  private var objcBackButton: FCPBarButton?
  private var backButton: CPBarButton?
  private var systemIcon: String
  private var showsTabBadge: Bool

  init(obj: [String : Any]) {
    self.elementId = obj["_elementId"] as! String
    self.title = obj["title"] as! String
    self.systemIcon = obj["systemIcon"] as? String ?? "square.grid.2x2"
    self.showsTabBadge = obj["showsTabBadge"] as? Bool ?? false
    self.objcButtons = (obj["buttons"] as! Array<[String : Any]>).map {
      FCPGridButton(obj: $0)
    }
    self.buttons = self.objcButtons.map {
      $0.get
    }
    let backButtonData = obj["backButton"] as? [String : Any]
    if backButtonData != nil {
      self.objcBackButton = FCPBarButton(obj: backButtonData!)
      self.backButton = self.objcBackButton?.get
    }
  }

  var get: CPTemplate {
    let gridTemplate = CPGridTemplate.init(title: self.title, gridButtons: self.buttons)
    gridTemplate.backButton = self.backButton
    gridTemplate.tabImage = UIImage(systemName: systemIcon)
    gridTemplate.showsTabBadge = showsTabBadge
    gridTemplate.elementId = self.elementId
    self._super = gridTemplate
    return gridTemplate
  }

  func getButtons() -> [FCPGridButton] {
    return self.objcButtons
  }
}

@available(iOS 14.0, *)
extension FCPGridTemplate: FCPRootTemplate, FCPTabBarChildTemplate { }
