//
//  OpenWeatherApi.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 15/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import CoreLocation
import UIKit

public class HPOpenWeather {
    
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    
    private var params = [String : String]()
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

    public init(apiKey: String) {
        params["appid"] = apiKey
    }
    
    public convenience init(apiKey: String, temperatureFormat: TemperatureUnit) {
        self.init(apiKey: apiKey)
        self.temperatureFormat = temperatureFormat
    }
    
    public convenience init(apiKey: String, temperatureFormat: TemperatureUnit, lang: Language) {
        self.init(apiKey: apiKey)
        
        self.language = lang
        self.temperatureFormat = temperatureFormat
    }
    
    
    private func encode(params: [String : String]) -> String {
        var stringToAppend = String()
        
        for param in params {
            stringToAppend = stringToAppend + "&\(param.key)=\(param.value)"
        }
        
        return stringToAppend
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
    public func requestCurrentWeather(with request: WeatherRequest) {
        
    }
    
    
    /**
     Requests a forecast using the specified ForecastRequest object
     
     - Parameters:
        - request: The ForecastRequest object used to make the request
 
    **/
    public func requestForecast(with request: WeatherRequest, forecastType: ForecastType) {
        
    }
    
//    public func currentWeather(in cityName: String, completionHandler: @escaping (_ result: [String:Any]) -> ()) {
//        let apiURL = HPOpenWeather.baseURL + "q=\(cityName)" + encode(params: params)
//    }
//
//    public func currentWeather(at coordinates: CLLocationCoordinate2D, completionHandler: @escaping (_ result: [String:Any]) -> ()) {
//        let apiURL = HPOpenWeather.baseURL + "lat=\(coordinates.latitude)&lon=\(coordinates.longitude)" + encode(params: params)
//
//    }
//
//    public func currentWeather(by cityId: String, completionHandler: @escaping (_ result: [String:Any]) -> ()) {
//        let apiURL = HPOpenWeather.baseURL + "id=\(cityId)" + encode(params: params)
//
//    }
//
//    public func currentWeather(by zipCode: String, countryCode: String, completionHandler: @escaping (_ result: [String:Any]) -> ()) {
//        let apiURL = HPOpenWeather.baseURL + "zip=\(zipCode),\(countryCode)" + encode(params: params)
//
//    }
//
//    public func forecast(in cityName: String, type: ForecastType, completionHandler: @escaping (_ result: [String:Any]) -> ()) {
//        let apiURL = type.rawValue + "q=\(cityName)" + encode(params: params)
//
//    }
//
//    public func forecast(for coordinates: CLLocationCoordinate2D, type: ForecastType, completionHandler: @escaping (_ result: [String:Any]) -> ()) {
//        let apiURL = type.rawValue + "lat=\(coordinates.latitude)&lon=\(coordinates.longitude)" + encode(params: params)
//
//    }
//
//    public func forecast(for cityId: String, type: ForecastType, completionHandler: @escaping (_ result: [String:Any]) -> ()) {
//        let apiURL = type.rawValue + "id=\(cityId)" + encode(params: params)
//
//    }
}
