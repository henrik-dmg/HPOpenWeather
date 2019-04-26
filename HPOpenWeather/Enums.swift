//
//  Enums.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 26.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Declares which forecast endpoint should be used
public enum ForecastType: String {
    
    /// Returns hourly forecast for the next 96 hours
    case hourly = "http://api.openweathermap.org/data/2.5/forecast/hourly?"
    
    /// Returns the forecast for the next 5 days in a 3 hour interval
    case threeHourly = "http://api.openweathermap.org/data/2.5/forecast?"
    
    /// Returns the daily forecast for the next 16 days
    case daily = "http://api.openweathermap.org/data/2.5/forecast/daily?"
}

public enum TemperatureUnit: String {
    case celsius = "metric"
    case fahrenheit = "imperial"
    case kelvin = ""
}

public enum Language : String {
    case english = "en",
    russian = "ru",
    italian = "it",
    spanish = "es",
    ukrainian = "uk",
    german = "de",
    portuguese = "pt",
    romanian = "ro",
    polish = "pl",
    finnish = "fi",
    dutch = "nl",
    french = "fr",
    bulgarian = "bg",
    swedish = "sv",
    chineseTraditional = "zh_tw",
    chineseSimplified = "zh_cn",
    turkish = "tr",
    croatian = "hr",
    catalan = "ca"
}
