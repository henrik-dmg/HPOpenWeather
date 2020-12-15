import Foundation

public struct WeatherResponse: Codable, Equatable, Hashable {

    private let timezoneIdentifier: String
    public let current: CurrentWeather
	@DecodableDefault.EmptyList public var hourlyForecasts: [HourlyForecast]
	@DecodableDefault.EmptyList public var dailyForecasts: [DailyForecast]
	/// Government weather alerts data from major national weather warning systems
	@DecodableDefault.EmptyList public var alerts: [Alert]

	public var timezone: TimeZone {
		TimeZone(identifier: timezoneIdentifier)!
	}

    enum CodingKeys: String, CodingKey {
        case timezoneIdentifier = "timezone"
        case current
        case hourlyForecasts = "hourly"
        case dailyForecasts = "daily"
		case alerts
    }

}
