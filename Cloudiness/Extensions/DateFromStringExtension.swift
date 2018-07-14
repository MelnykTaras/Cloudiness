//
//  DateFromStringExtension.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

extension Date {
    init(string: String) {
        self = DateFormatterCache.dateFormatter.date(from: string)!
    }
}
