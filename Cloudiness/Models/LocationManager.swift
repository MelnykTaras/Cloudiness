//
//  LocationManager.swift
//  Cloudiness
//
//  Created by Admin on 7/15/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import CoreLocation
import UIKit

protocol LocationManagerDelegate: class {
    func onDidChangeLocation()
    func onDidAddLocationTitle()
    func cancelRetreivingLocation()
}

protocol AlertControllerDelegate: class {
    func saveLastLocation()
}

final class LocationManager: NSObject {
    
    static let locationTitleKey = "locationTitle"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    static let altitudeKey = "altitude"
    
    private weak var locationManagerDelegate: LocationManagerDelegate!
    private let locationManager: CLLocationManager!
    private var lastLocation: CLLocation?
    private var shouldStartLocationManager = false
    private var shouldSkipLocations = true
    
    init(withDelegate delegate: LocationManagerDelegate) {
        locationManagerDelegate = delegate
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    func start() {
        shouldStartLocationManager = true
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            startLocationManager()
        }
    }
    
    func stop() {
        shouldSkipLocations = true // because of async nature of stopUpdatingLocation() method, locations may arrive even after stopping locationManager, so skip them
        locationManager.stopUpdatingLocation()
    }
}

private extension LocationManager {
    
    func startLocationManager() {
        shouldStartLocationManager = false
        shouldSkipLocations = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // skip stale cached locations
            self.shouldSkipLocations = false
        }
        locationManager.startUpdatingLocation()
        AlertManager.showAlertRetrievingCurrentLocation(withLocationManagerDelegate: locationManagerDelegate, alertControllerDelegate: self)
    }
    
    func saveLocation(_ location: CLLocation?) {
        stop()
        guard let _location = location else {
            return
        }
        saveCoordinate(fromLocation: _location)
        saveCityName(fromLocation: _location)
    }
    
    func saveCoordinate(fromLocation location: CLLocation) {
        UserDefaults.standard.setValue(Float(location.coordinate.latitude), forKey: LocationManager.latitudeKey)
        UserDefaults.standard.setValue(Float(location.coordinate.longitude), forKey: LocationManager.longitudeKey)
        UserDefaults.standard.setValue(Int(round(location.altitude)), forKey: LocationManager.altitudeKey)
        locationManagerDelegate.onDidChangeLocation()
    }
    
    func saveCityName(fromLocation location: CLLocation) {
        Geocoder.geocodeLocation(location: location) { (placemark, _) in
            guard let locationTitle = placemark?.locality else {
                AlertManager.showAlertToEnterLocationTitle(withDelegate: self.locationManagerDelegate)
                return
            }
            UserDefaults.standard.setValue(locationTitle, forKey: LocationManager.locationTitleKey)
            defer {
                self.locationManagerDelegate.onDidAddLocationTitle()
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse && shouldStartLocationManager {
            startLocationManager()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
        if !shouldSkipLocations {
            AlertManager.updateLocationAlertMessage(withAccuracy: lastLocation!.horizontalAccuracy)
            if lastLocation!.horizontalAccuracy <= 100 {
                AlertManager.dismissLocationAlert()
                saveLocation(lastLocation)
            } else {
                AlertManager.enableLocationsAlertSaveButton()
            }
        }
    }
}

extension LocationManager: AlertControllerDelegate {
    
    func saveLastLocation() {
        saveLocation(lastLocation)
    }
}
