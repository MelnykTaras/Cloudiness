//
//  WeatherViewController.swift
//  Cloudiness
//
//  Created by Admin on 7/11/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

final class WeatherViewController: UICollectionViewController {

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let rawWeatherButtonItem = UIBarButtonItem(title: "Raw", style: .plain, target: self, action: #selector(showRawWeatherData(_:)))
        navigationItem.rightBarButtonItem = rawWeatherButtonItem
        
        collectionView!.register(WeatherCell.nib(), forCellWithReuseIdentifier: WeatherCell.id)
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let height = collectionView!.bounds.size.height - navigationController!.navigationBar.bounds.size.height - UIApplication.shared.statusBarFrame.size.height
        layout.itemSize = CGSize(width: 40, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 * 24
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.id, for: indexPath)
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
}

// MARK: - Actions
extension WeatherViewController {
    @objc func showRawWeatherData(_ sender: UIBarButtonItem) {
        let rawWeatherViewController = RawWeatherViewController.init()
        self.navigationController?.pushViewController(rawWeatherViewController, animated: true)
    }
}
