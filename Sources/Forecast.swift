//
//  Forecast.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 28.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

public protocol Forecast: Codable {
    /// The nearest city, returned by the API
    var city: City { get }
    /// The number of measurements returned by the API
    var numberOfDataPoints: Int { get }
}
