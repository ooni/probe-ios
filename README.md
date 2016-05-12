# MeasurementKit iOS demo App 

This is the example MeasurementKit iOS application.

To see how it work you should get a copy of this repository with:

```
git clone https://github.com/measurement-kit/measurement-kit-app-ios
```
To download and install the measurement-kit library we use [cocoapod](https://cocoapods.org). 

To install cocoapod use 

	$ sudo gem install cocoapods

Then use the command 
	
	pod install


This command will install the latest stable binary measurement-kit library and its dependencies and install the frameworks inside the Xcode Workspace. 

Then open the xcode workspace (not the xcode project!)  located in `NetProbe.xcworkspace` and click on run to build it.

### How to complile a specific version of measurement-kit for an Xcode project.

You can use a specific version of [measurement-kit](https://github.com/measurement-kit/measurement-kit) it in your project by adding this line in your Podfile:

    pod 'measurement_kit',
      :git => 'https://github.com/measurement-kit/measurement-kit.git'

You can use a specific branch, e.g.:

    pod 'measurement_kit',
      :git => 'https://github.com/measurement-kit/measurement-kit.git',
      :branch => 'branch-name'

Similarly, you can use a specific tag, e.g.:

    pod 'measurement_kit', 
      :git => 'https://github.com/measurement-kit/measurement-kit.git',
      :tag => 'v0.x.y'

Then type `pod install` and open `.xcworkspace` file (beware not to open the
`.xcodeproj` file instead, because that alone won't compile).

## Contributing

* Write some code

* Open a pull request

* Have fun!
