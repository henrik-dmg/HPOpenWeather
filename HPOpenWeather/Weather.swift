//
//  Weather.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 16/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation

/**
 A Codable type that wraps the API response for the current weather request in a usable type
 */
public class CurrentWeather: Codable {
    /// The ID of the nearest city
    public var cityId: Int
    /// The name of the nearest city
    public var name: String
    /// The time of data calculation in UTC time
    public var timeOfCalculation: Date
    /// The location coordinates of the request
    public var location: Coordinates
    /// System data of the request, such as country code, sunrise and sunset
    public var system: System
    /// Holds the main information of the request, such as temperature, humidity, pressure, etc.
    public var main: Main
    /// Current wind information, like wind speed and degrees
    public var wind: Wind
    /// List of current weather conditions
    public var conditions: [WeatherCondition]
    /// Information about snowfall in the last one or three hours
    public var snow: Precipitation { return _snow ?? Precipitation.none }
    /// Information about rainfall in the last one or three hours
    public var rain: Precipitation { return _rain ?? Precipitation.none }
    
    /// Internal type to handle missing "snow" key in JSON response
    private var _snow: Precipitation?
    /// Internal type to handle missing "rain" key in JSON response
    private var _rain: Precipitation?
    
    enum CodingKeys: String, CodingKey {
        case cityId = "id"
        case name
        case timeOfCalculation = "dt"
        case location = "coord"
        case system = "sys"
        case main
        case wind
        case conditions = "weather"
        case _snow = "snow"
        case _rain = "rain"
    }
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
    public var seaLevelPressure: Int { return _seaLvl ?? 0 }
    public var groundLevelPressure: Int { return _groundLvl ?? 0 }
    
    private var _seaLvl: Int?
    private var _groundLvl: Int?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
        case pressure
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case _seaLvl = "sea_level"
        case _groundLvl = "grnd_level"
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

public struct Precipitation: Codable, CustomStringConvertible {
    public var description: String {
        return "Precipitation(lastHour: \(lastHour), lastThreeHours: \(lastThreeHours))"
    }
    
    public var lastHour: Int { return _1h ?? 0}
    public var lastThreeHours: Int { return _3h ?? 0}
    
    private var _1h: Int?
    private var _3h: Int?
    
    static let none = Precipitation(_1h: 0, _3h: 0)
    
    enum CodingKeys: String, CodingKey {
        case _1h = "1h"
        case _3h = "3h"
    }
}
