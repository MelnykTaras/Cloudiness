//
//  DateExtension.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

extension Date {
    
    init(string: String) {
        self = DateFormatterCache.serverDateFormatter.date(from: string)!
    }
    
    var time: String {
        get {
            return DateFormatterCache.timeFormatter.string(from: self)
        }
    }
    
    var date: String {
        get {
            return DateFormatterCache.dateFormatter.string(from: self)
        }
    }
}
