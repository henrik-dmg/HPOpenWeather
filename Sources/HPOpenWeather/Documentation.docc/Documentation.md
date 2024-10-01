# ``HPOpenWeather``

## Overview

HPOpenWeather is a cross-platform Swift framework to communicate with the OpenWeather One-Call API.
See their [documentation](https://openweathermap.org/api/one-call-api) for further details.

## Installation

``HPOpenWeather`` supports iOS 15.0+, watchOS 6.0+, tvOS 15.0+ and macOS 12+.
It can be installed via SPM:

```
.package(url: "https://github.com/henrik-dmg/HPOpenWeather", from: "6.0.0")
```

## Usage

### Configuration

To get started, you need an API key from [OpenWeather](https://openweathermap.org).

```swift
import HPOpenWeather

// Create instance
let openWeatherClient = OpenWeather(apiKey: "<your-key>")

// Or use options
let settings = OpenWeather.Settings(apiKey: "<your-key>", language: .german, units: .metric)
let openWeather = OpenWeather(settings: settings)

// Change settings at any point
openWeatherClient.apiKey = "<your-key>"
openWeatherClient.language = .german
openWeatherClient.units = .metric
```

### Retrieving Weather Information

To fetch the weather, there are two options: async/await or callback. Both expect a ``CLLocationCoordinate2D`` for which to fetch the weather.
Additionally, you can specify which fields should be excluded from the response to save bandwidth, or specify a historic date or a date up to 4 days in the future.

#### Async

```swift
let weather = try await openWeatherClient.weather(for: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
```

#### Callback

```swift
openWeatherClient.requestWeather(for: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)) { result in
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
