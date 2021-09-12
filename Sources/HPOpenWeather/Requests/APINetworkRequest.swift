import Foundation
import HPNetwork

struct APINetworkRequest: DecodableRequest {

	typealias Output = WeatherResponse

	static let decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970
		return decoder
	}()

	let url: URL?
	let urlSession: URLSession
	let finishingQueue: DispatchQueue
	let requestMethod: NetworkRequestMethod = .get
	let headerFields = [NetworkRequestHeaderField.contentTypeJSON]

	var decoder: JSONDecoder {
		APINetworkRequest.decoder
	}

	public func makeURL() throws -> URL {
		guard let url = url else {
			throw NSError(code: 6, description: "Could not create URL")
		}
		return url
	}

}
