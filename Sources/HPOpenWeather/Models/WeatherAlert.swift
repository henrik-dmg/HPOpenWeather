import Foundation

/// Type that holds information about a weather alert.
public struct WeatherAlert: Codable, Hashable, Equatable, Sendable {

    // MARK: - Nested Types

    /// The description of an alert in one language.
    public struct LocalizedDescription: Codable, Hashable, Equatable, Sendable {

        // MARK: - Nested Types

        enum CodingKeys: String, CodingKey {
            case languageCode = "language"
            case text = "description"
        }

        // MARK: - Properties

        /// The language code of the description, for example `en-GB`.
        public let languageCode: String
        /// The text of the description.
        public let text: String

    }

    enum CodingKeys: String, CodingKey {
        case id
        case senderName = "sender_name"
        case eventName = "event"
        case startDate = "start"
        case endDate = "end"
        case descriptions = "description"
        case tags
    }

    // MARK: - Properties

    /// The ID of the alert.
    public let id: String
    /// Name of the alert source.
    ///
    /// A full list of possible sources can be found [here](https://openweathermap.org/api/one-call-4).
    public let senderName: String
    /// Alert event name.
    public let eventName: String
    /// Date and time of the start of the alert.
    public let startDate: Date
    /// Date and time of the end of the alert.
    public let endDate: Date
    /// The descriptions of the alert, one for each language that the alert source supplies.
    public let descriptions: [LocalizedDescription]
    /// The types of severe weather, for example `Thunderstorm`.
    public let tags: [String]

}
