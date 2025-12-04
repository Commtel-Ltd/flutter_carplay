//
//  FCPProtocols.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 25.08.2021.
//
import CarPlay

public protocol FCPPresentTemplate: AnyObject {}

public protocol FCPRootTemplate: AnyObject {
  var get: CPTemplate { get }
  var elementId: String { get }
}

/// Protocol for templates that can be used as children of FCPTabBarTemplate.
/// According to Apple's CarPlay documentation, the following templates are allowed:
/// - CPListTemplate (FCPListTemplate)
/// - CPGridTemplate (FCPGridTemplate)
/// - CPInformationTemplate (FCPInformationTemplate)
/// - CPPointOfInterestTemplate (FCPPointOfInterestTemplate)
public protocol FCPTabBarChildTemplate: FCPRootTemplate {}
