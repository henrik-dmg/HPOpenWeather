import Foundation

/// Type that holds information about sunrise and sunset times in UTC time.
public struct Sun: Codable, Equatable, Hashable {

    /// Sunset time, or `nil` during the polar day and the polar night.
    public let sunset: Date?
    /// Sunrise time, or `nil` during the polar day and the polar night.
    public let sunrise: Date?

}
