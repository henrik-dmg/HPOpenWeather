import Foundation
import CoreLocation
import HPNetwork

public struct TimeMachineRequest: OpenWeatherRequest {

    public typealias Output = TimeMachineResponse

    public let coordinate: CLLocationCoordinate2D
    public let date: Date
    public let urlSession: URLSession
    public let finishingQueue: DispatchQueue

    public init(coordinate: CLLocationCoordinate2D, date: Date, urlSession: URLSession = .shared, finishingQueue: DispatchQueue = .main) {
        self.coordinate = coordinate
        self.date = date
        self.urlSession = urlSession
        self.finishingQueue = finishingQueue
    }

    public func makeURL(settings: HPOpenWeather.Settings) -> URL {
        URLQueryItemsBuilder.weatherBase
            .addingPathComponent("timemachine")
            .addingQueryItem(coordinate.latitude, digits: 5, name: "lat")
            .addingQueryItem(coordinate.longitude, digits: 5, name: "lon")
            .addingQueryItem("\(Int(date.timeIntervalSince1970))", name: "dt")
            .addingQueryItem(settings.apiKey, name: "appid")
            .addingQueryItem(settings.units.rawValue, name: "units")
            .addingQueryItem(settings.language.rawValue, name: "lang")
            .build()!
    }

    public func makeNetworkRequest(settings: HPOpenWeather.Settings) throws -> DecodableRequest<TimeMachineResponse> {
        guard date.timeIntervalSinceNow < -6 * .hour else {
            throw NSError.timeMachineDate
        }
        return TimeMachineNetworkRequest(url: makeURL(settings: settings), urlSession: urlSession, finishingQueue: finishingQueue)
    }

}

class TimeMachineNetworkRequest: DecodableRequest<TimeMachineResponse> {

    public typealias Output = TimeMachineResponse

    public override var url: URL? {
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
