Pod::Spec.new do |s|

  s.name         = "HPOpenWeather"
  s.version      = "2.0.0"
  s.summary      = "Cross-platform framework to communicate with the OpenWeatherMap JSON API"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.homepage     = "https://github.com/henrik-dmg/HPOpenWeather"

  s.author             = { "henrik-dmg" => "henrik@panhans.dev" }
  s.social_media_url   = "https://twitter.com/henrik_dmg"

  s.ios.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => 'https://github.com/henrik-dmg/HPOpenWeather.git', :tag => "2.0.0" }

  s.source_files = "Sources/**/*.{h,swift}"
  s.framework = "Foundation"
  s.ios.framework = "UIKit"
  s.watchos.framework = "UIKit"
  s.tvos.framework = "UIKit"
  s.osx.framework = "AppKit"

  s.requires_arc = true

end
