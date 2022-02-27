import Foundation

public struct WeatherResponse: Codable, Equatable, Hashable {

    private let timezoneIdentifier: String
    public let currentWeather: CurrentWeather?
	public let hourlyForecasts: [HourlyForecast]?
	public let dailyForecasts: [DailyForecast]?
	/// Government weather alerts data from major national weather warning systems
	public let alerts: [WeatherAlert]?

    public internal(set) var language: WeatherResponse.Language?
    public internal(set) var units: WeatherResponse.Units?

	public var timezone: TimeZone? {
		TimeZone(identifier: timezoneIdentifier)
	}

    enum CodingKeys: String, CodingKey {
        case timezoneIdentifier = "timezone"
        case currentWeather = "current"
        case hourlyForecasts = "hourly"
        case dailyForecasts = "daily"
		case alerts
    }

}

public struct WeatherResponseContainer: Codable, Equatable, Hashable {

	public let response: WeatherResponse
	public let language: WeatherResponse.Language
	public let units: WeatherResponse.Units

}
