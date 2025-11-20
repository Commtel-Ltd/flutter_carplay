//
//  FCPGridButton.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPGridButton {
  private(set) var _super: CPGridButton?
  private(set) var elementId: String
  private var titleVariants: [String]
  private var image: String
  private var isEnabled: Bool

  init(obj: [String : Any]) {
    self.elementId = obj["_elementId"] as! String
    self.titleVariants = obj["titleVariants"] as! [String]
    self.image = obj["image"] as! String
    self.isEnabled = obj["isEnabled"] as? Bool ?? true
  }
  
  var get: CPGridButton {
    let gridButton = CPGridButton.init(titleVariants: self.titleVariants,
                                       image: UIImage().fromCorrectSource(name: self.image),
                                       handler: { _ in
      DispatchQueue.main.async {
        FCPStreamHandlerPlugin.sendEvent(type: FCPChannelTypes.onGridButtonPressed,
                                         data: ["elementId": self.elementId])
      }
    })
    gridButton.isEnabled = self.isEnabled
    self._super = gridButton
    return gridButton
  }

  public func setEnabled(_ enabled: Bool) {
    self.isEnabled = enabled
    self._super?.isEnabled = enabled
  }

  public func updateTitleVariants(_ titleVariants: [String]) {
    self.titleVariants = titleVariants
    self._super?.updateTitleVariants(titleVariants)
  }
}
