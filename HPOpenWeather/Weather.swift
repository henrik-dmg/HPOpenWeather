//
//  Weather.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 16/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation

public struct Weather {
    
    init(_ codable: CodableWeather) {
        
    }
}

public struct CodableWeather: Codable {
    public var id: Int
    public var name: String
    private var timeOfCalculation: Date
    public var coordinates: Coordinates
    public var system: System
    public var main: Main
    public var wind: Wind
    public var weather: [WeatherCondition]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case timeOfCalculation = "dt"
        case coordinates = "coord"
        case system = "sys"
        case main
        case wind
        case weather
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
        var countryCode: String
        var sunrise: Date
        var sunset: Date
        
        enum CodingKeys: String, CodingKey {
            case countryCode = "country"
            case sunrise
            case sunset
        }
    }
    
    public struct Main: Codable {
        var temperature: Double
        var humidity: Int
        var pressure: Int
        var temperatureMin: Double
        var temperatureMax: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case humidity
            case pressure
            case temperatureMin = "temp_min"
            case temperatureMax = "temp_max"
        }
    }
    
    public struct Wind: Codable {
        var speed: Double
        var degrees: Double
        
        enum CodingKeys: String, CodingKey {
            case speed
            case degrees = "deg"
        }
    }
}

public struct WeatherCondition: Codable {
    public var id: Int
    public var main: String
    public var description: String
    public var icon: String
}
