import Foundation

public struct MinutelyForecast: Codable, Equatable, Hashable {

    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case precipitation
    }

    // MARK: - Properties

    public let timestamp: Date
    public let precipitation: Double

}
