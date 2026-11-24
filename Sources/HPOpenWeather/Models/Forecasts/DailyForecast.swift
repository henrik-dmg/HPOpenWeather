import Foundation

/// A forecast for one day.
public struct DailyForecast: ForecastBase, SunForecast, MoonForecast {

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case feelsLikeTemperature = "feels_like"
        case totalRain = "rain"
        case totalSnow = "snow"
        case timestamp = "dt"
        case temperature = "temp"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvIndex = "uvi"
        case cloudCoverage = "clouds"
        case visibility
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDirection = "wind_deg"
        case precipitationProbability = "pop"
        case weather
        case sunrise
        case sunset
        case moonrise
        case moonset
        case moonPhase = "moon_phase"
        case alertIDs = "alerts"
    }

    // MARK: - Properties

    public let temperature: DailyTemperature
    public let feelsLikeTemperature: DailyTemperature
    /// The total rain on this day, in mm.
    public let totalRain: Double?
    /// The total snow on this day, in mm.
    public let totalSnow: Double?
    /// The probability of precipitation, from 0 to 1.
    public let precipitationProbability: Double?

    public let timestamp: Date
    public let pressure: Double?
    public let humidity: Double?
    public let dewPoint: Double?
    public let uvIndex: Double?
    public let visibility: Double?
    public let cloudCoverage: Double?
    public let condition: WeatherCondition
    public let sun: Sun
    public let wind: Wind
    public let moon: Moon
    /// The IDs of the weather alerts for the location on this day.
    ///
    /// Use ``OpenWeather/weatherAlert(withID:urlSession:)`` to get the details of an alert.
    public let alertIDs: [String]

    // MARK: - Init

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let weatherArray = try container.decode([WeatherCondition].self, forKey: .weather)
        guard let condition = weatherArray.first else {
            throw OpenWeatherError.noCurrentConditionReturned
        }
        self.condition = condition

        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.pressure = try container.decodeIfPresent(Double.self, forKey: .pressure)
        self.humidity = try container.decodeIfPresent(Double.self, forKey: .humidity)
        self.dewPoint = try container.decodeIfPresent(Double.self, forKey: .dewPoint)
        self.uvIndex = try container.decodeIfPresent(Double.self, forKey: .uvIndex)
        self.cloudCoverage = try container.decodeIfPresent(Double.self, forKey: .cloudCoverage)
        self.visibility = try container.decodeIfPresent(Double.self, forKey: .visibility)
        self.temperature = try container.decode(DailyTemperature.self, forKey: .temperature)
        self.feelsLikeTemperature = try container.decode(DailyTemperature.self, forKey: .feelsLikeTemperature)
        self.totalRain = try container.decodeIfPresent(Double.self, forKey: .totalRain)
        self.totalSnow = try container.decodeIfPresent(Double.self, forKey: .totalSnow)
        self.precipitationProbability = try container.decodeIfPresent(Double.self, forKey: .precipitationProbability)
        self.alertIDs = try container.decodeIfPresent([String].self, forKey: .alertIDs) ?? []

        let windSpeed = try container.decodeIfPresent(Double.self, forKey: .windSpeed)
        let windGust = try container.decodeIfPresent(Double.self, forKey: .windGust)
        let windDirection = try container.decodeIfPresent(Double.self, forKey: .windDirection)
        self.wind = Wind(speed: windSpeed, gust: windGust, degrees: windDirection)

        let sunrise = try container.decodeEventTimestampIfPresent(forKey: .sunrise)
        let sunset = try container.decodeEventTimestampIfPresent(forKey: .sunset)
        self.sun = Sun(sunset: sunset, sunrise: sunrise)

        let moonrise = try container.decodeEventTimestampIfPresent(forKey: .moonrise)
        let moonset = try container.decodeEventTimestampIfPresent(forKey: .moonset)
        let moonPhase = try container.decodeIfPresent(Double.self, forKey: .moonPhase)
        self.moon = Moon(moonset: moonset, moonrise: moonrise, phase: moonPhase)
    }

    // MARK: - Encoding

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(temperature, forKey: .temperature)
        try container.encodeIfPresent(feelsLikeTemperature, forKey: .feelsLikeTemperature)
        try container.encodeIfPresent(totalRain, forKey: .totalRain)
        try container.encodeIfPresent(totalSnow, forKey: .totalSnow)
        try container.encodeIfPresent(precipitationProbability, forKey: .precipitationProbability)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(pressure, forKey: .pressure)
        try container.encodeIfPresent(humidity, forKey: .humidity)
        try container.encodeIfPresent(dewPoint, forKey: .dewPoint)
        try container.encodeIfPresent(uvIndex, forKey: .uvIndex)
        try container.encodeIfPresent(visibility, forKey: .visibility)
        try container.encodeIfPresent(cloudCoverage, forKey: .cloudCoverage)
        try container.encodeIfPresent([condition], forKey: .weather)
        try container.encode(alertIDs, forKey: .alertIDs)

        try container.encodeIfPresent(sun.sunrise, forKey: .sunrise)
        try container.encodeIfPresent(sun.sunset, forKey: .sunset)

        try container.encodeIfPresent(moon.moonrise, forKey: .moonrise)
        try container.encodeIfPresent(moon.moonset, forKey: .moonset)
        try container.encodeIfPresent(moon.phase, forKey: .moonPhase)

        try container.encodeIfPresent(wind.gust, forKey: .windGust)
        try container.encodeIfPresent(wind.speed, forKey: .windSpeed)
        try container.encodeIfPresent(wind.degrees, forKey: .windDirection)
    }

}
