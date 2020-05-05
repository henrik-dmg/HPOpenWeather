import Foundation
import HPNetwork

public final class HPOpenWeather {

    public static let shared = HPOpenWeather()

    public var apiKey: String?

    public init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }

    @discardableResult
    public func requestWeather<R: OpenWeatherRequest>(
        _ request: R?,
        completion: @escaping (Result<R.Output, Error>) -> Void) -> NetworkTask
    {
        guard let request = request else {
            completion(.failure(NSError(description: "Request was nil", code: 4)))
            return NetworkTask()
        }

        guard request.hasAPIKey else {
            completion(.failure(NSError(description: "API key was not set", code: 3)))
            return NetworkTask()
        }

        return Network.shared.dataTask(request, completion: completion)
    }

}
