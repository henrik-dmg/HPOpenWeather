import HPNetwork

extension URLQueryItemsBuilder {

    static let weatherBase: URLQueryItemsBuilder = {
        URLQueryItemsBuilder(host: "api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent("onecall")
    }()

}
