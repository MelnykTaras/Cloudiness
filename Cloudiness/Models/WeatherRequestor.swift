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
    
    private static let lastModifiedKey = "Last-Modified"
    private static let weatherURL = "https://api.met.no/weatherapi/locationforecastlts/1.3/"
    private static let parameters = ["lat": 49,
                                     "lon": 28]
    private static var lastModified = UserDefaults.standard.string(forKey: lastModifiedKey) // "Last-Modified": Sat, 14 Jul 2018 07:08:33 GMT
    
    public static func downloadWeather(withDelegate delegate: WeatherRequestorDelegate) {
        var HTTPHeaders = ["Accept": "application/json",
                           "Accept-Encoding": "gzip"]
        if let lastModifiedString = lastModified {
            HTTPHeaders["If-Modified-Since"] = lastModifiedString
        }
        Alamofire.request(weatherURL,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.queryString,
                          headers: HTTPHeaders).responseString {
            response in
            switch response.response?.statusCode {
            case 304?:
                print("304 Not Modified")
            default:
                switch response.result {
                case .success:
                    processResponse(response, withDelegate: delegate)
                case .failure(let error):
                    handleError(error, withDelegate: delegate)
                }
            }
        }
    }
    
    private static func handleError(_ error: Error, withDelegate delegate: WeatherRequestorDelegate) {
        if error.code != ErrorCode.offline.rawValue {
            delegate.onDidReceiveError(error)
        }
    }
    
    private static func processResponse(_ response: DataResponse<String>, withDelegate delegate: WeatherRequestorDelegate) {
        WeatherFileManager.saveToFile(response.data!)
        lastModified = response.response!.allHeaderFields[lastModifiedKey] as? String
        UserDefaults.standard.setValue(lastModified, forKey: lastModifiedKey)
        delegate.onDidReceiveData()
    }
}
