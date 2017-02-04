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

    public var attributedStringFromHTML: NSAttributedString? {
        guard let data = self.data(using: .utf16, allowLossyConversion: false) else { return nil }
        guard let result = try? NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil) else { return nil }
        return result
    }

    public var stringFromHTML: String? {
        return attributedStringFromHTML?.string
    }

}
