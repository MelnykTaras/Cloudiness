//
//  DateFormatterCache.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

final class DateFormatterCache {
    private static let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    private static let dateFormat = "E dd"
    private static let timeFormat = "H"
    
    public static let serverDateFormatter: DateFormatter = {
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = serverDateFormat
        serverDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return serverDateFormatter
    }()
    
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()
    
    public static let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = timeFormat
        timeFormatter.timeZone = TimeZone.current
        return timeFormatter
    }()
    
    public static let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day , .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
}
