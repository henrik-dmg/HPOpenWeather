import Foundation

/// Type that holds information about recent precipitation
public struct Precipitation: Codable, Equatable, Hashable {

	enum CodingKeys: String, CodingKey {
		case lastHour = "1h"
		case lastThreeHours = "3h"
	}

    /// Precipitation volume for the last 1 hour, measured in mm
    public var lastHour: Double?
    /// Precipitation volume for the last 3 hours, measured in mm
    public var lastThreeHours: Double?

	public var lastHourMeasurement: Measurement<UnitLength>? {
		guard let lastHour = lastHour else {
			return nil
		}
		return Measurement(value: lastHour, unit: .millimeters)
	}

	public var lastThreeHoursMeasurement: Measurement<UnitLength>? {
		guard let lastThreeHours = lastThreeHours else {
			return nil
		}
		return Measurement(value: lastThreeHours, unit: .millimeters)
	}

}
