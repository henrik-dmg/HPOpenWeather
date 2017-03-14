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

public class Forecast {
    public var city: String
    public var country: String
    public var cityID: String
    public var temperatures = [Double]()
    public var clouds = [Double]()
    public var conditions = [String]()
    public var pressures = [Double]()
    public var humidities = [Double]()
    public var rain = [Double]()
    public var dates = [Date]()
    public var dt = [Double]()
    public var icon = [String]()
    
    public init(data: JSON, type: ForecastType) {
        if type == .Hourly {
            self.city = data["city"]["name"].stringValue
            self.country = data["city"]["country"].stringValue
            self.cityID = data["city"]["id"].stringValue
            
            let subdata = data["list"]
            
            for subJSON in subdata.array! {
                self.temperatures.append(subJSON["main"]["temp"].doubleValue)
                self.clouds.append(subJSON["clouds"]["all"].doubleValue)
                self.conditions.append(subJSON["weather"]["main"].stringValue)
                self.pressures.append(subJSON["main"]["pressure"].doubleValue)
                self.humidities.append(subJSON["main"]["humidity"].doubleValue)
                self.rain.append(subJSON["rain"]["3h"].doubleValue)
                self.icon.append(subJSON["weather"][0]["icon"].stringValue)
                self.dt.append(subJSON["dt"].doubleValue)
                
                let date = subJSON["dt_txt"].stringValue.convertToDate(withFormat: "yyyy-MM-dd HH:mm:ss")
                self.dates.append(date)
            }
        } else {
            self.city = data["city"]["name"].stringValue
            self.country = data["city"]["country"].stringValue
            self.cityID = data["city"]["id"].stringValue
            
            let subdata = data["list"]
            
            for subJson in subdata.array! {
                self.temperatures.append(subJson["main"]["temp"].doubleValue)
                self.clouds.append(subJson["clouds"]["all"].doubleValue)
                self.conditions.append(subJson["weather"]["main"].stringValue)
                self.pressures.append(subJson["main"]["pressure"].doubleValue)
                self.humidities.append(subJson["main"]["humidity"].doubleValue)

                self.dt.append(subJson["dt"].doubleValue)
                let date = subJson["dt_txt"].stringValue.convertToDate(withFormat: "yyyy-MM-dd HH:mm:ss")
                
                self.dates.append(date)
            }
        }
    }
}
