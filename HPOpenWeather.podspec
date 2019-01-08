Pod::Spec.new do |s|

  s.name         = "HPOpenWeather"
  s.version      = "1.2.0"
  s.summary      = "An API for OpenWeatherMap.org written in Swift"

  s.license      = { :type => "MIT", :file => "LICENSE" }
s.homepage     = "https://github.com/Fri3ndlyGerman/HPOpenWeather"

  s.author             = { "Fri3ndlyGerman" => "henrikpanhans@icloud.com" }
  s.social_media_url   = "https://twitter.com/fri3ndlygerman"

  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "2.0"

  s.source       = { :git => 'https://github.com/Fri3ndlyGerman/OpenWeatherSwift.git', :tag => "1.2.0" }

  s.source_files = "HPOpenWeather", "HPOpenWeather/*.{plist,h,swift}"

  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'

  s.requires_arc = true

end