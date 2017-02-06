//
//  AttrbutedStringExtensionsSpec.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 2/4/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import Quick
import Nimble
import UIKit
import IVGFoundation

class AttrbutedStringExtensionsSpec: QuickSpec {

    override func spec() {

        describe("extensions") {

            context("attributedString") {

                let fontA = UIFont(name: "ArialMT", size: 12.0)!
                let fontB = UIFont(name: "Cochin", size: 10.0)!
                let fontC = UIFont(name: "Courier", size: 15.0)!
                let source = NSAttributedString.concatenated(fromValues: [
                    ("a", [NSFontAttributeName: fontA, NSStrokeColorAttributeName: UIColor.blue, NSBackgroundColorAttributeName: UIColor.yellow]),
                    ("b", nil),
                    ("c", [NSForegroundColorAttributeName: UIColor.red, NSFontAttributeName: fontB])
                    ])

                it("should replace appropriate elements") {
                    let expected = NSAttributedString.concatenated(fromValues: [
                        ("a", [NSFontAttributeName: fontC, NSStrokeColorAttributeName: UIColor.blue]),
                        ("b", nil),
                        ("c", [NSForegroundColorAttributeName: UIColor.green, NSFontAttributeName: fontC])
                        ])
                    let actual = source
                        .replacing(attribute: NSBackgroundColorAttributeName, withValue: nil)
                        .replacing(attribute: NSFontAttributeName, withValue: fontC)
                        .replacing(attribute: NSForegroundColorAttributeName, withValue: UIColor.green)
                    expect(actual).to(equal(expected))
                }

                it("should wrap appropriate elements") {
                    let mutableString = NSMutableAttributedString(attributedString: NSAttributedString.concatenated(fromValues: [
                        ("a", [NSFontAttributeName: fontA, NSStrokeColorAttributeName: UIColor.blue, NSBackgroundColorAttributeName: UIColor.yellow]),
                        ("b", nil),
                        ("c", [NSFontAttributeName: fontB])
                        ]))
                    let fullRange = NSRange(location: 0, length: mutableString.length)
                    mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: fullRange)
                    let expected = NSAttributedString(attributedString: mutableString)

                    let actual = source
                        .wrapping(withAttribute: NSForegroundColorAttributeName, value: UIColor.orange)
                    expect(actual).to(equal(expected))
                }
            }
            
        }
    }
}


