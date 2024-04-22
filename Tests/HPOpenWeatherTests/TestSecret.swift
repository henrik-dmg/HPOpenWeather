import Foundation

enum TestSecret {

    static let apiKey: String = ProcessInfo.processInfo.environment["API_KEY"] ?? ""

}
