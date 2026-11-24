import Foundation

/// A forecast of the precipitation for one minute.
public struct MinutelyForecast: Codable, Equatable, Hashable {

    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case precipitation
        case alertIDs = "alerts"
    }

    // MARK: - Properties

    /// The time of the forecast.
    public let timestamp: Date
    /// Precipitation in mm/h.
    public let precipitation: Double
    /// The IDs of the weather alerts for the location at this time.
    ///
    /// Use ``OpenWeather/weatherAlert(withID:urlSession:)`` to get the details of an alert.
    public let alertIDs: [String]

    // MARK: - Init

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.precipitation = try container.decode(Double.self, forKey: .precipitation)
        self.alertIDs = try container.decodeIfPresent([String].self, forKey: .alertIDs) ?? []
    }

}
