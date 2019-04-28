//
//  Weather.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 16/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import Foundation

/**
 A Codable type that wraps the API response for the current weather request in a usable type
 */
public struct CurrentWeather: WeatherSnapshot, PrecipitationOptional {
    public var cloudCoverage: Int { return _clouds?.all ?? 0 }
    
    public var timeOfCalculation: Date
    
    public var main: Main
    
    public var conditions: [WeatherCondition]
    
    public var wind: Wind
    
    public var snow: Precipitation { return _snow ?? Precipitation.none }
    
    public var rain: Precipitation { return _rain ?? Precipitation.none }
    
    internal var _snow: Precipitation?
    internal var _rain: Precipitation?
    internal var _clouds: Clouds?
    
    /// The ID of the nearest city
    public var cityId: Int
    /// The name of the nearest city
    public var name: String
    
    /// The location coordinates of the request
    public var location: Coordinates
    /// System data of the request, such as country code, sunrise and sunset
    public var system: System
    
    
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
        case _clouds = "clouds"
    }
}
