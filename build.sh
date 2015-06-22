#!/bin/sh -e
(cd measurement-kit-build-ios/ && ./scripts/build.sh)
cp -Rf measurement-kit-build-ios/*.framework Libight_iOS/Libight_iOS/Frameworks/
