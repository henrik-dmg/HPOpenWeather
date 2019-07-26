//
//  Precipitation.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 27.07.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Type that holds information about recent precipitation
public struct Precipitation: Codable, CustomStringConvertible {
    public var description: String {
        return "Precipitation(lastHour: \(lastHour), lastThreeHours: \(lastThreeHours))"
    }

    /// Precipitation volume for the last 1 hour, measured in mm
    public var lastHour: Double { return _1h ?? 0.00 }
    /// Precipitation volume for the last 3 hours, measured in mm
    public var lastThreeHours: Double { return _3h ?? 0.00 }

    /// Internal type to handle missing key in JSON response
    private var _1h: Double?
    /// Internal type to handle missing key in JSON response
    private var _3h: Double?

    /// Singleton property to indicate there was no precipitation within the last 3 hours
    static let none = Precipitation(_1h: 0, _3h: 0)

    enum CodingKeys: String, CodingKey {
        case _1h = "1h"
        case _3h = "3h"
    }
}
