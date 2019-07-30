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
public struct CurrentWeather: WeatherSnapshot {
    // Already has documentation
    public var cloudCoverage: Int { return _clouds?.all ?? 0 }
    public let timeOfCalculation: Date
    public let main: Main
    public var condition: WeatherCondition { return _condition?.first ?? WeatherCondition.unknown }
    public let wind: Wind
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
        return Sun(sunSet: self._system.sunset,
                   sunRise: self._system.sunrise)
    }
    
    /// Internal property to handle missing "snow" key in JSON reponse
    internal var _snow: Precipitation?
    /// Internal property to handle missing "rain" key in JSON reponse
    internal var _rain: Precipitation?
    /// Internal property to handle missing "clouds" key in JSON reponse
    internal var _clouds: Clouds?
    /// Internal property to handle array in JSON response that shouldn't be an array lol
    internal var _condition: [WeatherCondition]?
    /// The ID of the nearest city
    internal var _cityId: Int
    /// The name of the nearest city
    internal var _name: String
    /// The location coordinates of the request
    internal var _location: CLLocationCoordinate2D
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
