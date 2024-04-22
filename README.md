# HPOpenWeather

<a href="https://www.codefactor.io/repository/github/henrik-dmg/hpopenweather"><img src="https://www.codefactor.io/repository/github/henrik-dmg/hpopenweather/badge" alt="CodeFactor" /></a>
<a href="https://img.shields.io/badge/Swift-5.0-orange"><img src="https://img.shields.io/badge/Swift-5.0-orange.svg"/></a>
<a href="https://github.com/henrik-dmg/HPOpenWeather/blob/master/.github/workflows/swift.yml"><img src="https://github.com/henrik-dmg/HPOpenWeather/workflows/Swift/badge.svg" alt="Github Actions"/></a>
[![GitHub license](https://img.shields.io/github/license/henrik-dmg/HPOpenWeather)](https://github.com/henrik-dmg/HPOpenWeather/blob/master/LICENSE.md)

HPOpenWeather is a cross-platform Swift framework to communicate with the OpenWeather One-Call API. See their [documentation](https://openweathermap.org/api/one-call-api) for further details.

## Installation

HPOpenWeather supports iOS 15.0+, watchOS 6.0+, tvOS 15.0+ and macOS 12+.

### SPM

Add `.package(url: "https://github.com/henrik-dmg/HPOpenWeather", from: "6.0.0")` to your `Package.swift` file

## Usage

### Configuration

To get started, you need an API key from [OpenWeather](https://openweathermap.org). Configure the `OpenWeather.shared` singleton or create your own instance and configure it with your key and other settings.

```swift
import HPOpenWeather

// Assign API key
OpenWeather.shared.apiKey = "--- YOUR API KEY ---"
OpenWeather.shared.language = .german
OpenWeather.shared.units = .metric

// Or use options
let settings = OpenWeather.Settings(apiKey: "yourAPIKey", language: .german, units: .metric)
let openWeather = OpenWeather(settings: settings)
```

You can also customise the response data units and language by accessing the `language` and `units` propertis.

### Retrieving Weather Information

To fetch the weather, there are two options: async/await or callback. Both expect a `CLLocationCoordinate2D` for which to fetch the weather.
Additionally, you can specify which fields should be excluded from the response to save bandwidth, or specify a historic date or a date up to 4 days in the future.

#### Async

```swift
let weather = try await OpenWeather.shared.weather(for: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
```

#### Callback

```swift
OpenWeather.shared.requestWeather(for: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)) { result in
    switch result {
    case .success(let weather):
        print(weather)
    case .failure(let error):
        print(error)
    }
}
```

### Available languages (default in bold)

- **English**
- Russian
- Italian
- Spanish
- Ukrainian
- German
- Portuguese
- Romanian
- Polish
- Finnish
- Dutch
- French
- Bulgarian
- Swedish
- Chinese Traditional
- Chinese Simplified
- Turkish
- Croatian
- Catalan

### Available units (default in bold)

- **Metric** (wind speed in m/s, temperature in Celsius)
- Imperial (wind speed in mph, temperature in Fahrenheit)
- Standard (wind speed in m/s, temperature in Kelvin)
