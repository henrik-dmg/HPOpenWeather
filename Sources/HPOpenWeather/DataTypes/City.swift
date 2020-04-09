import Foundation
import CoreLocation

/// Type that holds information about the reqeuest's nearest city
public struct City: Codable, Equatable, Hashable {

    /// The ID assigned to the city
    public let id: Int
    /// The name of the city
    public let name: String
    /// The location of the city
    public let location: CLLocationCoordinate2D
    /// The country code of the city
    public let countryCode: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location = "coord"
        case countryCode = "country"
    }

}
