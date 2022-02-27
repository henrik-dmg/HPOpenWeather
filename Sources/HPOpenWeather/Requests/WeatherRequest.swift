import Foundation
import CoreLocation
import HPNetwork
import HPURLBuilder

public struct WeatherRequest: Codable {

    // MARK: - Associated Types

    public typealias Output = WeatherResponse

    // MARK: - Properties

    public let coordinate: CLLocationCoordinate2D
    public let excludedFields: [ExcludableField]?
    public let date: Date?

    // MARK: - Init

    public init(coordinate: CLLocationCoordinate2D, excludedFields: [ExcludableField]? = nil, date: Date? = nil) {
        self.coordinate = coordinate
        self.excludedFields = excludedFields?.hp_nilIfEmpty()
        self.date = date
    }

    // MARK: - OpenWeatherRequest

    func makeURL(settings: OpenWeather.Settings) -> URL? {
        URL.build {
            Host("api.openweathermap.org")
            PathComponent("data")
            PathComponent("2.5")
            PathComponent("onecall")
            PathComponent(date != nil ? "timemachine" : nil)
            QueryItem(name: "lat", value: coordinate.latitude, digits: 5)
            QueryItem(name: "lon", value: coordinate.longitude, digits: 5)
            QueryItem(name: "dt", value: date.flatMap({ Int($0.timeIntervalSince1970) }))
            QueryItem(name: "exclude", value: excludedFields?.compactMap({ $0.rawValue }))
            QueryItem(name: "appid", value: settings.apiKey)
            QueryItem(name: "units", value: settings.units.rawValue)
            QueryItem(name: "lang", value: settings.language.rawValue)
        }
    }

    func makeNetworkRequest(settings: OpenWeather.Settings, urlSession: URLSession) throws -> APINetworkRequest {
        if let date = date, date < Date(), abs(date.timeIntervalSinceNow) <= 6 * .hour {
            throw NSError.timeMachineDate
        }
        return APINetworkRequest(url: makeURL(settings: settings), urlSession: urlSession)
    }

}

extension Collection {

    func hp_nilIfEmpty() -> Self? {
        isEmpty ? nil : self
    }

}

extension TimeInterval {

    static let minute = 60.00
    static let hour = 3600.00
    static let day = 86400.00

}
