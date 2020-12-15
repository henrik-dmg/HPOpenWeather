import Foundation
import CoreLocation
import HPNetwork

public struct WeatherRequest: OpenWeatherRequest {

	// MARK: - Associated Types

    public typealias Output = WeatherResponse

	// MARK: - Properties

    public let coordinate: CLLocationCoordinate2D
    public let urlSession: URLSession
    public let finishingQueue: DispatchQueue

	// MARK: - Init

    public init(coordinate: CLLocationCoordinate2D, urlSession: URLSession = .shared, finishingQueue: DispatchQueue = .main) {
        self.coordinate = coordinate
        self.urlSession = urlSession
        self.finishingQueue = finishingQueue
    }

	// MARK: - OpenWeatherRequest

    public func makeURL(settings: OpenWeather.Settings) -> URL {
        URLQueryItemsBuilder(host: "api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent("onecall")
            .addingQueryItem(coordinate.latitude, digits: 5, name: "lat")
            .addingQueryItem(coordinate.longitude, digits: 5, name: "lon")
            .addingQueryItem(settings.apiKey, name: "appid")
            .addingQueryItem(settings.units.rawValue, name: "units")
            .addingQueryItem(settings.language.rawValue, name: "lang")
            .build()!
    }

    public func makeNetworkRequest(settings: OpenWeather.Settings) throws -> APINetworkRequest<Output> {
        APINetworkRequest(url: makeURL(settings: settings), urlSession: urlSession, finishingQueue: finishingQueue)
    }
    
}

extension TimeInterval {

    static let minute = 60.00
    static let hour = 3600.00
    static let day = 86400.00

}
