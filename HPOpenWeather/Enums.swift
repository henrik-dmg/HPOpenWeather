//
//  Enums.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 26.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

public enum ForecastType: String {
    case current = "https://api.openweathermap.org/data/2.5/weather?"
    case hourly = "http://api.openweathermap.org/data/2.5/forecast?"
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
