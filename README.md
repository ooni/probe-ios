[![ooniprobe iOS](assets/title.png)](https://ooni.torproject.org/)

[![Slack Channel](https://slack.openobservatory.org/badge.svg)](https://slack.openobservatory.org/)

This is the iOS version of [ooniprobe](https://ooni.torproject.org/).

Download it on the [App Store](https://itunes.apple.com/us/app/id1199566366).

[![](assets/app-store-badge.png)](https://itunes.apple.com/us/app/id1199566366)

If you are interested in building the app yourself, read on.

To download and install the measurement-kit library we use [CocoaPods](https://cocoapods.org).

To install cocoapod use

```
sudo gem install cocoapods # brew install cocoapods on macOS
```

Then use the command:

```
pod install
```

This command will install the latest stable binary measurement-kit library
and its dependencies and install the frameworks inside the Xcode Workspace.

Then open the xcode workspace (not the xcode project!)  located in
`ooniprobe.xcworkspace` and click on run to build it.

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

## Managing translations

To manage translations check out our [translation repo](https://github.com/ooni/translations) and follow the instructions there.

## Contributing

* Write some code

* Open a pull request

* Have fun!
