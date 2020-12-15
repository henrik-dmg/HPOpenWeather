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

	/// <#Description#>
	/// - Parameters:
	///   - request: <#request description#>
	///   - completion: <#completion description#>
	/// - Returns: A network task that can be used to cancel the request
	@discardableResult
    public func sendWeatherRequest<R: OpenWeatherRequest>(_ request: R, completion: @escaping (Result<R.Output, Error>) -> Void) -> NetworkTask {
        guard let apiKey = apiKey else {
			request.finishingQueue.async {
                completion(.failure(NSError.noApiKey))
            }
            return NetworkTask()
        }

        let settings = Settings(apiKey: apiKey, language: language, units: units)

        do {
            let networkRequest = try request.makeNetworkRequest(settings: settings)
            return Network.shared.dataTask(networkRequest, completion: completion)
        } catch let error {
			request.finishingQueue.async {
                completion(.failure(error))
            }
            return NetworkTask()
        }
    }

}
