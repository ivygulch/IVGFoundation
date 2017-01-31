//
//  Synchronizer.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 3/20/16.
//  Copyright © 2016 Ivy Gulch LLC. All rights reserved.
//

import Foundation

public class Synchronizer {
    private let queue: DispatchQueue

    public init() {
        let uuid = UUID().uuidString
        self.queue = DispatchQueue(label: "Sync.\(uuid)",attributes: [])
    }

    public init(queueName: String) {
        self.queue = DispatchQueue(label: queueName,attributes: [])
    }

    public init(queue: DispatchQueue) {
        self.queue = queue
    }

    public func execute(_ closure: ()->Void) {
        queue.sync(execute: {
            closure()
        })
    }

    public func valueOf<T>(_ closure: ()->T) -> T {
        var result: T!
        queue.sync(execute: {
            result = closure()
        })
        return result
    }

}
