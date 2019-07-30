//
//  City.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 27.07.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation

/// Type that holds information about the reqeuest's nearest city
public struct City: Codable {
    /// The ID assigned to the city
    public let id: Int
    /// The name of the city
    public let name: String
    /// The location of the city
    public let location: CLLocationCoordinate2D
    /// The country code of the city
    public let countryCode: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location = "coord"
        case countryCode = "country"
    }
}
