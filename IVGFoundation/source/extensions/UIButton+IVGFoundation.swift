//
//  UIButton+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 2/23/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import UIKit

public extension UIButton {

    public func alignImageRight(withMargin margin: CGFloat) {
        if let imageView = imageView {
            let imageSize = imageView.bounds.size

            let buttonWidth = bounds.size.width
            let offset: CGFloat = imageSize.width
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth-offset-margin, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: offset+margin)
        }
    }

    public func alignImageLeft(withMargin margin: CGFloat, centerText: Bool = false) {
        if let imageView = imageView {
            let imageWidth = imageView.bounds.size.width
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)

            if centerText {
                let titleWidth: CGFloat = titleLabel?.bounds.size.width ?? 0
                let availableTextWidth = bounds.size.width - margin*2 - imageWidth
                let textPadding = (availableTextWidth - titleWidth) / 2.0
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: margin+textPadding, bottom: 0, right: margin)
            } else {
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: margin+imageWidth, bottom: 0, right: margin)
            }
        }
    }

    public func setBackgroundColor(color: UIColor, forState: UIControlState) {
        setBackgroundImage(UIImage(color: color), for: forState)
    }
    
}
