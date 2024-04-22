import Foundation

public struct Weather: Decodable, Equatable, Hashable {

    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case timezoneIdentifier = "timezone"
        case currentWeather = "current"
        case minutelyForecasts = "minutely"
        case hourlyForecasts = "hourly"
        case dailyForecasts = "daily"
        case alerts
    }

    // MARK: - Properties

    public let timezone: TimeZone
    public let currentWeather: CurrentWeather?
    public let minutelyForecasts: [MinutelyForecast]?
    public let hourlyForecasts: [HourlyForecast]?
    public let dailyForecasts: [DailyForecast]?
    /// Government weather alerts data from major national weather warning systems.
    public let alerts: [WeatherAlert]?

    public internal(set) var language: Weather.Language!
    public internal(set) var units: Weather.Units!

    // MARK: - Init

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let timezoneIdentifier = try container.decode(String.self, forKey: .timezoneIdentifier)
        guard let timezone = TimeZone(identifier: timezoneIdentifier) else {
            throw OpenWeatherError.invalidTimeZoneIdentifier(timezoneIdentifier)
        }
        self.timezone = timezone

        self.currentWeather = try container.decodeIfPresent(CurrentWeather.self, forKey: .currentWeather)
        self.minutelyForecasts = try container.decodeIfPresent([MinutelyForecast].self, forKey: .minutelyForecasts)
        self.hourlyForecasts = try container.decodeIfPresent([HourlyForecast].self, forKey: .hourlyForecasts)
        self.dailyForecasts = try container.decodeIfPresent([DailyForecast].self, forKey: .dailyForecasts)
        self.alerts = try container.decodeIfPresent([WeatherAlert].self, forKey: .alerts)
    }

}
