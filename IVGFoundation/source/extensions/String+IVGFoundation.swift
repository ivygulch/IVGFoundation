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

// MARK: - a-z -
public extension String {
    public var a: String { return self + "a" }
    public var b: String { return self + "b" }
    public var c: String { return self + "c" }
    public var d: String { return self + "d" }
    public var e: String { return self + "e" }
    public var f: String { return self + "f" }
    public var g: String { return self + "g" }
    public var h: String { return self + "h" }
    public var i: String { return self + "i" }
    public var j: String { return self + "j" }
    public var k: String { return self + "k" }
    public var l: String { return self + "l" }
    public var m: String { return self + "m" }
    public var n: String { return self + "n" }
    public var o: String { return self + "o" }
    public var p: String { return self + "p" }
    public var q: String { return self + "q" }
    public var r: String { return self + "r" }
    public var s: String { return self + "s" }
    public var t: String { return self + "t" }
    public var u: String { return self + "u" }
    public var v: String { return self + "v" }
    public var w: String { return self + "w" }
    public var x: String { return self + "x" }
    public var y: String { return self + "y" }
    public var z: String { return self + "z" }
}

// MARK: - A-Z -
public extension String {
    public var A: String { return self + "A" }
    public var B: String { return self + "B" }
    public var C: String { return self + "C" }
    public var D: String { return self + "D" }
    public var E: String { return self + "E" }
    public var F: String { return self + "F" }
    public var G: String { return self + "G" }
    public var H: String { return self + "H" }
    public var I: String { return self + "I" }
    public var J: String { return self + "J" }
    public var K: String { return self + "K" }
    public var L: String { return self + "L" }
    public var M: String { return self + "M" }
    public var N: String { return self + "N" }
    public var O: String { return self + "O" }
    public var P: String { return self + "P" }
    public var Q: String { return self + "Q" }
    public var R: String { return self + "R" }
    public var S: String { return self + "S" }
    public var T: String { return self + "T" }
    public var U: String { return self + "U" }
    public var V: String { return self + "V" }
    public var W: String { return self + "W" }
    public var X: String { return self + "X" }
    public var Y: String { return self + "Y" }
    public var Z: String { return self + "Z" }
}

// MARK: - Numbers -
public extension String {
    public var _1: String { return self + "1" }
    public var _2: String { return self + "2" }
    public var _3: String { return self + "3" }
    public var _4: String { return self + "4" }
    public var _5: String { return self + "5" }
    public var _6: String { return self + "6" }
    public var _7: String { return self + "7" }
    public var _8: String { return self + "8" }
    public var _9: String { return self + "9" }
    public var _0: String { return self + "0" }
}

// MARK: - Punctuation -
public extension String {
    public var space: String { return self + " " }
    public var point: String { return self + "." }
    public var dash: String { return self + "-" }
    public var comma: String { return self + "," }
    public var semicolon: String { return self + ";" }
    public var colon: String { return self + ":" }
    public var apostrophe: String { return self + "'" }
    public var quotation: String { return self + "\"" }
    public var plus: String { return self + "+" }
    public var equals: String { return self + "=" }
    public var paren_left: String { return self + "(" }
    public var paren_right: String { return self + ")" }
    public var asterisk: String { return self + "*" }
    public var ampersand: String { return self + "&" }
    public var caret: String { return self + "^" }
    public var percent: String { return self + "%" }
    public var `$`: String { return self + "$" }
    public var pound: String { return self + "#" }
    public var at: String { return self + "@" }
    public var exclamation: String { return self + "!" }
    public var question_mark: String { return self + "?" }
    public var back_slash: String { return self + "\\" }
    public var forward_slash: String { return self + "/" }
    public var curly_left: String { return self + "{" }
    public var curly_right: String { return self + "}" }
    public var bracket_left: String { return self + "[" }
    public var bracket_right: String { return self + "]" }
    public var bar: String { return self + "|" }
    public var less_than: String { return self + "<" }
    public var greater_than: String { return self + ">" }
    public var underscore: String { return self + "_" }
}

// MARK: - Aliases -
public extension String {
    public var dot: String { return point }
}
