//
//  WeatherDataSource.swift
//  Cloudiness
//
//  Created by Admin on 7/13/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation
import SwiftyJSON

final class WeatherDataSource {
    
    public static func fetchWeather() -> [Cloud] {
//        update()
        return WeatherParser.clouds()
    }
    
    public static func json() -> String {
        guard let jsonString = WeatherFileManager.fileContent() else {
            return ""
        }
        let json = JSON(parseJSON: jsonString)
        return json.description
    }
    
    public static func update() {
        WeatherRequestor.downloadWeather()
    }
}
