//
//  HTTPStatusErrorCode.swift
//  Cloudiness
//
//  Created by Admin on 7/15/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

enum HTTPStatusErrorCode: Int {
    case nonAuthorativeInformation = 203
    case notModified               = 304
    case badRequest                = 400
    case unauthorized              = 401
    case notFound                  = 404
    case unprocessableEntity       = 422
    case tooManyRequests           = 429
    case clientClosedRequest       = 499
    case internalServerError       = 500
    case badGateway                = 502
    case serviceUnavailable        = 503
    
    private static func descriptions() -> [String: String] {
        return WeatherFileManager.plistDictionary(byFilename: "HTTPStatusCodeDescription")!
    }
    
    func description() -> String {
        let descriptions = HTTPStatusErrorCode.descriptions()
        if let description = descriptions[String(self.rawValue)] {
            return description
        } else {
            return String(self.rawValue)
        }
    }
    
    private static func xErrorDescriptions() -> [String: String] {
        return WeatherFileManager.plistDictionary(byFilename: "XErrorClassResponseHeaderDescription")!
    }
    
    static func xErrorDescription(xErrorHeader: String) -> String {
        let xErrorDescriptions = self.xErrorDescriptions()
        if let xErrorDescription = xErrorDescriptions[xErrorHeader] {
            return xErrorDescription
        } else {
            return xErrorHeader
        }
    }
}
