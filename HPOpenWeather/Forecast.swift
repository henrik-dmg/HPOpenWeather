//
//  Forecast.swift
//  OpenWeatherSwift
//
//  Created by Henrik Panhans on 12.02.17.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import Foundation

public class Forecast {
    public var city: String = ""
    public var country: String = ""
    public var cityID: String = ""
    public var tempNight = [Double]()
    public var tempMin = [Double]()
    public var tempEve = [Double]()
    public var tempDay = [Double]()
    public var tempMax = [Double]()
    public var tempMorn = [Double]()
    public var clouds = [Double]()
    public var conditions = [String]()
    public var pressures = [Double]()
    public var humidities = [Double]()
    public var rain = [Double]()
    public var dates = [Date]()
    public var dt = [Double]()
    public var icon = [String]()
//    public var weatherSmallDesc = [String]()
//    public var weatherDesc = [String]()
    
    public init(data: [String:Any], type: ForecastType) {
        
    }
}
