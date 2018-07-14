//
//  StringExtension.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

extension String {
    init(withSeconds seconds: TimeInterval) {
        self = DateFormatterCache.dateComponentsFormatter.string(from: seconds)!
    }
}
