#!/bin/bash
set -e

TOPDIR=$(cd $(dirname $0)/.. && pwd -P)

if [ ! -d ooniprobe/ ];then
    echo "script must be run from the root of the repo"
    exit 1
fi

if [ ! -d ../translations/probe-mobile ];then
    echo "error: you should clone https://github.com/ooni/translations in ../"
    exit 1
fi

cd ../translations
./update-translations.sh
for dir in probe-mobile/*/;do
    lang=$(basename ${dir} | tr 'zh_CN' 'zh-Hans' | tr 'zh_TW' 'zh-Hant')
    dst_path="${TOPDIR}/ooniprobe/${lang}.lproj/"
    mkdir -p $dst_path
    cp ${dir}Localizable.strings $dst_path
done
echo "Translations have been updated"
echo "Remember to commit the changes made to ooni/translations!"
