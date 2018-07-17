//
//  AlertManager.swift
//  Cloudiness
//
//  Created by Admin on 7/15/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

final class AlertManager {
    
    private static weak var locationAlert: UIAlertController!
    private static let geolocationAdvice = """
                                              \n\n
                                              To speed up the process:
                                              - Stay away from buildings
                                              (come closer to a window indoor)
                                              - Enable internet connection
                                           """
    
    static func showAlert(withError error: Error) {
        var message = "\(error.domain): \(error.code)"
        let userInfo = error.userInfo
        for (_, value) in userInfo {
            message += "\n\n\(value)"
        }
        let alert = UIAlertController(title: error.localizedDescription, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertToEnterLocationTitle(withDelegate delegate: LocationManagerDelegate) {
        let alert = UIAlertController(title: "Enter Location Title", message: nil, preferredStyle: .alert)
        
        alert.addTextField {
            $0.placeholder = "Location title"
            $0.addTarget(alert, action: #selector(alert.textDidChangeInTextField), for: .editingChanged)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            UserDefaults.standard.setValue("Location", forKey: LocationManager.locationTitleKey)
            delegate.onDidAddLocationTitle()
        })
        
        let save = UIAlertAction(title: "Save", style: .cancel) { _ in
            guard let locationTitle = alert.textFields?[0].text else { return }
            UserDefaults.standard.setValue(locationTitle, forKey: LocationManager.locationTitleKey)
            delegate.onDidAddLocationTitle()
        }
        
        save.isEnabled = false
        alert.addAction(save)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertRetrievingCurrentLocation(withLocationManagerDelegate locationManagerDelegate: LocationManagerDelegate, alertControllerDelegate: AlertControllerDelegate) {
        assert(locationAlert == nil)
        let title = """
                       Retrieving Current Location
                       Please, Wait
                    """
        let suffix = """
                        Accuracy: N/A
                        Required: 100 m
                     """
        let message = suffix + geolocationAdvice
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { _ in
            alertControllerDelegate.saveLastLocation()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            locationManagerDelegate.cancelRetreivingLocation()
        }))
        alert.view.tintColor = UIColor.gray
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.startAnimating()
        alert.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: alert.view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: alert.view, attribute: .centerY, multiplier: 0.9, constant: 0)
        NSLayoutConstraint.activate([centerX, centerY])
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        locationAlert = alert
    }
    
    static func updateLocationAlertMessage(withAccuracy accuracy: Double) {
        let suffix = """
                        Accuracy: \(String(Int(accuracy))) m
                        Required: 100 m
                     """
        locationAlert.message = suffix + geolocationAdvice
    }
    
    static func dismissLocationAlert() {
        locationAlert.dismiss(animated: true, completion: nil)
    }
    
    static func showAlertChangeLocation(withDelegate delegate: ChangeLocationDelegate) {
        
        let locationTitle  = UserDefaults.standard.string(forKey: LocationManager.locationTitleKey)!
        let latitude  = UserDefaults.standard.float(forKey: LocationManager.latitudeKey)
        let longitude = UserDefaults.standard.float(forKey: LocationManager.longitudeKey)
        let altitude  = UserDefaults.standard.integer(forKey: LocationManager.altitudeKey)
        
        let title = "Change \(locationTitle) to the current location?"
        let message = """
                         Title: \(locationTitle)
                         Latitude: \(latitude)
                         Longitude: \(longitude)
                         Altitude: \(altitude)
                      """
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { _ in
            delegate.changeSavedLocation()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
