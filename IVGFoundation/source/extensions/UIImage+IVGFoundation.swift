//
//  UIImage+IVGFoundation
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 1/5/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import UIKit

public extension UIImage {

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    public func with(size targetSize: CGSize) -> UIImage? {
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let ratio = (widthRatio > heightRatio) ? heightRatio : widthRatio
        let newBounds = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(newBounds.size, false, 1.0)
        draw(in: newBounds)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

}
