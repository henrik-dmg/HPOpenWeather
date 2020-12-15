import Foundation

/// Type that holds information about daily temperature changes
public struct DailyTemperature: Codable, Equatable, Hashable {

	/// Day temperature.
    public let day: Double
	/// Night temperature.
    public let night: Double
	/// Minimum daily temperature.
    public let min: Double?
	/// Max daily temperature.
    public let max: Double?
	/// Evening temperature.
    public let evening: Double
	/// Morning temperature.
    public let morning: Double

    enum CodingKeys: String, CodingKey {
        case day
        case night
        case min
        case max
        case evening = "eve"
        case morning = "morn"
    }

}
