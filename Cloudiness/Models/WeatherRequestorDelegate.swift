//
//  WeatherRequestorDelegate.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

protocol WeatherRequestorDelegate {
    func onDidReceiveData()
    func onDidReceiveError(_ error: Error)
}
