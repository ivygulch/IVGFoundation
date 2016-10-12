//
//  NSFileManager+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 10/11/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

public extension NSFileManager {

    public var documentsDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }

    public var cachesDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
    }

    private func subdirectoryOf(path: String, withName name: String, create shouldCreate: Bool = false) throws -> String {
        let result = path.stringByAppendingPathComponent(name)
        if !fileExistsAtPath(result, isDirectory: nil) && shouldCreate {
            try createDirectoryAtPath(result, withIntermediateDirectories: true, attributes: [:])
        }
        return result
    }

    public func documentsSubdirectory(name: String, create shouldCreate: Bool = false) throws -> String {
        return try subdirectoryOf(documentsDirectory, withName: name, create: shouldCreate)
    }

    public func cachesSubdirectory(name: String, create shouldCreate: Bool = false) throws -> String {
        return try subdirectoryOf(cachesDirectory, withName: name, create: shouldCreate)
    }

}