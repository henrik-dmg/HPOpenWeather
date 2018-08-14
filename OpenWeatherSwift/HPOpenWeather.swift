//
//  OpenWeatherApi.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 15/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import Alamofire
import CoreLocation
import SwiftyJSON

public enum TemperatureUnit: String {
    case Celsius = "metric"
    case Fahrenheit = "imperial"
    case Kelvin = ""
}

public enum Language : String {
    case English = "en",
    Russian = "ru",
    Italian = "it",
    Spanish = "es",
    Ukrainian = "uk",
    German = "de",
    Portuguese = "pt",
    Romanian = "ro",
    Polish = "pl",
    Finnish = "fi",
    Dutch = "nl",
    French = "fr",
    Bulgarian = "bg",
    Swedish = "sv",
    ChineseTraditional = "zh_tw",
    ChineseSimplified = "zh_cn",
    Turkish = "tr",
    Croatian = "hr",
    Catalan = "ca"
}

public class OpenWeatherSwift {
    
    private let currentBase = "https://api.openweathermap.org/data/2.5/weather?"
    
    private var params = [String : AnyObject]()
    public var temperatureFormat: TemperatureUnit = .Kelvin {
        didSet {
            params["units"] = temperatureFormat.rawValue as AnyObject?
        }
    }
    
    public var language: Language = .English {
        didSet {
            params["lang"] = language.rawValue as AnyObject?
        }
    }
    
    public init(apiKey: String) {
        params["appid"] = apiKey as AnyObject?
    }
    
    public convenience init(apiKey: String, temperatureFormat: TemperatureUnit) {
        self.init(apiKey: apiKey)
        self.temperatureFormat = temperatureFormat
        self.params["units"] = temperatureFormat.rawValue as AnyObject?
        
    }
    
    public convenience init(apiKey: String, temperatureFormat: TemperatureUnit, lang: Language) {
        self.init(apiKey: apiKey, temperatureFormat: temperatureFormat)
        
        self.language = lang
        self.temperatureFormat = temperatureFormat
        
        params["units"] = temperatureFormat.rawValue as AnyObject?
        params["lang"] = lang.rawValue as AnyObject?
    }
    
    
    func encode(params: [String: AnyObject]) -> String {
        var stringToAppend = String()
        
        for param in params {
            stringToAppend = stringToAppend + "&\(param.key)=\(param.value)"
        }
        
        return stringToAppend
    }
    
    public func getIconFromID(id: String) -> UIImage {
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
    
    public func currentWeatherByCity(name: String, completionHandler: @escaping (_ result: JSON) -> ()) {
        let apiURL = currentBase + "q=\(name)" + encode(params: params)
        
        Alamofire.request(apiURL).responseJSON { (response) in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                
                completionHandler(json)
            } else {
                print("error")
            }
        }
    }
    
    public func currentWeatherByCoordinates(coords: CLLocationCoordinate2D, completionHandler: @escaping (_ result: JSON) -> ()) {
        let apiURL = currentBase + "lat=\(coords.latitude)&lon=\(coords.longitude)" + encode(params: params)
        
        Alamofire.request(apiURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!).responseJSON { (response) in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                
                completionHandler(json)
            } else {
                print("error")
            }
        }
    }
    
    public func currentWeatherByID(id: String, completionHandler: @escaping (_ result: Any) -> ()) {
        let apiURL = currentBase + "id=\(id)" + encode(params: params)
        
        Alamofire.request(apiURL).responseJSON { (response) in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                
                completionHandler(json)
            } else {
                print("error")
            }
        }
    }
    
    public func currentWeatherByZIP(code: String, countryCode: String, completionHandler: @escaping (_ result: Any) -> ()) {
        let apiURL = currentBase + "zip=\(code),\(countryCode)" + encode(params: params)
        
        Alamofire.request(apiURL).responseJSON { (response) in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                
                completionHandler(json)
            } else {
                print("error")
            }
        }
    }
    
    public func forecastWeatherByCity(name: String, type: ForecastType, completionHandler: @escaping (_ result: JSON) -> ()) {
        let apiURL = type.rawValue + "q=\(name)" + encode(params: params)
        
        Alamofire.request(apiURL).responseJSON { (response) in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                
                completionHandler(json)
            } else {
                print("error")
            }
        }
    }
    
    public func forecastWeatherByCoordinates(coords: CLLocationCoordinate2D, type: ForecastType, completionHandler: @escaping (_ result: JSON) -> ()) {
        let apiURL = type.rawValue + "lat=\(coords.latitude)&lon=\(coords.longitude)" + encode(params: params)
        
        Alamofire.request(apiURL).responseJSON { (response) in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                
                completionHandler(json)
            } else {
                print("error")
            }

        }
    }
    
    public func forecastWeatherByID(id: String, type: ForecastType, completionHandler: @escaping (_ result: JSON) -> ()) {
        let apiURL = type.rawValue + "id=\(id)" + encode(params: params)
        
        Alamofire.request(apiURL).responseJSON { (response) in
            if response.result.isSuccess {
                let json = JSON(response.result.value as Any)
                
                completionHandler(json)
            } else {
                print("error")
            }
        }
    }
}
