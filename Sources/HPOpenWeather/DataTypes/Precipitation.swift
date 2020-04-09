import Foundation

/// Type that holds information about recent precipitation
public struct Precipitation: Codable, Equatable, Hashable {

    /// Precipitation volume for the last 1 hour, measured in mm
    public var lastHour: Double?
    /// Precipitation volume for the last 3 hours, measured in mm
    public var lastThreeHours: Double?

    /// Singleton property to indicate there was no precipitation within the last 3 hours
    static let none = Precipitation(lastHour: nil, lastThreeHours: nil)

    enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
        case lastThreeHours = "3h"
    }

}
