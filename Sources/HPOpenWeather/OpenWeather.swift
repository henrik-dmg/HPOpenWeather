import CoreLocation
import Foundation
import HPNetwork

public final class OpenWeather {

    // MARK: - Nested Types

    /// Type that can be used to configure all settings at once
    public struct Settings {
        let apiKey : String
        let language: RequestLanguage
        let units: RequestUnits

        public init(apiKey: String, language: RequestLanguage = .english, units: RequestUnits = .metric) {
            self.language = language
            self.units = units
            self.apiKey = apiKey
        }
    }

    // MARK: - Properties

	/// A shared instance of the weather client
    public static let shared = OpenWeather()

    /// The OpenWeatherMap API key to authorize requests
    public var apiKey : String?
    /// The language that should be used in API responses
    public var language: RequestLanguage = .english
    /// The units that should be used to format the API responses
    public var units: RequestUnits = .metric

    // MARK: - Init

    public init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }

    public init(settings: Settings) {
        self.apiKey = settings.apiKey
        self.language = settings.language
        self.units = settings.units
    }

    // MARK: - Sending Requests

	public func requestWeather(
		coordinate: CLLocationCoordinate2D,
		excludedFields: [ExcludableField]? = nil,
		date: Date? = nil,
		urlSession: URLSession = .shared,
		finishingQueue: DispatchQueue = .main,
		progressHandler: ProgressHandler? = nil,
		completion: @escaping (Result<WeatherResponse, Error>) -> Void)
	{
		let request = WeatherRequest(
			coordinate: coordinate,
			excludedFields: excludedFields,
			date: date,
			urlSession: urlSession,
			finishingQueue: finishingQueue
		)
		schedule(request, progressHandler: progressHandler, completion: completion)
	}

	/// Sends the specified request to the OpenWeather API
	/// - Parameters:
	///   - request: The request object that holds information about request location, date, etc.
	///   - completion: The completion block that will be called once the networking finishes
	/// - Returns: A network task that can be used to cancel the request
	public func schedule(
		_ request: WeatherRequest,
		progressHandler: ProgressHandler? = nil,
		completion: @escaping (Result<WeatherRequest.Output, Error>) -> Void)
	{
        guard let apiKey = apiKey else {
			request.finishingQueue.async {
                completion(.failure(NSError.noApiKey))
            }
			return
        }

        let settings = Settings(apiKey: apiKey, language: language, units: units)

        do {
            let networkRequest = try request.makeNetworkRequest(settings: settings)
			Network.shared.schedule(request: networkRequest, progressHandler: progressHandler, completion: completion)
        } catch let error {
			request.finishingQueue.async {
                completion(.failure(error))
            }
        }
    }

	// MARK: - Applying Settings

	/// Applies new settings to the weather client
	/// - Parameter settings: The weather client settings, including an API key, language and units
	public func apply(_ settings: Settings) {
		apiKey = settings.apiKey
		language = settings.language
		units = settings.units
	}

}
