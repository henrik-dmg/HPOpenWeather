//
//  Sun.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 27.07.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Type that holds information about sunrise and sunset times in UTC time
public struct Sun: Codable {
    /// Sunset time in UTC time
    public let sunSet: Date
    /// Sunrise time in UTC time
    public let sunRise: Date

    public var localSunset: Date {
        return sunSet
    }

    public var localSunrise: Date {
        return sunRise
    }

    enum CodingKeys: String, CodingKey {
        case sunSet = "sunset"
        case sunRise = "sunrise"
    }
}
