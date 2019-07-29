//
//  System.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 27.07.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Type that holds system information such as country code, sunrise and sunset times
struct System: Codable {
    /**
     [Wikipedia]: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes "See full list"

     An ISO 3166 country code specifying the country of the request's location. For a full list of codes see [Wikipedia]
     */
    let countryCode: String
    /// The sunrise time of the request's location in UTC time
    let sunrise: Date
    /// The sunset time of the request's location in UTC time
    let sunset: Date

    enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case sunrise
        case sunset
    }
}
