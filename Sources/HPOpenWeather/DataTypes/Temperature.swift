import Foundation

/// Type that holds information about daily temperature changes
public struct Temperature: Codable, Equatable, Hashable {

	/// The actually measured temperature
    public let actual: Double
	/// The feels-like temperature
    public let feelsLike: Double

}
