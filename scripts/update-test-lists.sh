#!/bin/bash
for i in $(ls ooniprobe/Resources/test-lists/); do wget -q "https://raw.githubusercontent.com/citizenlab/test-lists/master/lists/$i" -O "ooniprobe/Resources/test-lists/$i"; done
