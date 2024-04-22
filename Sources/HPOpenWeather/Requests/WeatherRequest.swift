import CoreLocation
import Foundation
import HPNetwork
import HPURLBuilder

struct WeatherRequest: DecodableRequest {

    // MARK: - Associated Types

    typealias Output = Weather

    // MARK: - Properties

    let coordinate: CLLocationCoordinate2D
    let excludedFields: [ExcludableField]?
    let date: Date?
    let settings: OpenWeather.Settings
    let version: OpenWeather.APIVersion

    let requestMethod: HTTPRequest.Method = .get

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    // MARK: - DecodableRequest

    func makeURL() throws -> URL {
        if let date, Date.now.addingTimeInterval(.day * 4) < date {
            throw OpenWeatherError.invalidRequestTimestamp
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
            QueryItem(name: "units", value: settings.units.rawValue)
            QueryItem(name: "lang", value: settings.language.rawValue)
        }
    }

    func convertResponse(data: Data, response: HTTPResponse) throws -> Weather {
        switch response.status.kind {
        case .informational, .successful:
            var weather = try decoder.decode(Weather.self, from: data)
            weather.units = settings.units
            weather.language = settings.language
            return weather
        case .clientError, .invalid, .redirection, .serverError:
            var errorToThrow: any Error
            do {
                errorToThrow = try decoder.decode(OpenWeatherAPIError.self, from: data)
            } catch {
                errorToThrow = URLError(URLError.Code(rawValue: response.status.code))
            }
            throw errorToThrow
        }
    }

    func validateResponse(_ response: HTTPResponse) throws {
        // do nothing, validation will be handled by convertResponse instead
    }

}

extension TimeInterval {

    static let minute = 60.0
    static let hour = minute * 60
    static let day = hour * 24

}
