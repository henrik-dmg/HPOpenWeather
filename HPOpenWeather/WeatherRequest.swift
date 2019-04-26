//
//  WeatherRequest.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 26.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation

public protocol WeatherRequest {
    func parameters() -> [String:Any]
}

public class LocationRequest: WeatherRequest {
    public func parameters() -> [String : Any] {
        return ["lat": coordinates.latitude,
                "lon": coordinates.longitude]
    }
    
    public var coordinates: CLLocationCoordinate2D
    
    public init(_ coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
    }
}

public class CityNameRequest: WeatherRequest {
    public func parameters() -> [String : Any] {
        var param = self.cityName
        if self.countryCode != nil {
            param.append(",\(self.countryCode!)")
        }
        return ["q": param]
    }
    
    public var cityName: String
    public var countryCode: String?
    
    public init(_ cityName: String, countryCode: String?) {
        self.cityName = cityName
        self.countryCode = countryCode
    }
}

public class CityIdRequest: WeatherRequest {
    public func parameters() -> [String : Any] {
        return ["id": self.cityId]
    }
    
    public var cityId: String
    
    public init(_ cityId: String) {
        self.cityId = cityId
    }
}

public class ZipCodeRequest: WeatherRequest {
    public func parameters() -> [String : Any] {
        var param = self.zipCode
        if self.countryCode != nil {
            param.append(",\(self.countryCode!)")
        }
        return ["zip": param]
    }
    
    public var zipCode: String
    public var countryCode: String?
    
    public init(zipCode: String, countryCode: String?) {
        self.zipCode = zipCode
        self.countryCode = countryCode
    }
}


