#
# Be sure to run `pod lib lint UPVideoCarousel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UPVideoCarousel'
  s.version          = '1.0'
  s.summary          = 'UPVideoCarousel is video Carousel for ios'

  s.swift_versions   = '5.0'
  s.description      = "UPVideoCarousel is very easy to use and light weight Carousel control for ios, developed in Swift"

  s.homepage         = 'https://github.com/erbittuu/UPVideoCarousel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'erbittuu' => 'utsavhacker@gmail.com' }
  s.source           = { :git => 'https://github.com/erbittuu/UPVideoCarousel.git', :tag => s.version.to_s }
   s.social_media_url = 'https://twitter.com/erbittuu'

  s.ios.deployment_target = '11.3'

  s.source_files = 'UPVideoCarousel/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UPVideoCarousel' => ['UPVideoCarousel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency   'ASPVideoPlayer'
end
