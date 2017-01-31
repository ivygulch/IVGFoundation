//
//  NSFileManager+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 10/11/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

public extension FileManager {

    public var documentsDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }

    public var cachesDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }

    private func subdirectoryOf(_ path: String, withName name: String, create shouldCreate: Bool = false) throws -> String {
        let result = path.stringByAppendingPathComponent(name)
        if !fileExists(atPath: result, isDirectory: nil) && shouldCreate {
            try createDirectory(atPath: result, withIntermediateDirectories: true, attributes: [: ])
        }
        return result
    }

    public func documentsSubdirectory(_ name: String, create shouldCreate: Bool = false) throws -> String {
        return try subdirectoryOf(documentsDirectory, withName: name, create: shouldCreate)
    }

    public func cachesSubdirectory(_ name: String, create shouldCreate: Bool = false) throws -> String {
        return try subdirectoryOf(cachesDirectory, withName: name, create: shouldCreate)
    }

}
