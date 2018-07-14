//
//  ErrorCode.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
