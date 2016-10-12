//
//  NSURL+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 10/11/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

public extension NSURL {

    private struct AssociatedKey {
        static var invalidFilenameCharacterSet = "invalidFilenameCharacterSet"
    }

    private var invalidFilenameCharacterSet: NSCharacterSet {
        get {
            if let result = objc_getAssociatedObject(self, &AssociatedKey.invalidFilenameCharacterSet) as? NSCharacterSet {
                return result
            }
            var result = NSMutableCharacterSet(charactersInString: ":/")
            result.formUnionWithCharacterSet(NSCharacterSet.newlineCharacterSet())
            result.formUnionWithCharacterSet(NSCharacterSet.illegalCharacterSet())
            result.formUnionWithCharacterSet(NSCharacterSet.controlCharacterSet())

            objc_setAssociatedObject(self, &AssociatedKey.invalidFilenameCharacterSet, result, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
    }

    var localFilename: String {
        return absoluteString.componentsSeparatedByCharactersInSet(invalidFilenameCharacterSet).joinWithSeparator("_")
    }
    
}