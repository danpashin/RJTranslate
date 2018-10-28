
platform :ios, '10.0'

target 'RJTranslate' do

end

target 'RJTranslate-App' do
  use_frameworks!

  pod 'DZNEmptyDataSet'
  pod 'SSZipArchive'
  pod 'Firebase/Core'

  pod 'Fabric', '~> 1.7.11'
  pod 'Crashlytics', '~> 3.10.7'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
      
      if target.name.include?("RJTranslate")
      	config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'YES'
      end
    end
  end
end