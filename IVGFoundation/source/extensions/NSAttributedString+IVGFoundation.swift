//
//  NSAttributedString+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 2/4/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import Foundation

public extension NSAttributedString {

    public static func concatenated(fromValues values: [(String, [String: Any]?)]) -> NSAttributedString {
        let result = NSMutableAttributedString()
        for (string, attributes) in values {
            if let attributes = attributes {
                result.append(NSAttributedString(string: string, attributes: attributes))
            } else {
                result.append(NSAttributedString(string: string))
            }
        }
        return NSAttributedString(attributedString: result)
    }

    public func withReplacements(_ replacements: [String: Any?]) -> NSAttributedString {
        let range = NSRange(location: 0, length: length)
        let result = NSMutableAttributedString()
        let replacementKeys = Set(replacements.keys)
        enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
            var updatedAttributes: [String: Any] = [:]
            for attributeName in attributes.keys {
                if replacementKeys.contains(attributeName) {
                    if let replacementValue = replacements[attributeName] {
                        updatedAttributes[attributeName] = replacementValue
                    }
                } else {
                    updatedAttributes[attributeName] = attributes[attributeName]
                }
            }
            result.append(NSAttributedString(string: attributedSubstring(from: range).string, attributes: updatedAttributes))
        })

        return NSAttributedString(attributedString: result)
    }
    
    public func replacing(attribute attributeName: String, withValue value: Any?) -> NSAttributedString {
        return withReplacements([attributeName: value])
    }

    public func wrapping(withAttributes wrappingAttributes: [String: Any?]) -> NSAttributedString {
        let range = NSRange(location: 0, length: length)
        var replacements: [String: Any?] = [:]
        var newAttributes: [String: Any] = [:]
        for key in wrappingAttributes.keys {
            replacements[key] = nil
            if let newValue = wrappingAttributes[key] {
                newAttributes[key] = newValue
            }
        }
        let result = NSMutableAttributedString(attributedString: withReplacements(replacements))
        result.addAttributes(newAttributes, range: range)
        return NSAttributedString(attributedString: result)
    }
    
    public func wrapping(withAttribute attributeName: String, value: Any?) -> NSAttributedString {
        return wrapping(withAttributes: [attributeName: value])
    }

}
