import CoreLocation
import Foundation
import HPNetwork

public protocol OpenWeatherRequest {

    associatedtype Output: Decodable

    var coordinate: CLLocationCoordinate2D { get }

    func makeNetworkRequest(settings: HPOpenWeather.Settings) throws -> DecodableRequest<Output>

}
