import Foundation

/// Type that holds information about recent precipitation.
public struct Precipitation: Codable, Equatable, Hashable {

    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
        case lastThreeHours = "3h"
    }

    // MARK: - Properties

    /// Precipitation volume for the last 1 hour, measured in mm.
    public var lastHour: Double?
    /// Precipitation volume for the last 3 hours, measured in mm.
    public var lastThreeHours: Double?

    /// A convertible measurement of how much precipitation occured in the last hour if any.
    public var lastHourMeasurement: Measurement<UnitLength>? {
        guard let lastHour else {
            return nil
        }
        return Measurement(value: lastHour, unit: .millimeters)
    }

    /// A convertible measurement of how much precipitation occured in the last three hours if any.
    public var lastThreeHoursMeasurement: Measurement<UnitLength>? {
        guard let lastThreeHours else {
            return nil
        }
        return Measurement(value: lastThreeHours, unit: .millimeters)
    }

}
