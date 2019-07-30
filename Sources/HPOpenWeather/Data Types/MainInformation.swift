//
//  Main.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 27.07.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Type that holds the main information of the request, such as temperature, humidity, etc.
public struct Main: Codable {

    /// The current temperature in the format specified in the request
    public let temperature: Double
    /// The current humidity measured in percent
    public let humidity: Int
    /// The current air pressure measured in hPa
    public let pressure: Double
    /// The minimum temperature reached on the day of the request
    public let temperatureMin: Double
    /// The maximum temperature reached on the day of the request
    public let temperatureMax: Double
    /// The current sea level pressure measured in hPa (Note: Is zero when data is unavailable)
    public var seaLevelPressure: Double { return _seaLvl ?? 0.00 }
    /// The current ground level pressure measured in hPa (Note: Is zero when data is unavailable)
    public var groundLevelPressure: Double { return _groundLvl ?? 0.00 }

    /// Internal type to handle missing sea level pressure data
    private var _seaLvl: Double?
    /// Internal type to handle missing ground level pressure data
    private var _groundLvl: Double?

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
