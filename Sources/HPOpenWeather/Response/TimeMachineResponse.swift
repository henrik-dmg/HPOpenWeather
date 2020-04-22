import Foundation

public struct TimeMachineResponse: Codable, Equatable, Hashable {

    public let timezone: TimeZone
    public let current: CurrentWeather
    public let hourlyForecasts: [HourlyForecast]

    enum CodingKeys: String, CodingKey {
        case timezone
        case current
        case hourly
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let timezoneString = try container.decode(String.self, forKey: .timezone)
        guard let timezone = TimeZone(identifier: timezoneString) else {
            throw NSError(description: "Invalid timezone identifier in weather response", code: 4)
        }

        self.timezone = timezone
        self.current = try container.decode(CurrentWeather.self, forKey: .current)
        self.hourlyForecasts = try container.decode([HourlyForecast].self, forKey: .hourly)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(timezone.identifier, forKey: .timezone)
        try container.encode(current, forKey: .current)
        try container.encode(hourlyForecasts, forKey: .hourly)
    }

}
