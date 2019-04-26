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
    func parameters() -> [URLQueryItem]
}

/**
 A request that uses coordinates
*/
public class LocationRequest: WeatherRequest {
    public func parameters() -> [URLQueryItem] {
        return [URLQueryItem(name: "lat", value: "\(coordinates.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinates.longitude)")]
    }
    
    public var coordinates: CLLocationCoordinate2D
    
    public init(_ coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
    }
}

/**
 [Wikipedia]: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes "See full list"
 
 A request that uses a city name and optional country code (use ISO 3166 country codes). For a full list, see [Wikipedia]
*/
public class CityNameRequest: WeatherRequest {
    public func parameters() -> [URLQueryItem] {
        var param = self.cityName
        if self.countryCode != nil {
            param.append(",\(self.countryCode!)")
        }
        
        return [URLQueryItem(name: "q", value: param)]
    }
    
    public var cityName: String
    public var countryCode: String?
    
    public init(_ cityName: String, countryCode: String?) {
        self.cityName = cityName
        self.countryCode = countryCode
    }
}

/**
 [OpenWeatherMap]: http://bulk.openweathermap.org/sample/ "See full list"
 
 A request that uses a city ID (see [OpenWeatherMap] for a full list of city IDs)
 
*/
public class CityIdRequest: WeatherRequest {
    public func parameters() -> [URLQueryItem] {
        return [URLQueryItem(name: "id", value: self.cityId)]
    }
    
    public var cityId: String
    
    public init(_ cityId: String) {
        self.cityId = cityId
    }
}

/**
 [Wikipedia]: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes "See full list"
 
 A request that uses a ZIP code and optional country code (if country is not specified then the search works for USA as a default).
 See [Wikipedia] for full list.
 
*/
public class ZipCodeRequest: WeatherRequest {
    public func parameters() -> [URLQueryItem] {
        var param = self.zipCode
        if self.countryCode != nil {
            param.append(",\(self.countryCode!)")
        }
        return [URLQueryItem(name: "zip", value: param)]
    }
    
    public var zipCode: String
    public var countryCode: String?
    
    public init(zipCode: String, countryCode: String?) {
        self.zipCode = zipCode
        self.countryCode = countryCode
    }
}


