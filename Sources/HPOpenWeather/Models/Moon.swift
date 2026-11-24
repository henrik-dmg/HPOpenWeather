import Foundation

/// Type that holds information about moonset and moonrise times in UTC time, and about the moon phase.
public struct Moon: Codable, Equatable, Hashable {

    /// Moonset time, or `nil` if the moon does not set on this day.
    public let moonset: Date?
    /// Moonrise time, or `nil` if the moon does not rise on this day.
    public let moonrise: Date?
    /// Moon phase, from 0 to 1.
    ///
    /// The values 0 and 1 are the new moon, 0.25 is the first quarter, 0.5 is the full moon and 0.75 is the last quarter.
    public let phase: Double?

}
