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

To get started, you need an API key from [OpenWeather](https://openweathermap.org). Then you can create an instance of the ``OpenWeather`` class.

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

To fetch the weather, there are two options: async/await or callback. Both expect a `CLLocationCoordinate2D` for which to fetch the weather.
Additionally, you can specify which fields should be excluded from the response to save bandwidth, or specify a historic date or a date up to 4 days in the future.

See the ``Weather`` and ``CurrentWeather`` types for details on available data.

#### Async

```swift
let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
let weather = try await openWeatherClient.weather(for: coordinate)
```

#### Callback

```swift
let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
openWeatherClient.requestWeather(for: coordinate) { result in
    switch result {
    case .success(let weather):
        print(weather)
    case .failure(let error):
        print(error)
    }
}
```

### Available languages

- English (default)
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

See ``WeatherLanguage`` for details.

### Available units

- Metric (wind speed in m/s, temperature in Celsius, default)
- Imperial (wind speed in mph, temperature in Fahrenheit)
- Standard (wind speed in m/s, temperature in Kelvin)

See ``WeatherUnits`` for details.
