//
//  WeatherRequest.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 26.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation

/// Generic protocol that returns the parameters needed for an API call
public protocol WeatherRequest {
    /// Returns an array of URLQueryItem which are needed to request the appropriate data for the request
    func queryItems() -> [URLQueryItem]
}

/**
 Type that uses coordinates to request weather data
*/
public class LocationRequest: WeatherRequest {
    public func queryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "lat", value: "\(coordinates.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinates.longitude)")]
    }
    
    /// The coordinates specified for the request
    public var coordinates: CLLocationCoordinate2D
    
    /// Public initialiser to quickly create a new request by supplying coordinates
    public init(_ coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
    }
}

/**
 [Wikipedia]: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes "See full list"
 
 Type that uses a city name and optional country code (use ISO 3166 country codes).
 For a full list, see [Wikipedia].
*/
public class CityNameRequest: WeatherRequest {
    public func queryItems() -> [URLQueryItem] {
        var param = self.cityName
        param.add(self.countryCode)
        
        return [URLQueryItem(name: "q", value: param)]
    }
    
    /// The city name used in the request
    public var cityName: String
    /// The country code in ISO 3166 format used to specify a country when requesting weather data.
    public var countryCode: String?
    
    /**
     Public initialiser to quickly create a new request by supplying a
     city name and optional ISO 3166 country code.
     */
    public init(_ cityName: String, countryCode: String?) {
        self.cityName = cityName
        self.countryCode = countryCode
    }
}

/**
 [OpenWeatherMap]: http://bulk.openweathermap.org/sample/ "See full list"
 
 Type that uses a city ID (see [OpenWeatherMap] for a full list of city IDs).
*/
public class CityIdRequest: WeatherRequest {
    public func queryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "id", value: self.cityId)]
    }
    
    public var cityId: String
    
    public init(_ cityId: String) {
        self.cityId = cityId
    }
}

/**
 [Wikipedia]: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes "See full list"
 
 Type that uses a ZIP code and optional country code (if country is not specified then the search works for USA as a default).
 See [Wikipedia] for full list.
*/
public class ZipCodeRequest: WeatherRequest {
    public func queryItems() -> [URLQueryItem] {
        var param = self.zipCode
        param.add(self.countryCode)
        
        return [URLQueryItem(name: "zip", value: param)]
    }
    
    /// The ZIP code used in the request
    public var zipCode: String
    /// The ISO 3166 country code used in the request. If no code is specified then the search works for USA as a default.
    public var countryCode: String?
    
    /// Public initialiser to quickly create a new request by supplying a ZIP code and optional ISO 3166 country code.
    public init(zipCode: String, countryCode: String?) {
        self.zipCode = zipCode
        self.countryCode = countryCode
    }
}

fileprivate extension String {
    mutating func add(_ code: String?) {
        if let country = code {
            self.append(",\(country)")
        }
        return
    }
}
