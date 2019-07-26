//
//  Clouds.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 27.07.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Type that holds information about cloud coverage
public struct Clouds: Codable {
    /// Cloud Coverage measured in percent
    let all: Int
}
