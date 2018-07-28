//
//  Geocoder.swift
//  Cloudiness
//
//  Created by Admin on 7/15/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import CoreLocation

final class Geocoder {
    
    static func geocodeLocation(location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) {
            placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
}
