//
//  WeatherCell.swift
//  Cloudiness
//
//  Created by Admin on 7/12/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

final class WeatherCell: UICollectionViewCell {
    
    static let id = "WeatherCellId"
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
}
