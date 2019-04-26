//
//  OpenWeatherApi.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 15/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import CoreLocation
import UIKit
import Foundation

public class HPOpenWeather {
    
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    private var params = [String : String]()
    private var iconCache = [String : UIImage]()
    
    public var temperatureFormat: TemperatureUnit = .celsius {
        didSet {
            params["units", default: "metric"] = temperatureFormat.rawValue
        }
    }
    public var language: Language = .english {
        didSet {
            params["lang", default: "en"] = language.rawValue
        }
    }
    private var apiKey: String? {
        didSet {
            params["appid"] = apiKey
        }
    }
    public var enableIconCaching: Bool = true {
        didSet {
            if self.enableIconCaching == false {
                iconCache.forEach { (key, value) in
                    iconCache[key] = nil
                }
                iconCache = [String : UIImage]()
            }
        }
    }
    
    public convenience init(apiKey: String, temperatureFormat: TemperatureUnit = .celsius, lang: Language = .english) {
        self.init()
        self.apiKey = apiKey
        self.language = lang
        self.temperatureFormat = temperatureFormat
    }
    
    public func getIconFromID(id: String) -> UIImage {
        // TODO: Use URLSession here to make it asynchronous
        
        let url = URL(string: "http://openweathermap.org/img/w/\(id).png")
        do {
            
            let data = try Data.init(contentsOf: url!)
            let image = UIImage(data: data)
            
            return image!
        } catch {
            print("error")
        }
        
        return UIImage()
    }
    
    /**
     Requests the current weather using the specified WeatherRequest object
     
     - Parameters:
        - request: The WeatherRequest object used to make the request
     
     **/
    public func requestCurrentWeather<T: WeatherRequest>(with request: T) {
        
    }
    
    /**
     Requests a forecast using the specified ForecastRequest object
     
     - Parameters:
        - request: The ForecastRequest object used to make the request
 
    **/
    public func requestForecast<T: WeatherRequest>(with request: T, forecastType: ForecastType) {
        
    }
}
