#if os(iOS)
import UIKit
import SwiftUI
#endif

public enum WeatherIcon {
    case clearSky
    case fewClouds
    case scatteredClouds
    case brokenClouds
    case showerRain
    case rain
    case thunderstorm
    case snow
    case mist

    @available(iOS 13.0, *)
    var day: WeatherSystemIcon {
        return WeatherSystemIcon(icon: self, night: false)
    }

    @available(iOS 13.0, *)
    var night: WeatherSystemIcon {
        return WeatherSystemIcon(icon: self, night: true)
    }

    @available(iOS 13.0, *)
    static func make(from iconName: String) -> WeatherSystemIcon? {
        guard iconName.count == 3, let iconType = WeatherIcon(from: iconName) else {
            return nil
        }

        let isNightIcon = iconName.last! == "n"
        return isNightIcon ? iconType.night : iconType.day
    }

    init?(from apiImageCode: String) {
        switch String(apiImageCode.dropLast(1)) {
        case "01":
            self = .clearSky
        case "02":
            self = .fewClouds
        case "03":
            self = .scatteredClouds
        case "04":
            self = .brokenClouds
        case "09":
            self = .showerRain
        case "10":
            self = .rain
        case "11":
            self = .thunderstorm
        case "13":
            self = .snow
        case "50":
            self = .mist
        default:
            return nil
        }
    }
}

@available(iOS 13.0, *)
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

    public var regularImageIcon: Image {
        Image(systemName: iconName(filled: false))
    }

    public var filledUIIcon: UIImage {
        UIImage(systemName: iconName(filled: true))!
    }

    public var filledImageIcon: Image {
        Image(systemName: iconName(filled: true))
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
