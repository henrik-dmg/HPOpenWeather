import Foundation

/// Codable type that holds weather forecast information in an hourly frequency
public struct HourlyForecast: Forecast {

    public let city: City
    public let numberOfDataPoints: Int
    /// The datapoints returned by the API
    public let dataPoints: [DataPoint]

    /// Codable type that represents a data points based on an hourly frequency
    public struct DataPoint: WeatherSnapshot {

        public let main: Main
        public var condition: WeatherCondition { _condition?.first ?? WeatherCondition.unknown }
        public let wind: Wind
        public var snow: Precipitation { _snow ?? Precipitation.none }
        public var rain: Precipitation { _rain ?? Precipitation.none }
        public var cloudCoverage: Int { _clouds?.all ?? 0 }
        /// The timestamp of the forecast measurement
        public let forecastTimeStamp: Date
        /// The time of data calculation on the server. Data is refreshed every 10 minutes
        public var timeOfCalculation: Date {
            DataPoint.dateFormatter.date(from: _timeOfCalculation ?? "1970-01-01 00:00:00") ?? Date.distantPast
        }

        /// Internal date formatter to convert date string returned by API into usable Date object
        static private var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter
        }

        internal var _snow: Precipitation?
        internal var _rain: Precipitation?
        /// Internal property to handle optional key "clouds" in JSON response
        internal var _clouds: Clouds?
        /// Internal property to handle string returned by API instead of seconds since epoch
        internal var _timeOfCalculation: String?
        /// Handles array in JSON response that should not be an array
        internal var _condition: [WeatherCondition]?

        enum CodingKeys: String, CodingKey {
            case forecastTimeStamp = "dt"
            case _timeOfCalculation = "dt_txt"
            case _snow = "snow"
            case _rain = "rain"
            case main
            case _condition = "weather"
            case wind
            case _clouds = "clouds"
        }
    }

    enum CodingKeys: String, CodingKey {
        case city
        case numberOfDataPoints = "cnt"
        case dataPoints = "list"
    }
}
