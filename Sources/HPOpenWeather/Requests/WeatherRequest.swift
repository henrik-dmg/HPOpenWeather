import CoreLocation
import Foundation
import HPNetwork
import HPURLBuilder

struct WeatherRequest: DecodableRequest {

    // MARK: - Associated Types

    typealias Output = Weather

    enum Version: String {
        case old = "2.5"
        case new = "3.0"
    }

    // MARK: - Properties

    let coordinate: CLLocationCoordinate2D
    let excludedFields: [ExcludableField]?
    let date: Date?
    let settings: OpenWeather.Settings
    let version: Version

    let requestMethod: HTTPRequest.Method = .get

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    // MARK: - OpenWeatherRequest

    func makeURL() throws -> URL {
        if let date = date, date < Date(), abs(date.timeIntervalSinceNow) <= 6 * .hour {
            throw OpenWeatherError.invalidTimeMachineDate
        }
        return try URL.buildThrowing {
            Host("api.openweathermap.org")
            PathComponent("data")
            PathComponent(version.rawValue)
            PathComponent("onecall")
            PathComponent(date != nil ? "timemachine" : nil)
            QueryItem(name: "lat", value: coordinate.latitude, digits: 5)
            QueryItem(name: "lon", value: coordinate.longitude, digits: 5)
            QueryItem(name: "appid", value: settings.apiKey)
            QueryItem(name: "dt", value: date.flatMap({ Int($0.timeIntervalSince1970) }))
            QueryItem(name: "exclude", value: excludedFields?.compactMap({ $0.rawValue }))
            QueryItem(name: "units", value: "metric")
            QueryItem(name: "lang", value: settings.language.rawValue)
        }
    }

    func convertResponse(data: Data, response: HTTPResponse) throws -> Weather {
        var weather = try decoder.decode(Weather.self, from: data)
        weather.units = settings.units
        weather.language = settings.language
        return weather
    }

}

extension TimeInterval {

    static let hour = 3600.00

}
