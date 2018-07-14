//
//  WeatherCell.swift
//  Cloudiness
//
//  Created by Admin on 7/12/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

final class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cloudiness: UILabel!
    
    static let id = "WeatherCellId"
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
}
