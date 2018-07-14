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
    
    public static func weatherData() -> [AnyObject] {
        
        return []
    }
    
    public static func json() -> String {
        let jsonData = WeatherFileManager.fileContent()
        do {
            let json = try JSON(data: jsonData)
            return json.description
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public static func update() {
        WeatherRequestor.downloadWeather()
    }
}
