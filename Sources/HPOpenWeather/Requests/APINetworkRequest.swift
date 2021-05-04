import Foundation
import HPNetwork

public struct APINetworkRequest<Output: Decodable>: DecodableRequest {

	public let url: URL?
	public let urlSession: URLSession
	public let finishingQueue: DispatchQueue
	public let requestMethod: NetworkRequestMethod = .get
	public let headerFields = [NetworkRequestHeaderField.contentTypeJSON]

	public let decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970
		return decoder
	}()

	public func makeURL() throws -> URL {
		guard let url = url else {
			throw NSError(code: 6, description: "Could not create URL")
		}
		return url
	}

}
