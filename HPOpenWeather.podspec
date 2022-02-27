Pod::Spec.new do |s|

  s.name         = "HPOpenWeather"
  s.version      = "5.0.0"
  s.summary      = "Cross-platform framework to communicate with the OpenWeatherMap JSON API"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.homepage     = "https://panhans.dev/opensource/hpopenweather"

  s.author             = { "henrik-dmg" => "henrik@panhans.dev" }
  s.social_media_url   = "https://twitter.com/henrik_dmg"

  s.ios.deployment_target = "13.0"
  s.watchos.deployment_target = "7.0"
  s.tvos.deployment_target = "13.0"
  s.osx.deployment_target = "10.15"

  s.source       = { :git => 'https://github.com/henrik-dmg/HPOpenWeather.git', :tag => s.version }

  s.source_files = "Sources/**/*.swift"

  s.framework = "Foundation"
  s.ios.framework = "UIKit"
  s.watchos.framework = "UIKit"
  s.tvos.framework = "UIKit"

  s.swift_version = "5.5"
  s.requires_arc = true
  s.dependency "HPNetwork", "~> 3.1.1"
  s.dependency "HPURLBuilder", "~> 1.0.0"

end
