//
//  Cloud.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

final class Cloud {
    let from: Date
    let cloudiness: Float
    
    init(from: String, cloudiness: String) {
        self.from = Date(string: from)
        self.cloudiness = Float(cloudiness)!
    }
}
