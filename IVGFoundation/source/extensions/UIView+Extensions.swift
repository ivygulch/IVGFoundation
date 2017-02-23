//
//  UIView+Extensions.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 6/15/16.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import UIKit

public extension UIView {

    public class func loadFromNIB(_ nibNameOrNil: String? = nil) -> Self? {
        return loadFromNIB(nibNameOrNil, type: self)
    }

    public class func loadFromNIB<T : UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T? {
        let name = nibNameOrNil ?? String(describing: self).components(separatedBy: ".").first!
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for nibView in nibViews! {
            if let result = nibView as? T {
                return result
            }
        }
        return nil
    }

}
