platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!



def ooni_pods
    ooni_version = "v3.24.0"
    ooni_pods_location = "https://github.com/ooni/probe-cli/releases/download/#{ooni_version}"

    pod "libcrypto", :podspec => "#{ooni_pods_location}/libcrypto.podspec"
    pod "libevent", :podspec => "#{ooni_pods_location}/libevent.podspec"
    pod "libssl", :podspec => "#{ooni_pods_location}/libssl.podspec"
    pod "libtor", :podspec => "#{ooni_pods_location}/libtor.podspec"
    pod "libz", :podspec => "#{ooni_pods_location}/libz.podspec"
    pod "oonimkall", :podspec => "#{ooni_pods_location}/oonimkall.podspec"
end

target 'ooniprobe' do
    ooni_pods
    pod 'Toast', '~> 4.0.0'
    pod 'MBProgressHUD'
    pod 'DZNEmptyDataSet'
    pod 'lottie-ios', '2.5.3'
    pod 'SharkORM', :git => 'https://github.com/sharksync/sharkorm', :tag => 'v2.3.67'
    pod 'MKDropdownMenu'
    pod 'RHMarkdownLabel'
    pod 'DateTools'
    pod 'OCMapper', '2.0'
    pod 'Countly'
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '8.35.0'
    pod 'Harpy'
end

target 'OONIProbeUnitTests' do
    ooni_pods
    pod 'SharkORM', :git => 'https://github.com/sharksync/sharkorm', :tag => 'v2.3.67'
    pod 'OCMapper', '2.0'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            end
        end
    end
end
