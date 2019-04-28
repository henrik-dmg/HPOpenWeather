//
//  SnapshotSubtypes.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 28.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation

/// Custom Location type which holds latitude and longitude, similar to CLLocationCoordinate2D
public struct Coordinates: Codable {
    /// Longitude of the object
    public var longitude: Double
    /// Latitude of the object
    public var latitude: Double
    
    func _2d() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

/// Type that holds system information such as country code, sunrise and sunset times
public struct System: Codable {
    /**
     [Wikipedia]: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes "See full list"
     
     An ISO 3166 country code specifying the country of the request's location. For a full list of codes see [Wikipedia]
     */
    public var countryCode: String
    /// The sunrise time of the request's location in UTC time
    public var sunrise: Date
    /// The sunset time of the request's location in UTC time
    public var sunset: Date
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case sunrise
        case sunset
    }
}

/// Type that holds the main information of the request, such as temperature, humidity, etc.
public struct Main: Codable {
    /// The current temperature in the format specified in the request
    public var temperature: Double
    /// The current humidity measured in percent
    public var humidity: Int
    /// The current air pressure measured in hPa
    public var pressure: Int
    /// The minimum temperature reached on the day of the request
    public var temperatureMin: Double
    /// The maximum temperature reached on the day of the request
    public var temperatureMax: Double
    /// The current sea level pressure measured in hPa (Note: Is zero when data is unavailable)
    public var seaLevelPressure: Int { return _seaLvl ?? 0 }
    /// The current ground level pressure measured in hPa (Note: Is zero when data is unavailable)
    public var groundLevelPressure: Int { return _groundLvl ?? 0 }
    
    /// Internal type to handle missing sea level pressure data
    private var _seaLvl: Int?
    /// Internal type to handle missing ground level pressure data
    private var _groundLvl: Int?
    
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

/// Type that holds information about wind speed and direction measured in degrees
public struct Wind: Codable {
    /// The current wind speed depending on the request's unit (metric: meter/second, imperial: miles/hour)
    public var speed: Double
    /// The wind direction measured in degrees from North
    public var degrees: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
}

/// Type that holds information about weather conditions
public struct WeatherCondition: Codable {
    /// The weather condition ID
    public var id: Int
    /// Group of weather parameters
    public var main: String
    /// The weather condition within the group
    public var description: String
    /// The ID of the corresponding weather icon
    public var icon: String
}

/// Type that holds information about recent precipitation
public struct Precipitation: Codable, CustomStringConvertible {
    public var description: String {
        return "Precipitation(lastHour: \(lastHour), lastThreeHours: \(lastThreeHours))"
    }
    
    /// Precipitation volume for the last 1 hour, measured in mm
    public var lastHour: Int { return _1h ?? 0 }
    /// Precipitation volume for the last 3 hours, measured in mm
    public var lastThreeHours: Int { return _3h ?? 0 }
    
    /// Internal type to handle missing key in JSON response
    private var _1h: Int?
    /// Internal type to handle missing key in JSON response
    private var _3h: Int?
    
    /// Singleton property to indicate there was no precipitation within the last 3 hours
    static let none = Precipitation(_1h: 0, _3h: 0)
    
    enum CodingKeys: String, CodingKey {
        case _1h = "1h"
        case _3h = "3h"
    }
}

/// Type that holds information about cloud coverage
struct Clouds: Codable {
    
    /// Cloud Coverage measured in percent
    var all: Int
}
