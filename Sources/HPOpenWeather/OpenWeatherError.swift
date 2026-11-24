import Foundation

public enum OpenWeatherError: LocalizedError, Equatable {

    case invalidAPIKey
    case noCurrentConditionReturned
    case noCurrentWeatherReturned
    case allForecastsExcluded
    case invalidTimeZoneIdentifier(_ identifier: String)

    public var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "The API key is missing or empty"
        case .noCurrentConditionReturned:
            return "No current condition was returned"
        case .noCurrentWeatherReturned:
            return "No current weather was returned"
        case .allForecastsExcluded:
            return "All forecast fields are excluded, so there is no data to request"
        case .invalidTimeZoneIdentifier(let identifier):
            return "The timezone identifier '\(identifier)' is invalid"
        }
    }

}
