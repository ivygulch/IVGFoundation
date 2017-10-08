//
//  UIColor+IVGFoundation
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 5/20/16.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import UIKit

private func doubleHexDigit(_ byte:Int) -> Int {
    return byte*16 + byte
}

private func hexValue(_ hexString:String, _ start:Int, _ len:Int) -> Int? {
    let startIndex = hexString.index(hexString.startIndex, offsetBy: start)
    let endIndex = hexString.index(hexString.startIndex, offsetBy: start + len)

    let hexSubstring = hexString[startIndex ..< endIndex]
    return Int(hexSubstring, radix: 16)
}

public extension UIColor {

    // note per rule 2 from here:
    //   https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-ID219
    // we need to call an initializer even when we fail, since we are a convenience init
    // the rule doesn't seem explicit, but adding the 'self.init(...)' before returning nil
    // keeps swift 2.2 runtime from choking
    //
    // (found via this post)
    //   http://stackoverflow.com/questions/26854572/create-convenience-initializer-on-subclass-that-calls-failable-initializer
    public convenience init?(hexString:String) {
        var useString = hexString
        if useString.isEmpty {
            self.init(red:0, green:0, blue:0, alpha: 0)
            return nil
        }

        if String(useString[useString.startIndex]) == "#" {
            let index = useString.index(after: useString.startIndex)
            useString = String(useString[index...])
        }

        let len = useString.lengthOfBytes(using: String.Encoding.utf8)
        var red:CGFloat
        var blue:CGFloat
        var green:CGFloat
        var alpha:CGFloat
        switch (len) {
        case 3:
            guard let v0 = hexValue(useString,0,1), let v1 = hexValue(useString,1,1), let v2 = hexValue(useString,2,1) else {
                self.init(red:0, green:0, blue:0, alpha: 0)
                return nil
            }
            red = CGFloat(doubleHexDigit(v0)) / 255.0
            green = CGFloat(doubleHexDigit(v1)) / 255.0
            blue = CGFloat(doubleHexDigit(v2)) / 255.0
            alpha = 1.0
        case 4:
            guard let v0 = hexValue(useString,0,1), let v1 = hexValue(useString,1,1), let v2 = hexValue(useString,2,1), let v3 = hexValue(useString,3,1) else {
                self.init(red:0, green:0, blue:0, alpha: 0)
                return nil
            }
            red = CGFloat(doubleHexDigit(v0)) / 255.0
            green = CGFloat(doubleHexDigit(v1)) / 255.0
            blue = CGFloat(doubleHexDigit(v2)) / 255.0
            alpha = CGFloat(doubleHexDigit(v3)) / 255.0
        case 6:
            guard let v0 = hexValue(useString,0,2), let v1 = hexValue(useString,2,2), let v2 = hexValue(useString,4,2) else {
                self.init(red:0, green:0, blue:0, alpha: 0)
                return nil
            }
            red = CGFloat(v0) / 255.0
            green = CGFloat(v1) / 255.0
            blue = CGFloat(v2) / 255.0
            alpha = 1.0
        case 8:
            guard let v0 = hexValue(useString,0,2), let v1 = hexValue(useString,2,2), let v2 = hexValue(useString,4,2), let v3 = hexValue(useString,6,2) else {
                self.init(red:0, green:0, blue:0, alpha: 0)
                return nil
            }
            red = CGFloat(v0) / 255.0
            green = CGFloat(v1) / 255.0
            blue = CGFloat(v2) / 255.0
            alpha = CGFloat(v3) / 255.0
        default:
            self.init(red:0, green:0, blue:0, alpha: 0)
            return nil
        }

        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
}
