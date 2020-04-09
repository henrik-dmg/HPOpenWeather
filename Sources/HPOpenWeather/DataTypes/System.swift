import Foundation

/// Type that holds system information such as country code, sunrise and sunset times
public struct System: Codable, Equatable, Hashable {

    /**
     [Wikipedia]: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes "See full list"

     An ISO 3166 country code specifying the country of the request's location. For a full list of codes see [Wikipedia]
     */
    public let countryCode: String
    /// The sunrise time of the request's location in UTC time
    public let sunrise: Date
    /// The sunset time of the request's location in UTC time
    public let sunset: Date

    enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case sunrise
        case sunset
    }

}
