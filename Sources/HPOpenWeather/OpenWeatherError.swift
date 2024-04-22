import Foundation

public enum OpenWeatherError: Error, Equatable {
    case invalidRequestTimestamp
    case invalidAPIKey
    case noCurrentConditionReturned
    case invalidTimeZoneIdentifier(_ identifier: String)
}
