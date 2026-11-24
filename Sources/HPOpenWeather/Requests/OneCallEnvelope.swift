import CoreLocation
import Foundation

/// The response body that the current and timeline endpoints of the One Call API 4.0 share.
struct OneCallEnvelope<Record: Decodable>: Decodable {

    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case timezoneIdentifier = "timezone"
        case records = "data"
        case previousPageURL = "prev"
        case nextPageURL = "next"
    }

    // MARK: - Properties

    let coordinate: CLLocationCoordinate2D
    let timezone: TimeZone
    let records: [Record]
    /// The URL of the previous page, if the API has earlier data.
    ///
    /// The type is `String` and not `URL`, because a URL that is not valid must not stop the decoding of the response.
    let previousPageURL: String?
    /// The URL of the next page, if the API has later data.
    let nextPageURL: String?

    // MARK: - Init/Deinit

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let timezoneIdentifier = try container.decode(String.self, forKey: .timezoneIdentifier)
        guard let timezone = TimeZone(identifier: timezoneIdentifier) else {
            throw OpenWeatherError.invalidTimeZoneIdentifier(timezoneIdentifier)
        }
        self.timezone = timezone

        self.records = try container.decode([Record].self, forKey: .records)
        self.previousPageURL = try container.decodeIfPresent(String.self, forKey: .previousPageURL)
        self.nextPageURL = try container.decodeIfPresent(String.self, forKey: .nextPageURL)
    }

}
