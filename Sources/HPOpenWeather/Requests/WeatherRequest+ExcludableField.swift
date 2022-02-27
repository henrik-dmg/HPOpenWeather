import Foundation

public extension WeatherRequest {

    enum ExcludableField: String, Codable {
        case current
        case minutely
        case hourly
        case daily
        case alerts
    }

}
