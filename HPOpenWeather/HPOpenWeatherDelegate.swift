//
//  HPOpenWeatherDelegate.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 26.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

public protocol HPOpenWeatherDelegate: class {
    func didRequest(_ weather: Weather, for request: WeatherRequest)
}
