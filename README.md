# OpenWeatherSwift
A simple API written in Swift 3 based on OpenWeatherMap.org's API

To install simply add `pod 'OpenWeatherSwift'` to your Podfile

**Usage:**

```swift
import OpenWeatherSwift

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
  
  
**The following functions are available for now:**
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
```


**Todo-List:**
- [x] current weather condition functions
- [ ] 5 day / 3 hour forecasts
- [ ] 16 day / daily forecasts
  
