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
        guard let result = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        return result
    }

    public func stringFromHTML(stripNewLines: Bool = true) -> String? {
        let result = attributedStringFromHTML?.string
        return stripNewLines ? result?.replacingOccurrences(of: "\n", with: "") : result
    }

    public func substring(withNSRange nsRange: NSRange) -> String? {
        guard let range = Range(nsRange) else { return nil }

        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(describing: self[start..<end])
    }

}

public extension String {

    public func isValid(withRegEx pattern: String) -> Bool {
        guard let regEx = try? NSRegularExpression(pattern: pattern, options: []) else { return false }

        let range = NSRange(location: 0, length: self.count)
        return !regEx.matches(in: self, options: [], range: range).isEmpty
    }

    public static let emailRegEx = "^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"

    public var isValidEmail: Bool { return isValid(withRegEx: String.emailRegEx) }

}

