//
//  DateFormatterCache.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

final class DateFormatterCache {
    private static let dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
    
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }()
}
