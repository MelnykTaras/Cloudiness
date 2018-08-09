//
//  NetworkActivityIndicator.swift
//  Cloudiness
//
//  Created by Admin on 8/8/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import AlamofireNetworkActivityIndicator

final class NetworkActivityIndicator {
    
    static func setup() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.completionDelay = 0.0
        NetworkActivityIndicatorManager.shared.startDelay = 0.0
    }
}
