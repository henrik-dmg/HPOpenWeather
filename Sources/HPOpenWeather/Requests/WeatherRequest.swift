import Foundation
import CoreLocation
import HPNetwork

public struct WeatherRequest {

	// MARK: - Associated Types

	public typealias Output = WeatherResponse

	// MARK: - Properties

	public let coordinate: CLLocationCoordinate2D
	public let excludedFields: [ExcludableField]?
	public let date: Date?
	public let urlSession: URLSession
	public let finishingQueue: DispatchQueue

	// MARK: - Init

	public init(
		coordinate: CLLocationCoordinate2D,
		excludedFields: [ExcludableField]? = nil,
		date: Date? = nil,
		urlSession: URLSession = .shared,
		finishingQueue: DispatchQueue = .main
	) {
		self.coordinate = coordinate
		self.excludedFields = excludedFields?.hp_nilIfEmpty()
		self.date = date
		self.urlSession = urlSession
		self.finishingQueue = finishingQueue
	}

	// MARK: - OpenWeatherRequest

	func makeURL(settings: OpenWeather.Settings) -> URL? {
		URLBuilder.weatherBase
			.addingPathComponent(date != nil ? "timemachine" : nil)
			.addingQueryItem(name: "lat", value: coordinate.latitude, digits: 5)
			.addingQueryItem(name: "lon", value: coordinate.longitude, digits: 5)
			.addingQueryItem(name: "dt", value: date.flatMap({ Int($0.timeIntervalSince1970) }))
			.addingQueryItem(name: "exclude", value: excludedFields?.compactMap({ $0.rawValue }))
			.addingQueryItem(name: "appid", value: settings.apiKey)
			.addingQueryItem(name: "units", value: settings.units.rawValue)
			.addingQueryItem(name: "lang", value: settings.language.rawValue)
			.build()
	}

	func makeNetworkRequest(settings: OpenWeather.Settings) throws -> APINetworkRequest<Output> {
		if let date = date, abs(date.timeIntervalSinceNow) <= 6 * .hour {
			throw NSError.timeMachineDate
		}
		return APINetworkRequest(url: makeURL(settings: settings), urlSession: urlSession, finishingQueue: finishingQueue)
	}

}

extension Collection {

	func hp_nilIfEmpty() -> Self? {
		isEmpty ? nil : self
	}

}

extension TimeInterval {

	static let minute = 60.00
	static let hour = 3600.00
	static let day = 86400.00

}
