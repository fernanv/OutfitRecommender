//
//  ImageTransformer.swift
//  Armario
//
//  Created by Fernando Villalba  on 19/4/22.
//

import Foundation
import UIKit

class ImageTransformer : ValueTransformer {

  override class func allowsReverseTransformation() -> Bool {
    return true
  }
  
  override func reverseTransformedValue(_ value: Any?) -> Any? {
    if let data = value as? Data {
        return UIImage(data: data)
    }
    return nil
  }
  
  override func transformedValue(_ value: Any?) -> Any? {
    if let image = value as? UIImage {
        return image.pngData()
    }
    return nil
  }
        
}

/* REF: https://www.advancedswift.com/resize-uiimage-no-stretching-swift/ */
extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

