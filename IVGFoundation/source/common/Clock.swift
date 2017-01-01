//
//  Clock.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 10/2/16.
//  Copyright © 2016 Ivy Gulch LLC. All rights reserved.
//

import Foundation

public class Clock {

    public static let sharedClock = Clock()

    fileprivate init() {}

    public var testDate: Date?

    public func testDateAfterIncrementing(_ timeInterval: TimeInterval) {
        if testDate == nil {
            testDate = Date()
        }
        testDate = testDate?.addingTimeInterval(timeInterval)
    }

    public var currentDate: Date {
        return testDate ?? Date()
    }

    public var isActualDate: Bool {
        return testDate == nil
    }

}
