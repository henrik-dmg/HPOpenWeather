# ``HPOpenWeather``

## Overview

HPOpenWeather is a cross-platform Swift framework to communicate with the OpenWeather One Call API 4.0.
See their [documentation](https://openweathermap.org/api/one-call-4) for further details.

## Installation

``HPOpenWeather`` supports iOS 15.0+, watchOS 6.0+, tvOS 15.0+ and macOS 12+.
It can be installed via SPM:

```
.package(url: "https://github.com/henrik-dmg/HPOpenWeather", from: "7.0.0")
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

The One Call API 4.0 has a separate endpoint for each type of data. ``OpenWeather`` has one method for each endpoint.
Each method expects a `CLLocationCoordinate2D` for the location of the weather.

```swift
let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)

let currentWeather = try await openWeatherClient.currentWeather(for: coordinate)
let minutely = try await openWeatherClient.minutelyForecast(for: coordinate)
let quarterHourly = try await openWeatherClient.quarterHourlyForecast(for: coordinate)
let hourly = try await openWeatherClient.hourlyForecast(for: coordinate)
let daily = try await openWeatherClient.dailyForecast(for: coordinate)
```

The timeline methods return a ``WeatherTimeline``. Each response has a limited number of entries.
To get historical data, set the `startDate` parameter. To get the adjacent entries, request the next or the previous page:

```swift
let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: .now)
let history = try await openWeatherClient.dailyForecast(for: coordinate, startDate: lastYear)

if let nextPage = try await openWeatherClient.nextPage(of: history) {
    print(nextPage.entries)
}
```

The forecasts contain the IDs of the weather alerts for the location. To get the details of an alert, use ``OpenWeather/weatherAlert(withID:urlSession:)``.

### Retrieving All Weather Information at Once

The ``OpenWeather/weather(for:excludedFields:urlSession:)`` method calls the endpoints in parallel and combines the responses into one ``Weather`` value.
It also gets the details of all weather alerts that the responses refer to.

Each call counts against your API quota. A request without excluded fields causes five calls, plus one call for each alert.
Use the `excludedFields` parameter to skip the data that you do not need.

See the ``Weather`` and ``CurrentWeather`` types for details on available data.

#### Async

```swift
let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
let weather = try await openWeatherClient.weather(for: coordinate, excludedFields: [.minutely, .quarterHourly])
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
