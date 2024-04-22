import Foundation

public enum OpenWeatherError: LocalizedError, Equatable {

    case invalidRequestTimestamp
    case invalidAPIKey
    case noCurrentConditionReturned
    case invalidTimeZoneIdentifier(_ identifier: String)

    public var errorDescription: String? {
        switch self {
        case .invalidRequestTimestamp:
            return "The request timestamp is invalid"
        case .invalidAPIKey:
            return "The API key is missing or empty"
        case .noCurrentConditionReturned:
            return "No current condition was returned"
        case .invalidTimeZoneIdentifier(let identifier):
            return "The timezone identifier '\(identifier)' is invalid"
        }
    }

}
