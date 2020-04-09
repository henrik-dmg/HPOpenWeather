import Foundation

public protocol Forecast: Codable {

    /// The nearest city, returned by the API
    var city: City { get }
    /// The number of measurements returned by the API
    var numberOfDataPoints: Int { get }

}
