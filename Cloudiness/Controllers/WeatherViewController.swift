//
//  WeatherViewController.swift
//  Cloudiness
//
//  Created by Admin on 7/11/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

final class WeatherViewController: UICollectionViewController {

    private var clouds: [Cloud]!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        clouds = WeatherDataSource.fetchWeather(withDelegate: self)
        setup()
        updateTitle()
    }
    
    private func setup() {
        let rawWeatherButtonItem = UIBarButtonItem(title: "Raw", style: .plain, target: self, action: #selector(showRawWeatherData(_:)))
        navigationItem.rightBarButtonItem = rawWeatherButtonItem
        
        collectionView!.register(WeatherCell.nib(), forCellWithReuseIdentifier: WeatherCell.id)
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let height = collectionView!.bounds.size.height - navigationController!.navigationBar.bounds.size.height - UIApplication.shared.statusBarFrame.size.height
        layout.itemSize = CGSize(width: 40, height: height)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func updateData(_ sender: Notification) {
        updateTitle()
        WeatherDataSource.update(withDelegate: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clouds.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.id, for: indexPath)
        cell.backgroundColor = UIColor(white: CGFloat(1.0 - (clouds[indexPath.row].cloudiness) / 100.0), alpha: 1.0)
        return cell
    }
}

// MARK: - Actions
extension WeatherViewController {
    
    @objc func showRawWeatherData(_ sender: UIBarButtonItem) {
        let rawWeatherViewController = RawWeatherViewController()
        self.navigationController?.pushViewController(rawWeatherViewController, animated: true)
    }
}

// MARK: - WeatherRequestorDelegate
extension WeatherViewController: WeatherRequestorDelegate {
    
    func onDidReceiveData() {
        clouds = WeatherParser.clouds()
        collectionView!.reloadData()
        updateTitle()
    }
    
    func onDidReceiveError(_ error: Error) {
        let alert = UIAlertController(title: error.localizedDescription, message: "Code: \(error.code)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        updateTitle()
    }
    
    func onDidReceiveNotModifiedStatusCode() {
        updateTitle()
    }
}

// MARK: - Update Title
extension WeatherViewController {
    
    private func updateTitle() {
        guard let lastUpdated = WeatherRequestor.lastUpdated else {
            return
        }
        let timeSinceUpdate = -lastUpdated!.timeIntervalSinceNow
        title = "\(String(withSeconds: timeSinceUpdate)) ago"
    }
}
