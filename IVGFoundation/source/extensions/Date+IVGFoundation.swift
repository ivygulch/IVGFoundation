//
//  Date+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 4/17/16.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import Foundation

private var dateFormatters: [String: DateFormatter] = [:]

public extension Date {

    private static func dateFormatter(for format: String) -> DateFormatter {
        if let result = dateFormatters[format] {
            return result
        }
        let result = DateFormatter()
        result.dateFormat = format
        dateFormatters[format] = result
        return result
    }

    public static func dateFromYear(_ year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, nanosecond: Int = 0) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        dateComponents.nanosecond = nanosecond
        return Calendar.current.date(from: dateComponents)
    }

    public static func dateFromString(_ string: String, format: String) -> Date? {
        return Date.dateFormatter(for: format).date(from: string)
    }

    public func stringWithFormat(_ format: String) -> String {
        return Date.dateFormatter(for: format).string(from: self)
    }

}
