import Foundation
import CoreLocation
import HPNetwork

public struct TimeMachineRequest: OpenWeatherRequest {

	// MARK: - Associated Types

    public typealias Output = TimeMachineResponse

	// MARK: - Properties

    public let coordinate: CLLocationCoordinate2D
    public let date: Date
    public let urlSession: URLSession
    public let finishingQueue: DispatchQueue

	// MARK: - Init

    public init(coordinate: CLLocationCoordinate2D, date: Date, urlSession: URLSession = .shared, finishingQueue: DispatchQueue = .main) {
        self.coordinate = coordinate
        self.date = date
        self.urlSession = urlSession
        self.finishingQueue = finishingQueue
    }

	// MARK: - OpenWeatherRequest

    public func makeURL(settings: OpenWeather.Settings) -> URL {
        URLQueryItemsBuilder.weatherBase
            .addingPathComponent("timemachine")
            .addingQueryItem(coordinate.latitude, digits: 5, name: "lat")
            .addingQueryItem(coordinate.longitude, digits: 5, name: "lon")
            .addingQueryItem("\(Int(date.timeIntervalSince1970))", name: "dt")
            .addingQueryItem(settings.apiKey, name: "appid")
            .addingQueryItem(settings.units.rawValue, name: "units")
            .addingQueryItem(settings.language.rawValue, name: "lang")
            .build()!
    }

    public func makeNetworkRequest(settings: OpenWeather.Settings) throws -> APINetworkRequest<Output> {
        guard date.timeIntervalSinceNow < -6 * .hour else {
            throw NSError.timeMachineDate
        }
        return APINetworkRequest(url: makeURL(settings: settings), urlSession: urlSession, finishingQueue: finishingQueue)
    }

}
