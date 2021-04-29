Pod::Spec.new do |s|
  s.name = "oonimkall"
  s.version = "2021.04.29-120219"
  s.summary = "OONI Probe Library for iOS"
  s.author = "Simone Basso"
  s.homepage = "https://github.com/ooni/probe-cli"
  s.license = { :type => "BSD" }
  s.source = {
    :http => "https://github.com/ooni/probe-cli/releases/download/v3.10.0-beta.1/oonimkall.framework.zip"
  }
  s.platform = :ios, "9.0"
  s.ios.vendored_frameworks = "oonimkall.framework"
end
