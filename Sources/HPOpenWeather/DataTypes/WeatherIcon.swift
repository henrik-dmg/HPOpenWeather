#if canImport(UIKit)
import SwiftUI
import UIKit

extension WeatherCondition {

    /// The corresponding system weather icon
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public var systemIcon: WeatherSystemIcon? {
        return WeatherIcon.make(from: iconString)
    }

}

public enum WeatherIcon: String {

    case clearSky = "01"
    case fewClouds = "02"
    case scatteredClouds = "03"
    case brokenClouds = "04"
    case showerRain = "09"
    case rain = "10"
    case thunderstorm = "11"
    case snow = "13"
    case mist = "50"

    init?(apiCode: String) {
        let code = String(apiCode.dropLast())
        self.init(rawValue: code)
    }

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    var day: WeatherSystemIcon {
        return WeatherSystemIcon(icon: self, night: false)
    }

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    var night: WeatherSystemIcon {
        return WeatherSystemIcon(icon: self, night: true)
    }

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    static func make(from iconName: String) -> WeatherSystemIcon? {
        guard iconName.count == 3, let iconType = WeatherIcon(apiCode: iconName) else {
            return nil
        }

        let isNightIcon = iconName.last! == "n"
        return isNightIcon ? iconType.night : iconType.day
    }
    
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct WeatherSystemIcon {

    fileprivate init(icon: WeatherIcon, night: Bool) {
        self.icon = icon
        self.isNightIcon = night
    }

    private let icon: WeatherIcon
    private let isNightIcon: Bool

    public var regularUIIcon: UIImage {
        UIImage(systemName: iconName(filled: false))!
    }

    public var filledUIIcon: UIImage {
        UIImage(systemName: iconName(filled: true))!
    }

    private func iconName(filled: Bool) -> String {
        var iconName = ""
        switch self.icon {
        case .clearSky:
            iconName = isNightIcon ? "moon" : "sun.max"
        case .fewClouds:
            iconName = isNightIcon ? "cloud.moon" : "cloud.sun"
        case .scatteredClouds:
            iconName = "cloud"
        case .brokenClouds:
            iconName = "smoke"
        case .showerRain:
            iconName = "cloud.rain"
        case .rain:
            iconName = isNightIcon ? "cloud.moon.rain" : "cloud.sun.rain"
        case .thunderstorm:
            iconName = "cloud.bolt.rain"
        case .snow:
            return "snow"
        case .mist:
            iconName = "cloud.fog"
        }

        if filled {
            iconName.append(".fill")
        }

        return iconName
    }

}

#endif
