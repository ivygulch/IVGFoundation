//
//  Types.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 10/2/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}
