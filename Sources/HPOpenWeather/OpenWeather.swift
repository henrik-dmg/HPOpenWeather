import CoreLocation
import Foundation

/// A type to request current weather conditions and forecasts.
public final class OpenWeather {

    // MARK: - Nested Types

    /// Type that can be used to configure all settings at once.
    public struct Settings {
        /// The API key to use for weather requests.
        let apiKey: String
        /// The language that will be used in weather responses.
        let language: Weather.Language
        /// The units that will be used in weather responses.
        let units: Weather.Units

        /// Initialises a new settings instance.
        /// - Parameters:
        ///   - apiKey: The API key to use for weather requests
        ///   - language: The language that will be used in weather responses
        ///   - units: The units that will be used in weather responses
        public init(apiKey: String, language: Weather.Language = .english, units: Weather.Units = .metric) {
            self.language = language
            self.units = units
            self.apiKey = apiKey
        }
    }

    // MARK: - Properties

    /// The OpenWeatherMap API key to authorize requests.
    public var apiKey: String?
    /// The language that should be used in API responses.
    public var language: Weather.Language = .english
    /// The units that should be used to format the API responses.
    public var units: Weather.Units = .metric

    // MARK: - Init

    /// Initialised a new instance of `OpenWeather` and applies the specified API key.
    /// - Parameter apiKey: the API key to authenticate with the OpenWeatherMap API
    public init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }

    /// Initialised a new instance of `OpenWeather` and applies the specified settings.
    /// - Parameter settings: the settings to apply, including API key, language and units
    public init(settings: Settings) {
        self.apiKey = settings.apiKey
        self.language = settings.language
        self.units = settings.units
    }

    // MARK: - Sending Requests

    /// Sends the specified request to the OpenWeather API.
    /// - Parameters:
    ///   - coordinate: The coordinate for which the weather will be requested
    ///   - excludedFields: An array specifying the fields that will be excluded from the response
    ///   - date: The date for which you want to request the weather. If no date is provided, the current weather will be retrieved
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: A weather response object
    /// - Throws: If no API key was provided, the request was misconfigured, the networking failed or the response failed to decode
    public func weather(
        for coordinate: CLLocationCoordinate2D,
        excludedFields: [ExcludableField]? = nil,
        date: Date? = nil,
        urlSession: URLSession = .shared
    ) async throws -> Weather {
        guard let apiKey, !apiKey.isEmpty else {
            throw OpenWeatherError.invalidAPIKey
        }

        let settings = Settings(apiKey: apiKey, language: language, units: units)
        let request = WeatherRequest(coordinate: coordinate, excludedFields: excludedFields, date: date, settings: settings, version: .new)

        return try await request.response(urlSession: urlSession).output
    }

    /// Sends the specified request to the OpenWeather API
    /// - Parameters:
    ///   - request: The request object that holds information about request location, date, etc.
    ///   - urlSession: The `URLSession` that will be used schedule requests
    ///   - completion: A completion that will be called with the result of the network request
    /// - Returns: A network task that can be used to cancel the request
    //    @discardableResult
    //    public func schedule(_ request: WeatherRequest, urlSession: URLSession = .shared, completion: @escaping (Result<WeatherRequest.Output, Error>) -> Void) -> Task<Void, Error> {
    //        Task {
    //            do {
    //                let response = try await weatherResponse(request, urlSession: urlSession)
    //                completion(.success(response))
    //            } catch {
    //                completion(.failure(error))
    //            }
    //        }
    //    }

    // MARK: - Applying Settings

    /// Applies new settings to the weather client.
    /// - Parameter settings: The weather client settings, including an API key, language and units
    public func apply(_ settings: Settings) {
        apiKey = settings.apiKey
        language = settings.language
        units = settings.units
    }

}
