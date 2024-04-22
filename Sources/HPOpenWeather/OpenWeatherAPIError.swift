import Foundation

/// An error that is thrown when the API returns an error.
public struct OpenWeatherAPIError: Error, Decodable {

    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message
        case parameters
    }

    // MARK: - Properties

    /// The error code, such as 400, 404 or 5xx.
    let code: Int
    /// The error message or description.
    let message: String
    /// List of request parameters names that are related to this particular error.
    let parameters: [String]?

}
