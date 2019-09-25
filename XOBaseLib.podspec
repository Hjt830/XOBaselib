#
# Be sure to run `pod lib lint XOBaseLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XOBaseLib'
  s.version          = '0.1.6'
  s.summary          = 'XXOOGO项目的基础模块'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
XXOOGO项目采用cocoapods做组件化架构，将不同的模块使用pod私有仓库管理，只需要在主项目中使用 pod 'XOBaseLib' 即可导入模块使用
                       DESC

  s.homepage         = 'http://192.168.1.119/xxoogo_livechat/xobaselib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kenter' => 'Hjt_830@163.com' }
  s.source           = { :git => 'http://192.168.1.119/xxoogo_livechat/xobaselib.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.jianshu.com/u/7e5e59276b03'

  s.ios.deployment_target = '8.0'

  s.public_header_files = 'XOBaseLib/Classes/**/*.h'
  s.source_files = 'XOBaseLib/Classes/**/*.{h,m}'
  
  s.resource_bundles = {
     'XOBaseLib' => ['XOBaseLib/Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'AFNetworking', '~> 3.2.1'
  s.dependency 'GTMBase64', '~> 1.0.1'
  s.dependency 'SDWebImage', '~> 5.0.6'
  s.dependency 'YYKit', '~> 1.0.9'
  s.dependency 'MJRefresh', '~> 3.2.0'
  s.dependency 'SVProgressHUD', '~> 2.2.5'
  s.dependency 'TZImagePickerController', '~> 3.2.1'
  
end
