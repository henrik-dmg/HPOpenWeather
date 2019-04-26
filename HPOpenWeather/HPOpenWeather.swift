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
    
    /// Specifies the temperature format used in the API response
    public var temperatureFormat: TemperatureUnit = .celsius {
        didSet {
            params["units", default: "metric"] = temperatureFormat.rawValue
        }
    }
    /// Specifies the language used in the API response
    public var language: Language = .english {
        didSet {
            params["lang", default: "en"] = language.rawValue
        }
    }
    
    /**
     [here]: https://openweathermap.org/api "Obtain API key"
     
     The API key used to authenticate API requests. If you don't have one yet, obtain one at [here]
    */
    private var apiKey: String? {
        didSet {
            params["appid"] = apiKey
        }
    }
    
    /**
     Boolean indicating weather already loaded weather icons should be stored in cache or not
    */
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
    
    /**
     [here]: https://openweathermap.org/api "Obtain API key"
     
     Initialiser which required an API key and optional parameters to modify response format
     
     - Parameters:
        - apiKey: The API key used to authenticate API requests. If you don't have one yet, obtain one at [here]
    */
    public convenience init(apiKey: String, temperatureFormat: TemperatureUnit = .celsius, lang: Language = .english) {
        self.init()
        self.apiKey = apiKey
        self.language = lang
        self.temperatureFormat = temperatureFormat
    }
    
    public func getIconFrom(id: String, completion: @escaping (UIImage?) -> ()) {
        if self.enableIconCaching {
            if let cachedImage = self.iconCache[id] {
                print("Found cached icon")
                completion(cachedImage)
                return
            }
        }
        
        print("Icon was not in cache, requesting it now")
        let url = URL(string: "http://openweathermap.org/img/w/\(id).png")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error != nil else {
                print(error?.localizedDescription ?? "No Error Description")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                if self.enableIconCaching {
                    self.iconCache[id] = image
                }
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
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
