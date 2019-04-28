//
//  DailyForecast.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 28.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

public struct DailyForecast: Forecast {
    public var city: City
    public var numberOfDataPoints: Int
    
    public struct DataPoint: Codable {
        /// The timestamp of the forecast measurement
        public var forecastTimeStamp: Date
        var condition: WeatherCondition
        var humidity: Int
        var pressure: Double
        public var cloudCoverage: Int
        public var rain: Int { return _rain ?? 0 }
        public var snow: Int { return _snow ?? 0 }
        var wind: Wind {
            return Wind(speed: self._windSpeed ?? 0.00,
                        degrees: self._windDirection ?? 0.00)
        }
        
        internal var _rain: Int?
        internal var _snow: Int?
        internal var _windSpeed: Double?
        internal var _windDirection: Double?
        
        public struct Temperature: Codable {
            var day: Double
            var night: Double
            var evening: Double
            var morning: Double
            var minimum: Double
            var maximum: Double
            
            enum CodingKeys: String, CodingKey {
                case day
                case night
                case minimum = "min"
                case maximum = "max"
                case morning = "morn"
                case evening = "eve"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case condition = "weather"
            case humidity, pressure
            case cloudCoverage = "clouds"
            case _rain = "rain"
            case _snow = "snow"
            case _windSpeed = "speed"
            case _windDirection = "deg"
            case forecastTimeStamp = "dt"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case city
        case numberOfDataPoints = "cnt"
    }
}
