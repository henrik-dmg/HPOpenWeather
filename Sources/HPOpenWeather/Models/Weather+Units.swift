import Foundation

/// The units that should the data in the API responses should be formatted in.
public enum WeatherUnits: String, Codable {

    /// Temperature in Kelvin and wind speed in meter/sec.
    case standard
    /// Temperature in Celsius and wind speed in meter/sec.
    case metric
    /// Temperature in Fahrenheit and wind speed in miles/hour.
    case imperial

    var temperatureUnit: UnitTemperature {
        switch self {
        case .standard:
            return .kelvin
        case .metric:
            return .celsius
        case .imperial:
            return .fahrenheit
        }
    }

    var windSpeedUnit: UnitSpeed {
        switch self {
        case .standard:
            return .metersPerSecond
        case .metric:
            return .metersPerSecond
        case .imperial:
            return .milesPerHour
        }
    }

}
