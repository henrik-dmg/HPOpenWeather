//
//  Wind.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 27.07.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Type that holds information about wind speed and direction measured in degrees
public struct Wind: Codable {
    /// The current wind speed depending on the request's unit (metric: meter/second, imperial: miles/hour)
    public let speed: Double
    /// The wind direction measured in degrees from North
    public let degrees: Double

    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
}
