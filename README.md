<p align="center">
    <img src="https://imgur.com/download/EQ5Zj06" alt="Storage" />
</p>

<a href="https://codebeat.co/projects/github-com-henrik-dmg-hpopenweather-master"><img alt="codebeat badge" src="https://codebeat.co/badges/369155e1-b902-4b3c-a44a-59257e5649f8" /></a>
<a href="https://img.shields.io/badge/Swift-5.0-orange"><img src="https://img.shields.io/badge/Swift-5.0-orange.svg"/></a>

## Disclaimer: This documentation is outdated, I'm in the process of rewriting the whole library

## Installation
HPOpenWeather supports iOS 10.0+, watchOS 2.0+
To install simply add `pod 'HPOpenWeather'` to your Podfile, or add `github "henrik-dmg/HPOpenWeather" ~> 2.0.0`

**Usage:**

```swift
import HPOpenWeather

var newApi = OpenWeatherSwift(apiKey: "_your_api_key_goes_here", temperatureFormat: .Celsius)
```

**The following parameters are available:**
- Language
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
  
- Temperature Format
  - Celsius
  - Kelvin
  - Fahrenheit
  
  

**The following functions are available:**
The result will always be a JSON object, whose values can be accessed. Additionally, you can create a Weather() object to conveniently access the JSON data.

```swift
newApi.currentWeatherByCoordinates(coords: CLLocationCoordinate2D) { (results) in
       let weather = Weather(data: results)
}


newApi.currentWeatherByCity(name: String) { (result) in
       let weather = Weather(data: results)
}


newApi.currentWeatherByID(id: String) { (result) in
       let weather = Weather(data: results)
}


newApi.currentWeatherByZIP(code: String, countryCode: String) { (result) in
       let weather = Weather(data: results)
}


newApi.forecastWeatherByCoordinates(coords: CLLocationCoordinate2D, type: ForecastType) { (results) in
       let forecast = Forecast(data: results, type: ForecastType)
}


newApi.forecastWeatherByID(id: String, type: ForecastType) { (results) in
       let forecast = Forecast(data: results, type: ForecastType)
}


newApi.forecastWeatherByCity(name: String, type: ForecastType) { (results) in
       let forecast = Forecast(data: results, type: ForecastType)
}
```

Have fun and thanks for using :)
