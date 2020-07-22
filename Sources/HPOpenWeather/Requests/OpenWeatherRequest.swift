import CoreLocation
import Foundation
import HPNetwork

public protocol OpenWeatherRequest {

    associatedtype Output: Decodable

    var coordinate: CLLocationCoordinate2D { get }
    var urlSession: URLSession { get }
    var finishingQueue: DispatchQueue { get }

    func makeURL(settings: HPOpenWeather.Settings) -> URL
    func makeNetworkRequest(settings: HPOpenWeather.Settings) throws -> DecodableRequest<Output>

}

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension OpenWeatherRequest {

    func makePublisher(apiKey: String, language: RequestLanguage = .english, units: RequestUnits = .metric) -> AnyPublisher<Output, Error> {
        let settings = HPOpenWeather.Settings(apiKey: apiKey, language: language, units: units)
        return makePublisher(settings: settings)
    }

    func makePublisher(settings: HPOpenWeather.Settings) -> AnyPublisher<Output, Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        return urlSession
            .dataTaskPublisher(for: makeURL(settings: settings))
            .receive(on: finishingQueue)
            .tryMap { data, response in
                if let error = NetworkingError.error(from: response) {
                    throw error
                }

                return data
            }
            .decode(type: Output.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

}

final class NetworkingError: NSError {

    static func error(from response: URLResponse?) -> Error? {
        guard let response = response as? HTTPURLResponse else {
            return nil
        }

        switch response.statusCode {
        case 200...299:
            return nil
        case 404:
            return NSError(code: 404, description: "URL not found")
        case 429:
            return NSError(code: 429, description: "Too many requests")
        case 401:
            return NSError(code: 401, description: "Unauthorized request")
        default:
            return NSError(code: response.statusCode, description: "Networking returned with HTTP code \(response.statusCode)")
        }
    }

}
#endif
