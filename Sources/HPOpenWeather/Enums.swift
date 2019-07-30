//
//  Enums.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 26.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/// Declares which forecast endpoint should be used
public enum ForecastFrequency: String {
    /// Returns hourly forecast for the next 96 hours. Available for Developer, Professional and Enterprise accounts
    case hourly = "https://api.openweathermap.org/data/2.5/forecast/hourly?"
    /// Returns the forecast for the next 5 days in a 3 hour interval. Available for all accounts
    case threeHourly = "https://api.openweathermap.org/data/2.5/forecast?"
    
    /**
    Returns the URL corresponding to the forecast type
     */
    var url: URL {
        // We can force-unwrap URL because we know these API endpoints exist
        return URL(string: self.rawValue)!
    }
}

/// Declares which temperature unit is uses in API response
public enum TemperatureUnit: String {
    case celsius = "metric"
    case fahrenheit = "imperial"
    case kelvin
}

/// Declares which language is uses in API response
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
