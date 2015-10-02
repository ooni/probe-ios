#!/bin/sh -e
(cd measurement-kit/mobile/ios && ./scripts/build.sh)
cp -Rf measurement-kit/mobile/ios/*.framework Libight_iOS/Libight_iOS/Frameworks/
