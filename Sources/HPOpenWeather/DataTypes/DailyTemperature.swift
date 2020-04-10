import Foundation

public struct DailyTemperature: Codable {

    public let day: Double
    public let night: Double
    public let min: Double?
    public let max: Double?
    public let evening: Double
    public let morning: Double

    enum CodingKeys: String, CodingKey {
        case day
        case night
        case min
        case max
        case evening = "eve"
        case morning = "morn"
    }

}
