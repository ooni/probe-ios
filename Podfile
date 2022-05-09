platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

# TODO(aanorbel): fix to appropriate url or use mono-repo
flutter_application_path = '../shared'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'ooniprobe' do
    pod "oonimkall", :podspec => "https://github.com/ooni/probe-cli/releases/download/v3.14.1/oonimkall.podspec"
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
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '6.1.4'
    pod 'Harpy'
    install_all_flutter_pods(flutter_application_path)
end

target 'OONIProbeUnitTests' do
    pod "oonimkall", :podspec => "https://github.com/ooni/probe-cli/releases/download/v3.14.1/oonimkall.podspec"
    pod 'SharkORM', :git => 'https://github.com/sharksync/sharkorm', :tag => 'v2.3.67'
    pod 'OCMapper', '2.0'
end

post_install do |installer|
    flutter_post_install(installer) if defined?(flutter_post_install)
end
