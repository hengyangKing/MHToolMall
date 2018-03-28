#
#  Be sure to run `pod spec lint MHToolMall.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "MHToolMall"
  s.version      = "0.0.3"
  s.summary      = "Provide tools for musichome."

  s.description  = "Provide tools for the musichome"

  s.homepage     = "https://github.com/hengyangKing/MHToolMall"
  

  s.license      = "MIT"
  
  s.author       = { "hengyangKing" => "hengyangKing.yeah.net" }
  
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/hengyangKing/MHToolMall.git", :tag => "#{s.version}" }

  s.subspec 'MHTopWindow' do |w|
      w.source_files = "Classes", "Classes/MHTopWindow/**/*.{h,m}"

  end
  s.subspec 'MHAVFormatShop' do |form|
      form.source_files = "Classes", "Classes/MHAVFormatShop/**/*.{h,m}"
      form.framework  = "AVFoundation"
      form.dependency "MHBaseConst"
      form.dependency "KingBaseCategory/NSDate+"
      form.dependency "KingBaseCategory/NSFileManager+"


  end

  
end
