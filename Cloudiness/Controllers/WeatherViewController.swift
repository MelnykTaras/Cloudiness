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
        clouds = DataSource.fetchWeather(withDelegate: self)
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
        DataSource.update(withDelegate: self)
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
        let cell: WeatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.id, for: indexPath) as! WeatherCell
        let cloud = clouds[indexPath.row]
        cell.backgroundColor = UIColor(white: CGFloat(1.0 - (cloud.cloudiness) / 100.0), alpha: 1.0)
        let time = cloud.from.time
        cell.time.text = time
        cell.date.text = time == "00" ? cloud.from.date : ""
        cell.cloudiness.text = String(Int(round(cloud.cloudiness)))
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

// MARK: - RequestorDelegate
extension WeatherViewController: RequestorDelegate {
    
    func onDidReceiveData() {
        clouds = Parser.clouds()
        collectionView!.reloadData()
        updateTitle()
    }
    
    func onDidReceiveError(_ error: Error) {
        showAlert(withError: error)
        updateTitle()
    }
    
    func onDidReceiveNotModifiedStatusCode() {
        updateTitle()
    }
}

// MARK: - RequestorDelegate - Helpers
extension WeatherViewController {
    private func showAlert(withError error: Error) {
        var message = "\(error.domain): \(error.code)"
        let userInfo = error.userInfo
        for (_, value) in userInfo {
            message += "\n\n\(value)"
        }
        let alert = UIAlertController(title: error.localizedDescription, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Title
extension WeatherViewController {
    
    private func updateTitle() {
        guard let lastUpdated = Requestor.lastUpdated else {
            return
        }
        let timeSinceUpdate = -lastUpdated!.timeIntervalSinceNow
        title = "\(String(withSeconds: timeSinceUpdate)) ago"
    }
}
