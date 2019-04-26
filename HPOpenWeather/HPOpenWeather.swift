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
        - temperatureFormat: The temperature format used in API responses
        - language: The language used in API responses
    */
    public convenience init(apiKey: String, temperatureFormat: TemperatureUnit = .celsius, language: Language = .english) {
        self.init()
        self.apiKey = apiKey
        self.language = language
        self.temperatureFormat = temperatureFormat
    }
    
    /**
     Requests the icon with the specified ID from the server or loads it from cache if applicable
     
     - Parameters:
        - id: The ID of the the icon to load
        - completion: Completion block which contains optional UIImage
    */
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
     Requests the current weather using the specified WeatherRequest object. You can pass any object that conforms to WeatherRequest protocol
     
     - Parameters:
        - request: The WeatherRequest object used to make the request
        - weather: A Weather object which is returned, or nil if the request failed
        - error: An error object that indicates why the request failed, or nil if the request was successful.
     **/
    public func requestCurrentWeather<T: WeatherRequest>(with request: T, completion: @escaping (_ weather: Weather?, _ error: Error?) -> ()) {
        let jsonData = try? JSONSerialization.data(withJSONObject: request.parameters(), options: .prettyPrinted)
        
        // Configures the URLRequest and inserts the JSON header
        let url = URL(string: HPOpenWeather.baseURL)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error != nil else {
                completion(nil, error)
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let weather = Weather(data: responseJSON)
                
                completion(weather, error)
            } else {
                completion(nil, error)
            }
        }.resume()
    }
    
    /**
     Requests a forecast using the specified ForecastRequest object
     
     - Parameters:
        - request: The ForecastRequest object used to make the request
 
    **/
    public func requestForecast<T: WeatherRequest>(with request: T, forecastType: ForecastType) {
        
    }
}
