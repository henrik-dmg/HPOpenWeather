//
//  WeatherRequest.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 26.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

public class WeatherRequest {
    var type: ForecastType
    private var searchCriteria: SearchCriteria = .cityName
    
    init(forecastType: ForecastType = .current) {
        self.type = forecastType
    }
    
    private enum SearchCriteria {
        case cityName
        case zipCode
        case cityId
        case location
    }
}
