//
//  ViewController.swift
//  DemoApp macOS
//
//  Created by Henrik Panhans on 27.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Cocoa
import HPOpenWeather
import CoreLocation

class ViewController: NSViewController {

    @IBOutlet weak var temperatureLabel: NSTextField!
    @IBOutlet weak var conditionLabel: NSTextField!
    @IBOutlet weak var locationLabel: NSTextField!
    @IBOutlet weak var locationAccessButton: NSButton!
    
    
    var apiKey = "--- YOUR API KEY GOES HERE ---" {
        didSet {
            self.api = HPOpenWeather(apiKey: self.apiKey)
        }
    }
    var api: HPOpenWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func requestLocationAccess(_ sender: Any) {
        print("Couldnt figure out how to request location lol")
        self.requestWeather()
    }
    
    func requestWeather(for city: String = "Berlin") {
        guard let api = self.api else {
            return
        }
        
        let request = CityNameRequest(city, countryCode: "DE")
        
        api.requestCurrentWeather(with: request) { (weather, error) in
            guard let weather = weather, error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.conditionLabel.stringValue = weather.conditions.first?.main ?? "Unknown Condition"
                self.locationLabel.stringValue = weather.name
                self.temperatureLabel.stringValue = "\(Int(weather.main.temperature))°"
            }
        }
    }
}

