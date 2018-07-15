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
//    private static let weatherURL = "https://httpstat.us/400" // to test http status codes
    private static let parameters = ["lat": 49,
                                     "lon": 28,
                                     "msl": 240]

    private static var lastModified = UserDefaults.standard.string(forKey: lastModifiedKey) // "Last-Modified": Sat, 14 Jul 2018 07:08:33 GMT
    
    private static let lastUpdatedKey = "lastUpdated"
    public static var lastUpdated = UserDefaults.standard.object(forKey: lastUpdatedKey) as? Date?
    
    public static func downloadWeather(withDelegate delegate: WeatherRequestorDelegate) {
        var HTTPHeaders = ["Accept": "application/json",
                           "Accept-Encoding": "gzip"]
        if let lastModifiedString = lastModified {
            HTTPHeaders["If-Modified-Since"] = lastModifiedString
        }
        func refreshLastUpdateDate() {
            lastUpdated = Date()
            UserDefaults.standard.setValue(lastUpdated!, forKey: lastUpdatedKey)
        }
        Alamofire.request(weatherURL, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: HTTPHeaders).responseString {
            response in
            if let statusCode = response.response?.statusCode, let httpStatusCode = HTTPStatusErrorCode(rawValue: statusCode) {
                switch httpStatusCode {
                case .notModified:
                    refreshLastUpdateDate()
                    delegate.onDidReceiveNotModifiedStatusCode()
                default:
                    let xErrorClassResponseHeader = response.response!.allHeaderFields["X-ErrorClass"] as? String
                    handleStatusCode(httpStatusCode, xErrorHeader: xErrorClassResponseHeader, withDelegate: delegate)
                }
                return
            }
            
            switch response.result {
            case .success:
                refreshLastUpdateDate()
                processResponse(response, withDelegate: delegate)
            case .failure(let error):
                if error.code != ErrorCode.offline.rawValue {
                    handleError(error, withDelegate: delegate)
                }
            }
        }
    }
    
    private static func handleStatusCode(_ statusCode: HTTPStatusErrorCode, xErrorHeader: String?, withDelegate delegate: WeatherRequestorDelegate) {
        var userInfo = ["Description": statusCode.description()]
        if let xHeader = xErrorHeader {
            userInfo["xErrorDescription"] = HTTPStatusErrorCode.xErrorDescription(xErrorHeader: xHeader)
        }
        let error: NSError = NSError(domain: "met.no.statusCode", code: statusCode.rawValue, userInfo: userInfo)
        handleError(error, withDelegate: delegate)
    }
    
    private static func handleError(_ error: Error, withDelegate delegate: WeatherRequestorDelegate) {
        delegate.onDidReceiveError(error)
    }
    
    private static func processResponse(_ response: DataResponse<String>, withDelegate delegate: WeatherRequestorDelegate) {
        WeatherFileManager.saveToFile(response.data!)
        lastModified = response.response!.allHeaderFields[lastModifiedKey] as? String
        UserDefaults.standard.setValue(lastModified, forKey: lastModifiedKey)
        delegate.onDidReceiveData()
    }
}
