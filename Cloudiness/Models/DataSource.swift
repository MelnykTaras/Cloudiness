//
//  DataSource.swift
//  Cloudiness
//
//  Created by Admin on 7/13/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation
import SwiftyJSON

final class DataSource {
    
    public static func fetchWeather(withDelegate delegate: RequestorDelegate) -> [Cloud] {
        update(withDelegate: delegate)
        return Parser.clouds()
    }
    
    public static func json() -> String {
        guard let jsonString = WFileManager.fileContent() else {
            return ""
        }
        let json = JSON(parseJSON: jsonString)
        return json.description
    }
    
    public static func update(withDelegate delegate: RequestorDelegate) {
        Requestor.downloadWeather(withDelegate: delegate)
    }
}
