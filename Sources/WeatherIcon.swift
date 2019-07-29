//
//  WeatherIcon.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 29.07.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(macOS)
    import AppKit
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
        guard iconName.count == 3 else {
            return nil
        }

        let subString = iconName

        return nil
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

    public var regularIcon: UIImage {
        return UIImage(systemName: iconName(filled: false))!
    }

    public var filledIcon: UIImage {
        return UIImage(systemName: iconName(filled: true))!
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
