import Foundation

/// Type that holds information about moonset and moonrise times in UTC time.
public struct Moon: Codable, Equatable, Hashable {

    /// Moonset time.
    public let moonset: Date
    /// Moonrise time.
    public let moonrise: Date

}
