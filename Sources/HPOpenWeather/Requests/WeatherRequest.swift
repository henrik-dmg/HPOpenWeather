import Foundation
import CoreLocation
import HPNetwork

extension NSError {

    static let noApiKey = NSError(code: 2, description: "API key was not provided")
    static let timeMachineDate = NSError(code: 3, description: "TimeMachineRequest's date has to be at least 6 hours in the past")

}

public struct WeatherRequest: OpenWeatherRequest {

    public typealias Output = WeatherResponse

    public let coordinate: CLLocationCoordinate2D
    public let urlSession: URLSession
    public let finishingQueue: DispatchQueue

    public init(coordinate: CLLocationCoordinate2D, urlSession: URLSession = .shared, finishingQueue: DispatchQueue = .main) {
        self.coordinate = coordinate
        self.urlSession = urlSession
        self.finishingQueue = finishingQueue
    }

    public func makeURL(settings: HPOpenWeather.Settings) -> URL {
        URLQueryItemsBuilder(host: "api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent("onecall")
            .addingQueryItem(coordinate.latitude, digits: 5, name: "lat")
            .addingQueryItem(coordinate.longitude, digits: 5, name: "lon")
            .addingQueryItem(settings.apiKey, name: "appid")
            .addingQueryItem(settings.units.rawValue, name: "units")
            .addingQueryItem(settings.language.rawValue, name: "lang")
            .build()!
    }

    public func makeNetworkRequest(settings: HPOpenWeather.Settings) throws -> DecodableRequest<WeatherResponse> {
        WeatherNetworkRequest(url: makeURL(settings: settings), urlSession: urlSession, finishingQueue: finishingQueue)
    }
    
}

class WeatherNetworkRequest: DecodableRequest<WeatherResponse> {

    public typealias Output = WeatherResponse

    override var url: URL? {
        _url
    }

    public override var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    private let _url: URL

	override init(url: URL, urlSession: URLSession, finishingQueue: DispatchQueue) {
        self._url = url
        super.init(urlString: "www.google.com", urlSession: urlSession, finishingQueue: finishingQueue)
    }

}

extension Double {

    static let minute = 60.00
    static let hour = 3600.00
    static let day = 86400.00

}
