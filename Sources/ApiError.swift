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
    public var errorDescription: String? { return _description ?? "Unknown Error" }
    /**
     [OpenWeatherMap]:https://openweathermap.org/faq#error401 (full list)
     
     The error code returned by the API. See [OpenWeatherMap] for a list of possible API errors
     */
    public var apiErrorCode: Int { return _errorCode ?? 0 }
    
    private var _description: String?
    private var _errorCode: Int?
    
    enum CodingKeys: String, CodingKey {
        case _description = "message"
        case _errorCode = "cod"
    }
}
