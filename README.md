<p align="center">
    <img src="https://imgur.com/download/EQ5Zj06" alt="Storage" />
</p>
[![CodeFactor](https://www.codefactor.io/repository/github/henrik-dmg/hpopenweather/badge)](https://www.codefactor.io/repository/github/henrik-dmg/hpopenweather)
<a href="https://img.shields.io/badge/Swift-5.0-orange"><img src="https://img.shields.io/badge/Swift-5.0-orange.svg"/></a>
[![GitHub license](https://img.shields.io/github/license/henrik-dmg/HPOpenWeather)](https://github.com/henrik-dmg/HPOpenWeather/blob/master/LICENSE.md)
![.github/workflows/swift.yml](https://github.com/henrik-dmg/HPOpenWeather/workflows/.github/workflows/swift.yml/badge.svg)

HPOpenWeather is a cross-platform Swift framework to communicate with the OpenWeatherMap JSON API. See their [documentation](https://openweathermap.org/api) for further details.
## Installation

HPOpenWeather supports iOS 9.0+, watchOS 2.0+, tvOS 9.0+ and macOS 10.10+.

#### SPM

Add `.package(url: "https://github.com/henrik-dmg/HPOpenWeather", from: "3.0.0")` to your `Package.swift` file

#### CocoaPods

Add `pod 'HPOpenWeather'` to your `Podfile` and run `pod install`

#### Carthage

Add `github "henrik-dmg/HPOpenWeather" ~> 3.0.0` to your `Cartfile`

## Usage

To get started, you need an API key from [OpenWeatherMap](https://openweathermap.org). Put this API key in the initialiser, additionally you can also specify a custom temperature format and/or language used in the responses (see list for available languages and units below).
```swift
import HPOpenWeather

// Assign API key
HPOpenWeather.shared.apiKey = "--- YOUR API KEY ---"
```

## Making  a request

To make a request, initialize a new request object like this

```swift
let configuration = RequestConfiguration(
	language: .english,
	units: .metric,
	apiKey: HPOpenWeather.shared.apiKey)

let request = WeatherRequest(coordinate: .init(latitude: 40, longitude: 30), configuration: configuration)
```

And to post it:

```swift
HPOpenWeather.shared.requestWeather(request) { result in
	// Handle result
}
```

**The following response languages are available**

- English
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

**The following temperature units are available**

- Celsius
- Kelvin
- Fahrenheit

## TODO List
- [x] Current weather data
- [x] Daily and hourly forecast
- [ ] More Unit Tests
- [ ] Historical Data
- [ ] UV Index Data
- [ ] watchOS and tvOS demo apps

#### This documentation is far from complete, however the code itself is pretty well documented so feel free to just play around and just contact me if you have any suggestions :)
