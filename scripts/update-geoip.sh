#!/bin/bash
base=https://download.maxmind.com/download/geoip/database
wget $base/GeoLiteCountry/GeoIP.dat.gz -O GeoIP.dat.gz
gzip -d GeoIP.dat.gz
wget $base/asnum/GeoIPASNum.dat.gz -O GeoIPASNum.dat.gz
gzip -d GeoIPASNum.dat.gz
mv GeoIP.dat GeoIPASNum.dat ../ooniprobe/Resources/
