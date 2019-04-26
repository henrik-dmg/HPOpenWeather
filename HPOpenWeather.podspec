Pod::Spec.new do |s|

  s.name         = "HPOpenWeather"
  s.version      = "2.0.0"
  s.summary      = "An API for OpenWeatherMap.org written in Swift"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "https://github.com/henrik-dmg/HPOpenWeather"

  s.author             = { "henrik-dmg" => "henrik@panhans.dev" }
  s.social_media_url   = "https://twitter.com/henrik_dmg"

  s.ios.deployment_target = "10.0"
  s.watchos.deployment_target = "2.0"

  s.source       = { :git => 'https://github.com/henrik-dmg/HPOpenWeather.git', :tag => "2.0.0" }

  s.source_files = "HPOpenWeather", "HPOpenWeather/*.{plist,h,swift}"

  s.requires_arc = true

end
