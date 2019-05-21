//
//  OpenWeatherApi.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 15/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import CoreLocation
import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(macOS)
    import AppKit
    public typealias UIImage = NSImage
#endif

/// Object that handles any API requests and responses.
public class HPOpenWeather {
    
    /// Private DispatchQueue for thread-safe iconCache access
    private let cacheQueue = DispatchQueue(label: "com.henrikpanhans.HPOpenWeather", attributes: .concurrent)
    
    /// The URL endpoint that returns current weather data
    static let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?")!
    
    /// The URL endpoint that returns daily forecasts
    static let dailyForecastUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?")!
    
    /// Internal property to store API key, language and temperature format as URL parameter
    private var params = [String : URLQueryItem]()
    
    /// Internal property to store weather icons that were already downloaded once
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
    public func getIconWith(id: String, completion: @escaping (UIImage?) -> ()) {
        if self.enableIconCaching {
            self.cacheQueue.sync {
                if self.iconCache[id] != nil {
                    let cachedImage = self.iconCache[id]
                    completion(cachedImage)
                    return
                }
            }
        }
        
        let url = URL(string: "https://openweathermap.org/img/w/\(id).png")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No Error Description")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                self.cacheQueue.sync(flags: .barrier) {
                    if self.enableIconCaching {
                        self.iconCache[id] = image
                    }
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
    public func requestCurrentWeather(with request: WeatherRequest, completion: @escaping (_ weather: CurrentWeather?, _ error: Error?) -> ()) {
        var url = HPOpenWeather.baseUrl
        url.add(request.queryItems())
        
        self.request(url: &url, for: CurrentWeather.self, completion: completion)
    }
    
    /**
     Requests an hourly forecast using the specified WeatherRequest
     
     - Parameters:
        - request: The ForecastRequest object used to make the request
        - frequency: Type specifying which API endpoint is used to request the forecast
        - forecast: A HourlyForecast object which is returned, or nil if the request or parsing failed
        - error: An error object that indicates why the request failed, or nil if the request was successful.
    */
    public func requestHourlyForecast(with request: WeatherRequest, for frequency: ForecastFrequency, completion: @escaping (_ forecast: HourlyForecast?, _ error: Error?) -> ()) {
        var url = frequency.url()
        url.add(request.queryItems())
        
        self.request(url: &url, for: HourlyForecast.self, completion: completion)
    }
    
    /**
     Requests an hourly forecast using the specified WeatherRequest
     
     - Parameters:
        - request: The ForecastRequest object used to make the request
        - forecast: A DailyForecast object which is returned, or nil if the request or parsing failed
        - error: An error object that indicates why the request failed, or nil if the request was successful.
    */
    public func requestDailyForecast(with request: WeatherRequest, completion: @escaping (_ forecast: DailyForecast?, _ error: Error?) -> ()) {
        var url = HPOpenWeather.dailyForecastUrl
        url.add(request.queryItems())
        
        self.request(url: &url, for: DailyForecast.self, completion: completion)
    }
    
    /**
     Private function to actually make the API calls
     
     - Parameters:
        - url: The completete the GET request is sent to
        - completion: Completion block that is called when the network call is completed
        - json: Dictionary containing the response in JSON format
        - error: An error object that indicates why the request failed, or nil if the request was successful.
    */
    private func request<T: Codable>(url: inout URL, for type: T.Type, completion: @escaping (_ data: T?, _ error: Error?) -> ()) {
        let values = Array(self.params.values)
        url.add(values)
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let json = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                if let apiError = try? decoder.decode(ApiError.self, from: json) {
                    completion(nil, apiError)
                    return
                }
                
                let model = try decoder.decode(type, from: json)
                
                completion(model, error)
            } catch let parsingError {
                completion(nil, parsingError)
            }
        }.resume()
    }
}

// Felt cute, might delete later
extension Data {
    func json() -> [String:Any]? {
        let model = try? JSONSerialization.jsonObject(with: self, options: [])
        
        if let json = model as? [String:Any] {
            return json
        }
        
        return nil
    }
}

extension URL {
    /// URL extension to add URLQueryItems without adding a parameter twice
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
