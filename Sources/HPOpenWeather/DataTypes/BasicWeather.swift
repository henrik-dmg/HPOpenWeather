import Foundation

public protocol BasicWeatherResponse: Codable, Hashable {

    var timestamp: Date { get }
    var pressure: Double? { get }
    var humidity: Double? { get }
    var dewPoint: Double? { get }
    var uvIndex: Double? { get }
    var visibility: Double? { get }
    var cloudCoverage: Double? { get }
    var wind: Wind { get }

}

public protocol SunResponse: Codable, Hashable {

    var sun: Sun { get }

}
