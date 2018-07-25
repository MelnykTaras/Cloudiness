//
//  UIButtonExtension.swift
//  Cloudiness
//
//  Created by Admin on 7/15/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

@IBDesignable extension UIButton {
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            if layer.cornerRadius > 0 {
                let maxSide = max(bounds.size.height, bounds.size.width)
                return max(layer.cornerRadius, maxSide)
            } else {
                return 0
            }
        }
    }
}
