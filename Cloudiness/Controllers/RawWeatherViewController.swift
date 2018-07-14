//
//  RawWeatherViewController.swift
//  Cloudiness
//
//  Created by Admin on 7/13/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

final class RawWeatherViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    convenience init() {
        self.init(nibName: "RawWeatherViewController", bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = WeatherDataSource.json()
    }
}
