//
//  NSString+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 10/11/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

public extension String {

    public func stringByAppendingPathComponent(_ value: String) -> String {
        return (self as NSString).appendingPathComponent(value)
    }

}
