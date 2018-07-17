//
//  WeatherViewController.swift
//  Cloudiness
//
//  Created by Admin on 7/11/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

protocol ChangeLocationDelegate: class {
    func changeSavedLocation()
}

final class WeatherViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var cityBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var jsonBarButtonItem: UIBarButtonItem!
    
    private var clouds: [Cloud]!
    private var locationManager: LocationManager!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        clouds = DataSource.fetchWeather(withDelegate: self)
        setup()
        updateTitle()
    }
    
    private func setup() {
        
        if let locationTitle = UserDefaults.standard.string(forKey: LocationManager.locationTitleKey) {
            cityBarButtonItem.title = locationTitle
            addLocationButton.isHidden = true
        }
        
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
extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clouds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WeatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.id, for: indexPath) as! WeatherCell
        let cloud = clouds[indexPath.row]
        cell.backgroundColor = UIColor(white: CGFloat(1.0 - (cloud.cloudiness) / 100.0), alpha: 1.0)
        let time = cloud.from.time
        cell.time.text = time
        cell.date.text = time == "3" ? cloud.from.date : ""
        cell.cloudiness.text = String(Int(round(cloud.cloudiness)))
        return cell
    }
}

// MARK: - Actions
extension WeatherViewController {
    
    @IBAction func changeLocation(_ sender: UIBarButtonItem) {
        if let _ = UserDefaults.standard.string(forKey: LocationManager.locationTitleKey) {
            AlertManager.showAlertChangeLocation(withDelegate: self)
        } else {
            changeSavedLocation()
        }
    }
    
    @IBAction func showRawWeatherData(_ sender: UIBarButtonItem) {
        let rawWeatherViewController = RawWeatherViewController()
        self.navigationController?.pushViewController(rawWeatherViewController, animated: true)
    }
    
    @IBAction func addLocation(_ sender: UIButton) {
        sender.isEnabled = false
        locationManager = LocationManager(withDelegate: self)
        locationManager.start()
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
        AlertManager.showAlert(withError: error)
        updateTitle()
    }
    
    func onDidReceiveNotModifiedStatusCode() {
        updateTitle()
    }
}

// MARK: - Title
private extension WeatherViewController {
    
    func updateTitle() {
        guard let lastUpdated = Requestor.lastUpdated else {
            return
        }
        
        let timeSinceUpdate = -lastUpdated.timeIntervalSinceNow
        title = "\(String(withSeconds: timeSinceUpdate)) ago"
    }
}

// MARK: - LocationManagerDelegate
extension WeatherViewController: LocationManagerDelegate {
    
    func onDidChangeLocation() {
        DataSource.update(withDelegate: self)
        addLocationButton.isHidden = true
    }
    
    func onDidAddLocationTitle() {
        cityBarButtonItem.title = UserDefaults.standard.string(forKey: LocationManager.locationTitleKey)
    }
    
    func cancelRetreivingLocation() {
        addLocationButton.isEnabled = true
        locationManager.stop()
    }
}

extension WeatherViewController: ChangeLocationDelegate {
    
    func changeSavedLocation() {
        locationManager = LocationManager(withDelegate: self)
        locationManager.start()
    }
}
