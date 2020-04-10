import Foundation
import HPNetwork

public final class HPOpenWeather {

    public static let shared = HPOpenWeather()

    public var apiKey: String?

    @discardableResult
    public func requestWeather<R: WeatherRequest>(
        _ request: R,
        completion: @escaping (Result<R.Output, Error>) -> Void) -> NetworkTask
    {
        guard request.hasAPIKey else {
            completion(.failure(NSError(description: "API key was not set", code: 3)))
            return NetworkTask()
        }

        return Network.shared.dataTask(request, completion: completion)
    }

}
