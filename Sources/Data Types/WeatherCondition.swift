//
//  WeatherCondition.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 27.07.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Type that holds information about weather conditions
public struct WeatherCondition: Codable {
    /// The weather condition ID
    public let id: Int
    /// Group of weather parameters
    public let main: String
    /// The weather condition within the group
    public let description: String
    /// The ID of the corresponding weather icon
    public let iconString: String
    /// The corresponding system weather icon
    @available(iOS 13.0, *)
    public var systemIcon: WeatherSystemIcon? {
        return WeatherIcon.make(from: iconString)
    }

    static let unknown = WeatherCondition(id: 0,
                                          main: "Unknown Weather Condition",
                                          description: "No Description",
                                          iconString: "No Icon")
}
