import Foundation

/// Type that holds information about sunrise and sunset times in UTC time.
public struct Sun: Codable, Equatable, Hashable {

    /// Sunset time.
    public let sunset: Date
    /// Sunrise time.
    public let sunrise: Date

}
