import Foundation

/// Type that holds information about sunrise and sunset times in UTC time
public struct Sun: Codable, Equatable, Hashable {

    /// Sunset time
    public let sunset: Date
    /// Sunrise timeWind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
    public let sunrise: Date

}
