import Foundation

/// Type that holds information about precipitation.
public struct Precipitation: Codable, Equatable, Hashable {

    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
    }

    // MARK: - Properties

    /// Precipitation in mm/h.
    public var lastHour: Double?

    /// A convertible measurement of the precipitation in the last hour, if available.
    public var lastHourMeasurement: Measurement<UnitLength>? {
        guard let lastHour else {
            return nil
        }
        return Measurement(value: lastHour, unit: .millimeters)
    }

}
