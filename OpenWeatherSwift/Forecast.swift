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
    public var city: String = ""
    public var country: String = ""
    public var cityID: String = ""
    public var tempNight = [Double]()
    public var tempMin = [Double]()
    public var tempEve = [Double]()
    public var tempDay = [Double]()
    public var tempMax = [Double]()
    public var tempMorn = [Double]()
    public var clouds = [Double]()
    public var conditions = [String]()
    public var pressures = [Double]()
    public var humidities = [Double]()
    public var rain = [Double]()
    public var dates = [Date]()
    public var dt = [Double]()
    public var icon = [String]()
//    public var weatherSmallDesc = [String]()
//    public var weatherDesc = [String]()
    
    public init(data: JSON, type: ForecastType) {
     if type == .Hourly {
        //            self.city = data["city"]["name"].stringValue
        //            self.country = data["city"]["country"].stringValue
        //            self.cityID = data["city"]["id"].stringValue
        //
        //            let subdata = data["list"]
        //
        //            for subJSON in subdata.array! {
        //                self.temperatures.append(subJSON["main"]["temp"].doubleValue)
        //                self.clouds.append(subJSON["clouds"]["all"].doubleValue)
        //                self.conditions.append(subJSON["weather"]["main"].stringValue)
        //                self.pressures.append(subJSON["main"]["pressure"].doubleValue)
        //                self.humidities.append(subJSON["main"]["humidity"].doubleValue)
        //                self.rain.append(subJSON["rain"]["3h"].doubleValue)
        //                self.icon.append(subJSON["weather"][0]["icon"].stringValue)
        //                self.dt.append(subJSON["dt"].doubleValue)
        //
        ////                let date = subJSON["dt_txt"].stringValue.convertToDate(withFormat: "yyyy-MM-dd HH:mm:ss")
        //                let date = NSDate(timeIntervalSince1970: subJSON["dt"].doubleValue)
        //
        //                self.dates.append(date as Date)
        //            }
     } else {
        self.city = data["city"]["name"].stringValue
        self.country = data["city"]["country"].stringValue
        self.cityID = data["city"]["id"].stringValue
        
        let subdata = data["list"]
        
        for subJson in subdata.array! {
            self.tempNight.append(subJson["temp"]["night"].doubleValue)
            self.tempMin.append(subJson["temp"]["min"].doubleValue)
            self.tempEve.append(subJson["temp"]["eve"].doubleValue)
            self.tempDay.append(subJson["temp"]["day"].doubleValue)
            self.tempMax.append(subJson["temp"]["max"].doubleValue)
            self.tempMorn.append(subJson["temp"]["morn"].doubleValue)
            
            self.conditions.append(subJson["weather"]["description"].stringValue)
            self.clouds.append(subJson["clouds"].doubleValue)
            self.pressures.append(subJson["pressure"].doubleValue)
            self.humidities.append(subJson["humidity"].doubleValue)
            self.icon.append(subJson["weather"][0]["icon"].stringValue)
//            self.weatherSmallDesc(subJson["weather"][0]["main"].stringValue)
//            self.weatherDesc(subJson["weather"][0]["description"].stringValue)
            
            
            self.dt.append(subJson["dt"].doubleValue)
            
            let date = NSDate(timeIntervalSince1970: subJson["dt"].doubleValue)
            
            self.dates.append(date as Date)
        }
      }
    }
}
