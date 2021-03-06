//
//  DataSource.swift
//  Cloudiness
//
//  Created by Admin on 7/13/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import SwiftyJSON

final class DataSource {
    
    static func fetchWeather(withDelegate delegate: RequestorDelegate) -> [Cloud] {
        update(withDelegate: delegate)
        return Parser.clouds()
    }
    
    static func json() -> String {
        guard let jsonString = WFileManager.fileContent() else {
            return ""
        }
        let json = JSON(parseJSON: jsonString)
        return json.description
    }
    
    static func update(withDelegate delegate: RequestorDelegate) {
        Requestor.downloadWeather(withDelegate: delegate)
    }
}
