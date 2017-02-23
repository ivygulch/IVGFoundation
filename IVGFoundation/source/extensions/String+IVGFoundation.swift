//
//  String+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 2/10/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import Foundation

public extension String {

    public func substring(withNSRange nsRange: NSRange) -> String? {
        guard let range = nsRange.toRange() else { return nil }

        let start = utf16.index(utf16.startIndex, offsetBy: range.lowerBound)
        let end = utf16.index(utf16.startIndex, offsetBy: range.upperBound)
        return String(describing: utf16[start..<end])
    }
}
