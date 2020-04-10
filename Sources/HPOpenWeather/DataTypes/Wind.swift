import Foundation

/// Type that holds information about wind speed and direction measured in degrees
public struct Wind: Codable, Equatable, Hashable {

    /// The current wind speed depending on the request's unit (metric: meter/second, imperial: miles/hour)
    public let speed: Double?
    /// Wind gust speed (metric: meter/sec, imperial: miles/hour)
    public let gust: Double?
    /// The wind direction measured in degrees from North
    public let degrees: Double?

}
