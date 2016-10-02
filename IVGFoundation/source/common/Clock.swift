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

    private init() {}

    public var testDate: NSDate?

    public func testDateAfterIncrementing(timeInterval: NSTimeInterval) {
        if testDate == nil {
            testDate = NSDate()
        }
        testDate = testDate?.dateByAddingTimeInterval(timeInterval)
    }

    public var currentDate: NSDate {
        return testDate ?? NSDate()
    }

    public var isActualDate: Bool {
        return testDate == nil
    }

}