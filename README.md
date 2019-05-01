<p align="center">
    <img src="https://imgur.com/download/EQ5Zj06" alt="Storage" />
</p>

<a href="https://codebeat.co/projects/github-com-henrik-dmg-hpopenweather-master"><img alt="codebeat badge" src="https://codebeat.co/badges/bd49e990-0d77-4f1c-bfcd-885666470201" /></a>
<a href="https://img.shields.io/badge/Swift-5.0-orange"><img src="https://img.shields.io/badge/Swift-5.0-orange.svg"/></a>

HPOpenWeather is a cross-platform Swift framework to communicate with the OpenWeatherMap JSON API. See their [documentation](https://openweathermap.org/api) for further details.
## Installation
HPOpenWeather supports iOS 9.0+, watchOS 2.0+, tvOS 9.0+ and macOS 10.10+.
To install simply add `pod 'HPOpenWeather'` to your Podfile, or add `github "henrik-dmg/HPOpenWeather" ~> 2.0.0`

## Usage
To get started, you need an API key from [OpenWeatherMap](https://openweathermap.org). Put this API key in the initialiser, additionally you can also specify a custom temperature format and/or language used in the responses (see list for available languages and units below).
```swift
import HPOpenWeather

var api = HPOpenWeather(apiKey: "--- YOUR API KEY ---")
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

### Creating a request
To make an request, create a new `WeatherRequest`object, such as:
```swift
// This will request weather data based on coordinates
var locationRequest = LocationRequest(userCoordinates)

/*
This will request weather data based on a city name.
countryCode is an optional ISO 3166 code to narrow the search down
*/
var cityRequest = CityNameRequest("Berlin", countryCode: "DE")

/*
This will request weather data based on a ZIP code
Again, countryCode is an optional ISO 3166 code
*/
var zipCodeRequest = ZipCodeRequest("10405", countryCode: "DE")

/*
This will request weather data based on a city ID.
For a list of city IDs, follow the link below
*/
var cityIdRequest = CityIdRequest("2950159")
```
Full list of city IDs can be downloaded [here](http://samples.openweathermap.org/data/2.5/weather?id=2172797&appid=b6907d289e10d714a6e88b30761fae22)

### Executing the request
Currently, only current weather data, and forecast data are available (historical data support will be added later).
To request the current weather, call
```swift
api.requestCurrentWeather(with: request) { (current, error) in
	guard let current = current, error == nil else {
		// Handle error here
		return
	}
	
	// Do something with data here
}
```
Note: The type returned by this call is `CurrentWeather`which is slightly different from `HourlyForecast`and `DailyForecast`.

To request an hourly forecast, call `requestHourlyForecast(...)`and `requestDailyForecast`respectively.
```swift
api.requestHourlyForecast(with: request, for: .threeHourly) { (forecast, error) in
	guard let forecast = forecast, error == nil else {
		// Handle error here
		return
	}
            
	// Do something with forecast here
}
```

## TODO List
- [x] Current weather data
- [x] Daily and hourly forecast
- [ ] More Unit Tests
- [ ] Historical Data
- [ ] UV Index Data
- [ ] watchOS and tvOS demo apps

#### This documentation is far from complete, however the code itself is pretty well documented so feel free to just play around and just contact me if you have any suggestions :)
