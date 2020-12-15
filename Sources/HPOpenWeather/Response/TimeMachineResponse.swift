import Foundation

public struct TimeMachineResponse: Codable, Equatable, Hashable {

	private let timezoneIdentifier: String
    public let current: CurrentWeather
	@DecodableDefault.EmptyList public var hourlyForecasts: [HourlyForecast]

	public var timezone: TimeZone {
		TimeZone(identifier: timezoneIdentifier)!
	}

	enum CodingKeys: String, CodingKey {
		case timezoneIdentifier = "timezone"
		case current
		case hourlyForecasts = "hourly"
	}

}
