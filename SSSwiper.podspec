#
# Be sure to run `pod lib lint SSSwiper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SSSwiper'
  s.version          = '1.0.0'
  s.summary          = 'SSSwiper is used to create swipe gestures action inside any view just by adding a modifier to the View with various customisation options.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'This library is used to add multiple action buttons just by adding a modifier to the view with full flexibilites and customizastion. You can add swiping gestures and allow action in both horizontal sides and you can add items according to your choice on both sides. This library also supports destructive action which supports action if user swipes full and it will trigger the first option from the edge of the device. SSSwiper also gives to option to customize shape and spacing of the SwipeItems(Action Buttons). This library also has haptic feedbacks while performing diffrent operations. You can add as much as SwipeItems(Action Buttons) in SSSwiper as this supports responsive design which does not breaks your UI and it will adjust automaticaally by removing extra buttons according to device size. '
                       DESC

  s.homepage         = 'https://github.com/SimformSolutionsPvtLtd/SSSwiper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source           = { :git => 'https://github.com/SimformSolutionsPvtLtd/SSSwiper.git', :tag => s.version.to_s }
  s.author           = { 'Shubham Vyas' => 'shubham.vyas@simformsolutions.com' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'

  s.source_files = 'Sources/**/*'
  
  # s.resource_bundles = {
  #   'SSSwiper' => ['SSSwiper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
