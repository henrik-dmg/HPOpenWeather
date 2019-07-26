//
//  ApiError.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 28.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

/**
 Custom Error type that handles API errors that occured but are not recognized as errors by URLSession
 */
public struct ApiError: LocalizedError, Codable {
    /// A localized message describing what API error occurred.
    public let errorDescription: String
    /**
     [OpenWeatherMap]:https://openweathermap.org/faq#error401 (full list)
     
     The error code returned by the API. See [OpenWeatherMap] for a list of possible API errors
     */
    public let apiErrorCode: Int
    
    enum CodingKeys: String, CodingKey {
        case errorDescription = "message"
        case apiErrorCode = "cod"
    }
}
