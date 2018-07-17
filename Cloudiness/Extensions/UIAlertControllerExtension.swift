//
//  UIAlertControllerExtension.swift
//  Cloudiness
//
//  Created by Admin on 7/16/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func shouldEnableSaveButton(_ locationTitle: String) -> Bool {
        return !locationTitle.isEmpty
    }
    
    @objc func textDidChangeInTextField() {
        if let locationTitle = textFields?[0].text,
           let action = actions.last {
            action.isEnabled = shouldEnableSaveButton(locationTitle)
        }
    }
}
