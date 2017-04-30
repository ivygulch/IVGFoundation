//
//  Dictionary+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 4/30/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import Foundation

public extension Dictionary {

    // snarfed from: https://ericasadun.com/2015/07/08/swift-merging-dictionaries/
    public mutating func merge<S: Sequence>(_ sequence: S?) where S.Iterator.Element == (key: Key, value: Value) {
        guard let s = sequence else { return }
        for (key, value) in s {
            self[key] = value
        }
    }

    public func hasKey(_ key: Key) -> Bool {
        return keys.contains(key)
    }

    public mutating func set(ifNotEmpty optionalValue: Value?, forKey key: Key) {
        if let stringValue = optionalValue as? String {
            if !stringValue.isEmpty {
                self[key] = optionalValue
            }
        } else if let _ = optionalValue {
            self[key] = optionalValue
        }
    }

}
