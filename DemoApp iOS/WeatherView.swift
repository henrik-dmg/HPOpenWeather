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
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    
    private var locationManager: CLLocationManager?
    private var api: HPOpenWeather?
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
    
    func requestWeather(for location: CLLocation) {
        guard let api = self.api else {
            return
        }
        
        let request = LocationRequest(location.coordinate)
        api.requestCurrentWeather(with: request) { (weather, error) in
            guard let weather = weather, error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            print(weather.sun.rise)
            
            DispatchQueue.main.async {
                self.mainLabel.text = weather.condition.main
                self.cityLabel.text = weather.city.name
                self.tempLabel.text = "\(Int(weather.main.temperature))°"
            }
        }
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
