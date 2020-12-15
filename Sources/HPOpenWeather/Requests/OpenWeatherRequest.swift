import CoreLocation
import Foundation
import HPNetwork

public protocol OpenWeatherRequest {

    associatedtype Output: Decodable
	associatedtype Request: NetworkRequest where Request.Output == Output

    var coordinate: CLLocationCoordinate2D { get }
    var urlSession: URLSession { get }
    var finishingQueue: DispatchQueue { get }

    func makeURL(settings: OpenWeather.Settings) -> URL
	func makeNetworkRequest(settings: OpenWeather.Settings) throws -> Request

}
