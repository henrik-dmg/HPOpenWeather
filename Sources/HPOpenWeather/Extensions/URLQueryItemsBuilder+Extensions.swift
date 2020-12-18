import HPNetwork

extension URLBuilder {

    static let weatherBase: URLBuilder = {
        URLBuilder(host: "api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent("onecall")
    }()

}
