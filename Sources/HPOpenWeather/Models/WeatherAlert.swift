import Foundation

/// Type that holds information about weather alerts.
public struct WeatherAlert: Codable, Hashable, Equatable {

    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case eventName = "event"
        case startDate = "start"
        case endDate = "end"
        case description
    }

    // MARK: - Properties

    /// Name of the alert source. Please read here the full list of alert sources.
    public let senderName: String
    /// Alert event name.
    public let eventName: String
    //// Date and time of the start of the alert.
    public let startDate: Date
    //// Date and time of the end of the alert.
    public let endDate: Date
    /// Description of the alert.
    public let description: String

}
