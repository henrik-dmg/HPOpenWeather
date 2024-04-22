import CoreLocation
import Foundation

extension CLLocationCoordinate2D: Codable {

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        let latitude = try container.decode(Double.self, forKey: .latitude)

        self.init(latitude: latitude, longitude: longitude)
    }

}

extension CLLocationCoordinate2D: Equatable {

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

}

extension CLLocationCoordinate2D: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

}
