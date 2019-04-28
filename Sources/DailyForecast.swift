//
//  DailyForecast.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 28.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Codable type that holds weather forecast information in a daily frequency
public struct DailyForecast: Forecast {
    // Already has documentation
    public var city: City
    public var numberOfDataPoints: Int
    
    /// Helper struct that holds information on a daily basis
    public struct DataPoint: Codable {
        /// The timestamp of the forecast measurement
        public var forecastTimeStamp: Date
        /// Holds information about weather condition such description, group and id
        var condition: WeatherCondition
        /// Air humidity measured in percent
        var humidity: Int
        /// Atmospheric pressure on the sea level measured in hPa
        var pressure: Double
        /// Cloud Coverage in percent
        public var cloudCoverage: Int
        /// Holds information about the different temperatures troughtout the day
        public var temperature: Temperature
        /// Rain precipitation forecasted for the day in mm
        public var rain: Int { return _rain ?? 0 }
        /// Snow precipitation forecasted for the day in mm
        public var snow: Int { return _snow ?? 0 }
        /// Holds information about wind, such as speed and direction
        var wind: Wind {
            return Wind(speed: self._windSpeed ?? 0.00,
                        degrees: self._windDirection ?? 0.00)
        }
        
        /// Internal types to handle optional JSON keys in API response
        internal var _rain: Int?
        internal var _snow: Int?
        internal var _windSpeed: Double?
        internal var _windDirection: Double?
        
        public struct Temperature: Codable {
            /// Avery day temperature on that day
            var day: Double
            /// Avery night temperature on that day
            var night: Double
            /// Avery evening temperature on that day
            var evening: Double
            /// Avery morning temperature on that day
            var morning: Double
            /// Minimum temperature on that day
            var minimum: Double
            /// Maximum temperature on that day
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
            case temperature = "temp"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case city
        case numberOfDataPoints = "cnt"
    }
}
