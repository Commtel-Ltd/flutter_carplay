//
//  FCPExtensions.swift
//  flutter_carplay
//
//  Created by Oguzhan Atalay on 21.08.2021.
//

import UIKit

extension UIImage {
  convenience init?(withURL url: URL) throws {
    let imageData = try Data(contentsOf: url)
    self.init(data: imageData)
  }

  @available(iOS 14.0, *)
  func fromCorrectSource(name: String) -> UIImage {
    // 0. Base64 support (raw or data URL)
    if name.starts(with: "data:image") || name.count > 100 {
      if let img = fromBase64(dataString: name) {
        return img
      }
    }

    // 1. Remote URL
    if name.starts(with: "http") {
      return fromUrl(url: name)
    // 2. Local file URL
    } else if name.starts(with: "file://") {
      return fromFile(path: name)
    }

    // 3. Flutter asset (default behaviour)
    return fromFlutterAsset(name: name)
  }

  @available(iOS 14.0, *)
  func fromFlutterAsset(name: String) -> UIImage {
    let key: String? = SwiftFlutterCarplayPlugin.registrar?.lookupKey(forAsset: name)
    let image: UIImage? = key != nil ? UIImage(imageLiteralResourceName: key!) : nil
    return image ?? UIImage(systemName: "questionmark")!
  }

  @available(iOS 14.0, *)
  func fromFile(path: String) -> UIImage {
    let cleanPath = path.replacingOccurrences(of: "file://", with: "")
    let image: UIImage? = UIImage(contentsOfFile: cleanPath)
    return image ?? UIImage(systemName: "questionmark")!
  }

  @available(iOS 14.0, *)
  func fromUrl(url: String) -> UIImage {
    let url = URL(string: url)
    let data = try? Data(contentsOf: url!)
    guard let data = data else {
      return UIImage(systemName: "questionmark")!
    }
    return UIImage(data: data) ?? UIImage(systemName: "questionmark")!
  }

  // ?? NEW: Base64 decoder (supports raw base64 and data URLs)
  @available(iOS 14.0, *)
  func fromBase64(dataString: String) -> UIImage? {
    var base64String = dataString

    // Handle data URI form: "data:image/png;base64,...."
    if dataString.starts(with: "data:image") {
      guard let commaIndex = dataString.firstIndex(of: ",") else {
        return nil
      }
      base64String = String(dataString[dataString.index(after: commaIndex)...])
    }

    guard let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
      return nil
    }

    return UIImage(data: data)
  }

  func resizeImageTo(size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    self.draw(in: CGRect(origin: CGPoint.zero, size: size))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
}

extension String {
  func match(_ regex: String) -> [[String]] {
    let nsString = self as NSString
    return (try? NSRegularExpression(pattern: regex, options: []))?
      .matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
      .map { match in
        (0..<match.numberOfRanges).map {
          match.range(at: $0).location == NSNotFound
            ? ""
            : nsString.substring(with: match.range(at: $0))
        }
      } ?? []
  }
}
