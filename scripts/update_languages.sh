#! /bin/bash -u
tx pull -f
tx pull -f -l zh_CN
tx pull -f -l zh_TW
cp ooniprobe/zh_CN.lproj/Localizable.strings ooniprobe/zh-Hans.lproj/Localizable.strings
cp ooniprobe/zh_TW.lproj/Localizable.strings ooniprobe/zh-Hant.lproj/Localizable.strings
rm -Rf ooniprobe/zh_CN.lproj ooniprobe/zh_TW.lproj
rm -Rf description
