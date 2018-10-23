
platform :ios, '10.0'

target 'RJTranslate' do

end

target 'RJTranslate-App' do
  pod 'DZNEmptyDataSet'
  pod 'SSZipArchive'
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