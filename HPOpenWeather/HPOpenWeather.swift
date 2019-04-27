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
    private var params = [String : URLQueryItem]()
    private var iconCache = [String : UIImage]()
    
    /// Specifies the temperature format used in the API response
    public var temperatureFormat: TemperatureUnit = .celsius {
        didSet {
            params["units"] = URLQueryItem(name: "units", value: self.temperatureFormat.rawValue)
        }
    }
    /// Specifies the language used in the API response
    public var language: Language = .english {
        didSet {
            params["lang"] = URLQueryItem(name: "lang", value: self.language.rawValue)
        }
    }
    
    /**
     [here]: https://openweathermap.org/api "Obtain API key"
     
     The API key used to authenticate API requests. If you don't have one yet, obtain one at [here]
    */
    private var apiKey: String? {
        didSet {
            params["appid"] = URLQueryItem(name: "appid", value: self.apiKey)
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
    public init(apiKey: String, temperatureFormat: TemperatureUnit = .celsius, language: Language = .english) {
        setter(apiKey, tempFormat: temperatureFormat, lang: language)
    }
    
    private func setter(_ apiKey: String, tempFormat: TemperatureUnit, lang: Language) {
        self.apiKey = apiKey
        self.temperatureFormat = tempFormat
        self.language = lang
    }
    
    /**
     Requests the icon with the specified ID from the server or loads it from cache if applicable
     
     - Parameters:
        - id: The ID of the the icon to load
        - completion: Completion block which contains optional UIImage
    */
    public func getIconFrom(id: String, completion: @escaping (UIImage?) -> ()) {
        if self.enableIconCaching {
            if self.iconCache[id] != nil {
                let cachedImage = self.iconCache[id]
                print("Found cached icon")
                completion(cachedImage)
                return
            }
        }
        
        print("Icon was not in cache, requesting it now")
        let url = URL(string: "https://openweathermap.org/img/w/\(id).png")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
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
        - weather: A CurrentWeather object which is returned, or nil if the request or parsing failed
        - error: An error object that indicates why the request failed, or nil if the request was successful.
     */
    public func requestCurrentWeather<T: WeatherRequest>(with request: T, completion: @escaping (_ weather: CurrentWeather?, _ error: Error?) -> ()) {
        var url = HPOpenWeather.baseURL.url()
        url.add(request.parameters())
        
        self.request(url: &url) { (json, error) in
            guard let json = json else {
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let model = try decoder.decode(CurrentWeather.self, from: json)
                
                completion(model, error)
            } catch let parsingError {
                print("Parsing Error")
                completion(nil, parsingError)
            }
        }
    }
    
    /**
     Requests a forecast using the specified ForecastRequest object
     
     - Parameters:
        - request: The ForecastRequest object used to make the request
        - forecastType: Type specifying which API endpoint is used to request the forecast
    */
    public func requestForecast<T: WeatherRequest>(with request: T, forecastType: ForecastType) {
        var url = forecastType.rawValue.url()
        url.add(request.parameters())
        
        self.request(url: &url) { (json, error) in
            // TODO: Return actual Forecast object here
            print(json, error)
        }
    }
    
    /**
     Private function to actually make the API calls
     
     - Parameters:
        - url: The completete the GET request is sent to
        - completion: Completion block that is called when the network call is completed
        - json: Dictionary containing the response in JSON format
        - error: An error object that indicates why the request failed, or nil if the request was successful.
    */
    private func request(url: inout URL, completion: @escaping (_ data: Data?, _ error: Error?) -> ()) {
        let values = Array(self.params.values)
        url.add(values)
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            completion(data, error)
        }.resume()
    }
}

// WARNING: Do NOT use this in production, or you'll burn in hell
extension String {
    func url() -> URL {
        return URL(string: self)!
    }
}

extension URL {
    mutating func add(_ queryItems: [URLQueryItem]) {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            self = absoluteURL
            return
        }
        
        // Create array of existing query items
        var existingItems = urlComponents.queryItems ?? []
        existingItems.append(contentsOf: queryItems)
        
        var dictionary = [String:URLQueryItem]()
        existingItems.forEach { (item) in
            dictionary[item.name] = item
        }
        
        existingItems = []
        dictionary.forEach { (key, value) in
            existingItems.append(value)
        }
        
        urlComponents.queryItems = existingItems
        self = urlComponents.url!
    }
}
