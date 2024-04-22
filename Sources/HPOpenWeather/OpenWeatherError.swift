import Foundation

public enum OpenWeatherError: Error {
    case invalidTimeMachineDate
    case invalidAPIKey
    case noCurrentConditionReturned
    case invalidTimeZoneIdentifier(_ identifier: String)
}
