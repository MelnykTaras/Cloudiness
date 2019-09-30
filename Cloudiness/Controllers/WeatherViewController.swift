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

    @IBOutlet weak var collectionView: FlexibleCollectionView!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var cityBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var jsonBarButtonItem: UIBarButtonItem!
    
    private var clouds: [Cloud]!
    private var locationManager: LocationManager!
    private var currentHourCellIndex: Int?
    private weak var lastUpdatedCell: WeatherCell?
    private var curve: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkActivityIndicator.setup()
        clouds = DataSource.fetchWeather(withDelegate: self)
        setup()
        collectionView.updateCellSize()
        DispatchQueue.main.async {
            self.reloadCollectionView()
        }
        updateTitle()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Internal

private extension WeatherViewController {
    
    func setup() {
        
        if let locationTitle = UserDefaults.standard.string(forKey: LocationManager.locationTitleKey) {
            cityBarButtonItem.title = locationTitle
            addLocationButton.isHidden = true
        }
        
        collectionView.register(WeatherCell.nib(), forCellWithReuseIdentifier: WeatherCell.id)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    func reloadCollectionView() {
        guard clouds.count > 0 else {
            return
        }
        
        currentHourCellIndex = nil
        var isForecastOutdated = false
        let now = Date()
        for (index, cloud) in clouds.enumerated().reversed() {
            if now > cloud.from {
                let eightHours: TimeInterval = 8 * 60 * 60
                if now.timeIntervalSince(cloud.from) > eightHours {
                    isForecastOutdated = true
                } else {
                    currentHourCellIndex = index
                }
                break
            }
        }

        collectionView.updateCellSize()
        collectionView.reloadData()
        updateCurve()
        let row = isForecastOutdated ? clouds.count - 1 : currentHourCellIndex ?? 0
        collectionView.scrollToItem(at: IndexPath(item: row, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func updateCurve() {
        if let curve = curve {
            curve.removeFromSuperlayer()
        }
        curve = collectionView.curve(fromGrayscaleFrame: lastUpdatedCell?.grayscale?.frame, clouds)
        if let curve = curve {
            collectionView.layer.addSublayer(curve)
        }
    }
    
    @objc func updateData(_ sender: Notification) {
        updateTitle()
        reloadCollectionView()
        DataSource.update(withDelegate: self)
    }
    
    func updateTitle() {
        guard let lastUpdated = Requestor.lastUpdated else {
            return
        }
        let timeSinceUpdate = -lastUpdated.timeIntervalSinceNow
        title = "\(String(withSeconds: timeSinceUpdate)) ago"
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
        let backgroundWhite = CGFloat(1.0 - (cloud.cloudiness) / 100.0)
        cell.grayscale.backgroundColor = UIColor(white: backgroundWhite, alpha: 1.0)
        let time = cloud.from.time
        cell.time.text = time
        if time == "3" {
            cell.date.text = cloud.from.date
            cell.date.textColor = backgroundWhite < 0.5 ? UIColor.white : UIColor.black
        } else {
            cell.date.text = nil
        }
        cell.cloudiness.text = String(Int(round(cloud.cloudiness)))
        
        if indexPath.row == currentHourCellIndex {
            cell.layer.borderColor = UIColor.darkGreen.cgColor
            cell.layer.borderWidth = 1
        } else {
            cell.layer.borderWidth = 0
        }
        lastUpdatedCell = cell
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
        let jsonViewController = JSONViewController()
        navigationController?.pushViewController(jsonViewController, animated: true)
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
        reloadCollectionView()
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

// MARK: - ChangeLocationDelegate

extension WeatherViewController: ChangeLocationDelegate {
    
    func changeSavedLocation() {
        locationManager = LocationManager(withDelegate: self)
        locationManager.start()
    }
}
