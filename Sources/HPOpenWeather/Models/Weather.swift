import Foundation

/// The current weather, the forecasts and the weather alerts for a location.
///
/// ``OpenWeather/weather(for:excludedFields:urlSession:)`` combines the responses of
/// the One Call 4.0 endpoints into one instance of this type.
public struct Weather: Codable, Equatable, Hashable {

    // MARK: - Nested Types

    // The One Call API 4.0 does not send this type in one response. These coding keys let you cache an instance.
    enum CodingKeys: String, CodingKey {
        case timezoneIdentifier = "timezone"
        case currentWeather = "current"
        case minutelyForecasts = "minutely"
        case quarterHourlyForecasts = "quarter_hourly"
        case hourlyForecasts = "hourly"
        case dailyForecasts = "daily"
        case alerts
        case language
        case units
    }

    // MARK: - Properties

    public let timezone: TimeZone
    public let currentWeather: CurrentWeather?
    public let minutelyForecasts: [MinutelyForecast]?
    public let quarterHourlyForecasts: [QuarterHourlyForecast]?
    public let hourlyForecasts: [HourlyForecast]?
    public let dailyForecasts: [DailyForecast]?
    /// Government weather alerts data from major national weather warning systems.
    public let alerts: [WeatherAlert]?

    public let language: WeatherLanguage?
    public let units: WeatherUnits?

    // MARK: - Init

    init(
        timezone: TimeZone,
        currentWeather: CurrentWeather?,
        minutelyForecasts: [MinutelyForecast]?,
        quarterHourlyForecasts: [QuarterHourlyForecast]?,
        hourlyForecasts: [HourlyForecast]?,
        dailyForecasts: [DailyForecast]?,
        alerts: [WeatherAlert]?,
        language: WeatherLanguage?,
        units: WeatherUnits?
    ) {
        self.timezone = timezone
        self.currentWeather = currentWeather
        self.minutelyForecasts = minutelyForecasts
        self.quarterHourlyForecasts = quarterHourlyForecasts
        self.hourlyForecasts = hourlyForecasts
        self.dailyForecasts = dailyForecasts
        self.alerts = alerts
        self.language = language
        self.units = units
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let timezoneIdentifier = try container.decode(String.self, forKey: .timezoneIdentifier)
        guard let timezone = TimeZone(identifier: timezoneIdentifier) else {
            throw OpenWeatherError.invalidTimeZoneIdentifier(timezoneIdentifier)
        }
        self.timezone = timezone

        self.currentWeather = try container.decodeIfPresent(CurrentWeather.self, forKey: .currentWeather)
        self.minutelyForecasts = try container.decodeIfPresent([MinutelyForecast].self, forKey: .minutelyForecasts)
        self.quarterHourlyForecasts = try container.decodeIfPresent([QuarterHourlyForecast].self, forKey: .quarterHourlyForecasts)
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
        try container.encodeIfPresent(quarterHourlyForecasts, forKey: .quarterHourlyForecasts)
        try container.encodeIfPresent(hourlyForecasts, forKey: .hourlyForecasts)
        try container.encodeIfPresent(dailyForecasts, forKey: .dailyForecasts)
        try container.encodeIfPresent(alerts, forKey: .alerts)

        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(units, forKey: .units)
    }

}
