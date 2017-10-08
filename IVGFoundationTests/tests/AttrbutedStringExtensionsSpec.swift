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
                    ("a", [NSAttributedStringKey.font: fontA, NSAttributedStringKey.strokeColor: UIColor.blue, NSAttributedStringKey.backgroundColor: UIColor.yellow]),
                    ("b", nil),
                    ("c", [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: fontB])
                    ])

                it("should replace appropriate elements") {
                    let expected = NSAttributedString.concatenated(fromValues: [
                        ("a", [NSAttributedStringKey.font: fontC, NSAttributedStringKey.strokeColor: UIColor.blue]),
                        ("b", nil),
                        ("c", [NSAttributedStringKey.foregroundColor: UIColor.green, NSAttributedStringKey.font: fontC])
                        ])
                    let actual = source
                        .replacing(attribute: NSAttributedStringKey.backgroundColor, withValue: nil)
                        .replacing(attribute: NSAttributedStringKey.font, withValue: fontC)
                        .replacing(attribute: NSAttributedStringKey.foregroundColor, withValue: UIColor.green)
                    expect(actual).to(equal(expected))
                }

                it("should wrap appropriate elements") {
                    let mutableString = NSMutableAttributedString(attributedString: NSAttributedString.concatenated(fromValues: [
                        ("a", [NSAttributedStringKey.font: fontA, NSAttributedStringKey.strokeColor: UIColor.blue, NSAttributedStringKey.backgroundColor: UIColor.yellow]),
                        ("b", nil),
                        ("c", [NSAttributedStringKey.font: fontB])
                        ]))
                    let fullRange = NSRange(location: 0, length: mutableString.length)
                    mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: fullRange)
                    let expected = NSAttributedString(attributedString: mutableString)

                    let actual = source
                        .wrapping(withAttribute: NSAttributedStringKey.foregroundColor, value: UIColor.orange)
                    expect(actual).to(equal(expected))
                }
            }
            
        }
    }
}


