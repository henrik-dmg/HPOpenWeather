//
//  WeatherSnapshot.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 28.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Codable protocol that holds all core information of a weather API response
public protocol WeatherSnapshot: Codable {
    /// The time of data calculation in UTC time
    var timeOfCalculation: Date { get }
    /// Holds the main information of the request, such as temperature, humidity, pressure, etc.
    var main: Main { get }
    /// Holds information about weather condition such description, group and id
    var condition: WeatherCondition { get }
    /// Holds information about wind, like speed and degrees
    var wind: Wind { get }
    /// Holds information about snowfall in the last one or three hours
    var snow: Precipitation { get }
    /// Holds information about rainfall in the last one or three hours
    var rain: Precipitation { get }
    /// The cloud coverage in percent
    var cloudCoverage: Int { get }
}

/// Protocol to handle missing snow or rainfall keys in JSON response
protocol PrecipitationOptional {
    /// Internal type to handle missing "snow" key in JSON response
    var _snow: Precipitation? { get }
    /// Internal type to handle missing "rain" key in JSON response
    var _rain: Precipitation? { get }
}
