import Foundation

public extension Weather {

    /// The units that should the data in the API responses should be formatted in
    enum Units: String, Codable {

        /// Temperature in Kelvin and wind speed in meter/sec
        case standard
        /// Temperature in Celsius and wind speed in meter/sec
        case metric
        /// Temperature in Fahrenheit and wind speed in miles/hour
        case imperial

        @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
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

        @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
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

}
