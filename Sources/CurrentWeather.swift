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
    public var condition: WeatherCondition { return _condition?.first ?? WeatherCondition.unknown }
    public var wind: Wind
    public var snow: Precipitation { return _snow ?? Precipitation.none }
    public var rain: Precipitation { return _rain ?? Precipitation.none }
    
    /// Represents the city returned in the request
    public var city: City {
        return City(id: self._cityId,
                    name: self._name,
                    location: self._location,
                    countryCode: self._system.countryCode)
    }
    
    /// Holds information about sunset und sunrise times in UTC time at the location of the request
    public var sun: Sun {
        return Sun(set: self._system.sunset,
                   rise: self._system.sunrise)
    }
    
    internal var _snow: Precipitation?
    internal var _rain: Precipitation?
    internal var _clouds: Clouds?
    internal var _condition: [WeatherCondition]?
    /// The ID of the nearest city
    internal var _cityId: Int
    /// The name of the nearest city
    internal var _name: String
    
    /// The location coordinates of the request
    internal var _location: Coordinates
    
    /// System data of the request, such as country code, sunrise and sunset
    internal var _system: System
    
    
    enum CodingKeys: String, CodingKey {
        case _cityId = "id"
        case _name = "name"
        case timeOfCalculation = "dt"
        case _location = "coord"
        case _system = "sys"
        case main
        case wind
        case _snow = "snow"
        case _rain = "rain"
        case _clouds = "clouds"
        case _condition = "weather"
    }
}
