platform :ios,'10.0'
use_frameworks!

target 'SNSApp' do
    pod 'SwiftMessages', '5.0.0'
    pod 'FCAlertView'
    pod 'Alamofire', '~> 4.7'
    pod 'AlamofireObjectMapper', '~> 5.0'
    pod 'AlamofireImage'
    pod 'PopupDialog', '~> 0.9'
    pod 'YPImagePicker'
end



post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

