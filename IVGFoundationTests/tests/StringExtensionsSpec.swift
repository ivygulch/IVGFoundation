//
//  StringExtensionsSpec.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 2/4/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import Quick
import Nimble
import IVGFoundation

class StringExtensionsSpec: QuickSpec {

    override func spec() {

        describe("attributedStringFromHTML") {

            context("with empty string") {

                let source = ""
                let expected = NSAttributedString(string: "")

                it("should produce empty attributed string") {
                    expect(source.attributedStringFromHTML).to(equal(expected))
                }
            }

            context("with simple html string") {

                let source = "<p><span class=\"s1\">Improve the strength and endurance of the abdominal muscles. &nbsp;</span></p>"

                it("should produce empty attributed string") {
                    expect(source.attributedStringFromHTML).toNot(beNil())
                }
                
            }
        }
    }
}


