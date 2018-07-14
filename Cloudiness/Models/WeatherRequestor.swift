//
//  WeatherRequestor.swift
//  Cloudiness
//
//  Created by Admin on 7/13/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation
import Alamofire

final class WeatherRequestor {
    
    private static let weatherURL = "https://api.met.no/weatherapi/locationforecastlts/1.3/"
    private static let parameters = ["lat": 49,
                                     "lon": 28]
    private static let HTTPHeaders = ["Accept": "application/json",
                                      "Accept-Encoding": "gzip"]
    
    public static func downloadWeather() {
        Alamofire.request(weatherURL,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.queryString,
                          headers: HTTPHeaders).responseString {
            response in
            switch response.result {
            case .success:
                processResponse(response)
            case .failure(let error):
                handleError(error)
            }
        }
    }
    
    private static func handleError(_ error: Error) {
        fatalError(error.localizedDescription)
    }
    
    private static func processResponse(_ response: DataResponse<String>) {
        WeatherFileManager.saveToFile(response.data!)
    }
}
