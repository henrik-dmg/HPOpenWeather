import Foundation
import HPNetwork

public struct APINetworkRequest<Output: Decodable>: NetworkRequest {

	public let url: URL?
	public let urlSession: URLSession
	public let finishingQueue: DispatchQueue
	public let requestMethod: RequestMethod = .get

	public func convertResponse(response: NetworkResponse) throws -> Output {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970

		return try decoder.decode(Output.self, from: response.data)
	}

}
