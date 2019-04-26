//
//  WeatherRequest.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 26.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation

public class WeatherRequest {
    private var searchCriteria: SearchCriteria = .cityName
    public var coordinates: CLLocationCoordinate2D? {
        didSet {
            searchCriteria = .location
        }
    }
    public var cityId: String? {
        didSet {
            searchCriteria = .cityId
        }
    }
    public var cityName: String? {
        didSet {
            searchCriteria = .cityName
        }
    }
    public var zipCode: (zipCode: String, countryCode: String)? {
        didSet {
            searchCriteria = .zipCode
        }
    }
    
    public convenience init(coordinates: CLLocationCoordinate2D) {
        self.init()
        self.coordinates = coordinates
    }
    
    public convenience init(cityName: String) {
        self.init()
        self.cityName = cityName
    }
    
    public convenience init(cityId: String) {
        self.init()
        self.cityId = cityId
    }
    
    public convenience init(zipCode: String, countryCode: String) {
        self.init()
        self.zipCode = (zipCode, countryCode)
    }
    
    private enum SearchCriteria {
        case cityName
        case zipCode
        case cityId
        case location
    }
}
