Pod::Spec.new do |s|

  s.name         = "HPOpenWeather"
  s.version      = "5.0.0"
  s.summary      = "Cross-platform framework to communicate with the OpenWeatherMap JSON API"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.homepage     = "https://panhans.dev/opensource/hpopenweather"

  s.author             = { "henrik-dmg" => "henrik@panhans.dev" }
  s.social_media_url   = "https://twitter.com/henrik_dmg"

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => 'https://github.com/henrik-dmg/HPOpenWeather.git', :tag => s.version }

  s.source_files = "Sources/**/*.swift"
  
  s.framework = "Foundation"
  s.ios.framework = "UIKit"
  s.watchos.framework = "UIKit"
  s.tvos.framework = "UIKit"
  s.osx.framework = "AppKit"

  s.swift_version = "5.1"
  s.requires_arc = true
  s.dependency "HPNetwork", "~> 2.0.2"

end
