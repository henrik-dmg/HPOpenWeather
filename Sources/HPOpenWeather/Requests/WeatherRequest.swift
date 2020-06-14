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
    private let finishingQueue: DispatchQueue

    public init(coordinate: CLLocationCoordinate2D, finishingQueue: DispatchQueue = .main) {
        self.coordinate = coordinate
        self.finishingQueue = finishingQueue
    }

    public func makeNetworkRequest(settings: HPOpenWeather.Settings) throws -> DecodableRequest<WeatherResponse> {
        WeatherNetworkRequest(request: self, settings: settings, finishingQueue: finishingQueue)
    }
    
}

class WeatherNetworkRequest: DecodableRequest<WeatherResponse> {

    public typealias Output = WeatherResponse

    public override var url: URL? {
        URLQueryItemsBuilder(host: "api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent("onecall")
            .addingQueryItem(coordinate.latitude, digits: 5, name: "lat")
            .addingQueryItem(coordinate.longitude, digits: 5, name: "lon")
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

    init(request: WeatherRequest, settings: HPOpenWeather.Settings, finishingQueue: DispatchQueue) {
        self.coordinate = request.coordinate
        self.settings = settings
        super.init(urlString: "www.google.com", finishingQueue: finishingQueue)
    }

}

extension Double {

    static let minute = 60.00
    static let hour = 3600.00
    static let day = 86400.00

}
