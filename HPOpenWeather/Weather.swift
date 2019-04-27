//
//  Weather.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 16/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation

public class CurrentWeather: Codable {
    public var cityId: Int
    public var name: String
    public var timeOfCalculation: Date
    public var location: Coordinates
    public var system: System
    public var main: Main
    public var wind: Wind
    public var condition: [WeatherCondition]
    public var snow: Precipitation?
    public var rain: Precipitation?
    
    enum CodingKeys: String, CodingKey {
        case cityId = "id"
        case name
        case timeOfCalculation = "dt"
        case location = "coord"
        case system = "sys"
        case main
        case wind
        case condition = "weather"
        case snow
        case rain
    }
    
    public struct Coordinates: Codable {
        public var longitude: Double
        public var latitude: Double
        
        func object() -> CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case latitude = "lat"
        }
    }
    
    public struct System: Codable {
        public var countryCode: String
        public var sunrise: Date
        public var sunset: Date
        
        enum CodingKeys: String, CodingKey {
            case countryCode = "country"
            case sunrise
            case sunset
        }
    }
    
    public struct Main: Codable {
        public var temperature: Double
        public var humidity: Int
        public var pressure: Int
        public var temperatureMin: Double
        public var temperatureMax: Double
        public var seaLevelPressure: Int
        public var groundLevelPressure: Int
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case humidity
            case pressure
            case temperatureMin = "temp_min"
            case temperatureMax = "temp_max"
            case seaLevelPressure = "sea_level"
            case groundLevelPressure = "grnd_level"
        }
    }
    
    public struct Wind: Codable {
        public var speed: Double
        public var degrees: Double
        
        enum CodingKeys: String, CodingKey {
            case speed
            case degrees = "deg"
        }
    }
    
    public struct WeatherCondition: Codable {
        public var id: Int
        public var main: String
        public var description: String
        public var icon: String
    }
    
    public struct Precipitation: Codable {
        public var lastHour: Int
        public var lastThreeHours: Int
        
        enum CodingKeys: String, CodingKey {
            case lastHour = "1h"
            case lastThreeHours = "3h"
        }
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let snow = try container.decodeIfPresent(Precipitation.self, forKey: .snow) {
            self.snow = snow
        }
        
        if let rain = try container.decodeIfPresent(Precipitation.self, forKey: .rain) {
            self.rain = rain
        }
    }
}
