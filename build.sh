#!/bin/bash
cd libight-build-ios/
./build.sh 
cd ..
cp -Rf libight-build-ios/dist/lib/* Libight_iOS/Libight_iOS/lib/
cp -Rf libight-build-ios/dist/include/* Libight_iOS/Libight_iOS/include/
