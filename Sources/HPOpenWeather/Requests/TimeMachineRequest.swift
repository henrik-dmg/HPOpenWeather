import Foundation
import CoreLocation
import HPNetwork

public struct TimeMachineRequest: OpenWeatherRequest {

    public typealias Output = TimeMachineResponse

    public let coordinate: CLLocationCoordinate2D
    public let date: Date
    private let finishingQueue: DispatchQueue

    public init(coordinate: CLLocationCoordinate2D, date: Date, finishingQueue: DispatchQueue = .main) {
        self.coordinate = coordinate
        self.date = date
        self.finishingQueue = finishingQueue
    }

    public func makeNetworkRequest(settings: HPOpenWeather.Settings) throws -> DecodableRequest<TimeMachineResponse> {
        guard date.timeIntervalSinceNow < -6 * .hour else {
            throw NSError.timeMachineDate
        }
        return TimeMachineNetworkRequest(request: self, settings: settings, finishingQueue: finishingQueue)
    }

}

class TimeMachineNetworkRequest: DecodableRequest<TimeMachineResponse> {

    public typealias Output = TimeMachineResponse

    public override var url: URL? {
        URLQueryItemsBuilder.weatherBase
            .addingPathComponent("timemachine")
            .addingQueryItem(coordinate.latitude, digits: 5, name: "lat")
            .addingQueryItem(coordinate.longitude, digits: 5, name: "lon")
            .addingQueryItem("\(Int(date.timeIntervalSince1970))", name: "dt")
            .addingQueryItem(settings.apiKey, name: "appid")
            .addingQueryItem(settings.units.rawValue, name: "units")
            .addingQueryItem(settings.language.rawValue, name: "lang")
            .build()
    }

    public override var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    private let coordinate: CLLocationCoordinate2D
    private let settings: HPOpenWeather.Settings
    private let date: Date

    init(request: TimeMachineRequest, settings: HPOpenWeather.Settings, finishingQueue: DispatchQueue) {
        self.coordinate = request.coordinate
        self.settings = settings
        self.date = request.date
        super.init(urlString: "www.google.com", finishingQueue: finishingQueue)
    }

}
