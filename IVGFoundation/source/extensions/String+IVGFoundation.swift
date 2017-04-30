//
//  String+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 2/10/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import Foundation

public extension String {

    public func stringByAppendingPathComponent(_ value: String) -> String {
        return (self as NSString).appendingPathComponent(value)
    }

    public var attributedStringFromHTML: NSAttributedString? {
        guard let data = self.data(using: .utf16, allowLossyConversion: false) else { return nil }
        guard let result = try? NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil) else { return nil }
        return result
    }

    public var stringFromHTML: String? {
        return attributedStringFromHTML?.string
    }

    public func substring(withNSRange nsRange: NSRange) -> String? {
        guard let range = nsRange.toRange() else { return nil }

        let start = utf16.index(utf16.startIndex, offsetBy: range.lowerBound)
        let end = utf16.index(utf16.startIndex, offsetBy: range.upperBound)
        return String(describing: utf16[start..<end])
    }
}
