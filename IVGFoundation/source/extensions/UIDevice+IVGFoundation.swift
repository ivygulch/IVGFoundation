//
//  UIDevice+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 4/30/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import UIKit

public extension UIDevice {

    public static var isPhone: Bool { return current.isPhone }
    public static var isPad: Bool { return current.isPad }

    public var isPhone: Bool { return userInterfaceIdiom == .phone }
    public var isPad: Bool { return userInterfaceIdiom == .pad }

}
