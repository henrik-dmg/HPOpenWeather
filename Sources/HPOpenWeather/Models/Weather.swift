import Foundation

public struct Weather: Codable, Equatable, Hashable {

    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case timezoneIdentifier = "timezone"
        case currentWeather = "current"
        case minutelyForecasts = "minutely"
        case hourlyForecasts = "hourly"
        case dailyForecasts = "daily"
        case alerts

        // These keys are not actually present in the response from the OpenWeather API.
        // We inject them manually after decoding the response in order to persist these settings
        // if you want to cache the response for example.
        case language
        case units
    }

    // MARK: - Properties

    public let timezone: TimeZone
    public let currentWeather: CurrentWeather?
    public let minutelyForecasts: [MinutelyForecast]?
    public let hourlyForecasts: [HourlyForecast]?
    public let dailyForecasts: [DailyForecast]?
    /// Government weather alerts data from major national weather warning systems.
    public let alerts: [WeatherAlert]?

    public internal(set) var language: WeatherLanguage?
    public internal(set) var units: WeatherUnits?

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

        self.language = try container.decodeIfPresent(WeatherLanguage.self, forKey: .language)
        self.units = try container.decodeIfPresent(WeatherUnits.self, forKey: .units)
    }

    // MARK: - Encoding

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(timezone.identifier, forKey: .timezoneIdentifier)
        try container.encodeIfPresent(currentWeather, forKey: .currentWeather)
        try container.encodeIfPresent(minutelyForecasts, forKey: .minutelyForecasts)
        try container.encodeIfPresent(hourlyForecasts, forKey: .hourlyForecasts)
        try container.encodeIfPresent(dailyForecasts, forKey: .dailyForecasts)
        try container.encodeIfPresent(alerts, forKey: .alerts)

        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(units, forKey: .units)
    }

}
