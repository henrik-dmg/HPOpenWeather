import Combine
import Foundation

public extension WeatherRequest {

    func publisher(
        apiKey: String,
        language: WeatherResponse.Language = .english,
        units: WeatherResponse.Units = .metric,
        urlSession: URLSession = .shared,
        finishingQueue: DispatchQueue = .main) -> AnyPublisher<Output, Error>
    {
        publisher(
            settings: OpenWeather.Settings(apiKey: apiKey, language: language, units: units),
            urlSession: urlSession,
            finishingQueue: finishingQueue
        )
    }

    func publisher(settings: OpenWeather.Settings, urlSession: URLSession = .shared, finishingQueue: DispatchQueue = .main) -> AnyPublisher<Output, Error> {
        let request = APINetworkRequest(url: makeURL(settings: settings), urlSession: urlSession)
        return request.dataTaskPublisher()
    }

}
