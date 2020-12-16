import Foundation

public struct WeatherResponse: Codable, Equatable, Hashable {

    private let timezoneIdentifier: String
    public let currentWeather: CurrentWeather?
	public let hourlyForecasts: [HourlyForecast]?
	public let dailyForecasts: [DailyForecast]?
	/// Government weather alerts data from major national weather warning systems
	public let alerts: [Alert]?

	public var timezone: TimeZone {
		TimeZone(identifier: timezoneIdentifier)!
	}

    enum CodingKeys: String, CodingKey {
        case timezoneIdentifier = "timezone"
        case currentWeather = "current"
        case hourlyForecasts = "hourly"
        case dailyForecasts = "daily"
		case alerts
    }

}
