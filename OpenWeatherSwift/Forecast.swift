//
//  Forecast.swift
//  OpenWeatherSwift
//
//  Created by Henrik Panhans on 12.02.17.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import SwiftyJSON

public enum ForecastType: String {
    case Hourly = "http://api.openweathermap.org/data/2.5/forecast?";
    case Daily = "http://api.openweathermap.org/data/2.5/forecast/daily?"
}

public struct Forecast {
    public var city: String
    public var country: String
    public var cityID: String
    public var temperatures = [Int]()
    public var clouds = [Float]()
    public var conditions = [String]()
    public var pressures = [Int]()
    public var humidities = [Float]()
    public var dates = [Date]()
    
    
    public init(data: JSON, type: ForecastType) {
        if type == .Hourly {
            self.city = data["city"]["name"].stringValue
            self.country = data["city"]["country"].stringValue
            self.cityID = data["city"]["id"].stringValue
            
            let subdata = data["list"]
            
            for subJSON in subdata.array! {
                self.temperatures.append(subJSON["main"]["temp"].intValue)
                self.clouds.append(subJSON["clouds"]["all"].floatValue)
                self.conditions.append(subJSON["weather"]["main"].stringValue)
                self.pressures.append(subJSON["main"]["pressure"].intValue)
                self.humidities.append(subJSON["main"]["humidity"].floatValue)
            }
        } else {
            self.city = data["city"]["name"].stringValue
            self.country = data["city"]["country"].stringValue
            self.cityID = data["city"]["id"].stringValue
            
            let subdata = data["list"]
            
            for subJson in subdata.array! {
                self.temperatures.append(subJson["main"]["temp"].intValue)
                self.clouds.append(subJson["clouds"]["all"].floatValue)
                self.conditions.append(subJson["weather"]["main"].stringValue)
                self.pressures.append(subJson["main"]["pressure"].intValue)
                self.humidities.append(subJson["main"]["humidity"].floatValue)
            }
        }
    }
}
