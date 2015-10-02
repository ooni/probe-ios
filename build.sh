#!/bin/sh -e
(cd measurement-kit/mobile/ios && ./scripts/build.sh)
rm -Rf Libight_iOS/Libight_iOS/Frameworks/*.framework
mv measurement-kit/mobile/ios/Frameworks/*.framework Libight_iOS/Libight_iOS/Frameworks/