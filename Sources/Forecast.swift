//
//  Forecast.swift
//  OpenWeatherSwift
//
//  Created by Henrik Panhans on 12.02.17.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import Foundation

// TODO: Document this bitch and clean up internal stuff
public struct Forecast: Codable {
    
    public var city: City
    
    public var numberOfDataPoints: Int
    
    public var dataPoints: [DataPoint]
    
    
    public struct DataPoint: WeatherSnapshot, PrecipitationOptional {
        public var forecastTimeStamp: Date
        
        internal var _snow: Precipitation?
        
        internal var _rain: Precipitation?
        internal var _clouds: Clouds?
        
        public var timeOfCalculation: Date
        
        public var main: Main
        
        public var condition: WeatherCondition
        
        public var wind: Wind
        
        public var snow: Precipitation { return _snow ?? Precipitation.none }
        
        public var rain: Precipitation { return _rain ?? Precipitation.none }
        
        public var cloudCoverage: Int { return self._clouds?.all ?? 0 }
        
        enum CodingKeys: String, CodingKey {
            case forecastTimeStamp = "dt"
            case timeOfCalculation = "dt_txt"
            case _snow = "snow"
            case _rain = "rain"
            case main
            case condition = "weather"
            case wind
            case _clouds = "clouds"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case city
        case numberOfDataPoints = "cnt"
        case dataPoints = "list"
    }
}
