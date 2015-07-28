# MeasurementKit iOS demo App

This is the example MeasurementKit iOS application.

To see how it work you should get a copy of this repository with:

```
git clone --recursive https://github.com/measurement-kit/measurement-kit-app-ios
```

To make sure that subrepositories are up to date, you can use the
following commands:

```
git submodule deinit -f .
git pull
git submodule update --init --recursive
```

Then build the library for iOS with:

```
./build.sh
```

This command will compile measurement-kit and its dependencies and
install them as frameworks inside Libight_iOS/Libight_iOS/Frameworks.

Then open the xcode project located in `Libight_iOS/Libight_iOS.xcodeproj` and
click on run to build it.

## Contributing

* Write some code

* Open a pull request

* Have fun!
