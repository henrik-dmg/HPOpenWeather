//
//  WeatherView.swift
//  DemoApp
//
//  Created by Henrik Panhans on 27.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation
import UIKit
import HPOpenWeather
import CoreLocation

class WeatherView: NibLoadingView {
    
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var mainLabel: UILabel!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var tempLabel: UILabel!

    private var api: HPOpenWeather?
    private var locationManager: CLLocationManager?
    public var lastLocation: CLLocation? {
        return locationManager?.location
    }
    @IBInspectable public var apiKey: String? {
        didSet {
            if self.apiKey != nil {
                api = HPOpenWeather(apiKey: self.apiKey!)
            }
        }
    }
    
    public func requestLocationAccess() {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
        }
        
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func requestWeather(for location: CLLocation?) {
        guard let api = self.api, let location = location else {
            return
        }
        
        let request = LocationRequest(location.coordinate)
        api.requestCurrentWeather(with: request) { (weather, error) in
            
            DispatchQueue.main.async {
                guard let weather = weather, error == nil else {
                    self.findViewController()?.notifyUserOfError(error! as NSError)
                    return
                }
                
                self.mainLabel.text = weather.condition.main
                self.cityLabel.text = weather.city.name
                self.tempLabel.text = "\(Int(weather.main.temperature))°"
                if #available(iOS 13.0, *) {
                    self.iconView.image = weather.condition.systemIcon?.regularIcon
                }
            }
        }
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension UIViewController {
    func notifyUserOfError(_ error: NSError) {
        let alertVC = UIAlertController(title: "\(error.code)", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}

extension WeatherView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        guard let location = locations.first else {
            return
        }
        
        self.requestWeather(for: location)
    }
}
