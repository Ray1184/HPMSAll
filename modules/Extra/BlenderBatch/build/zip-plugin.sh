#!/bin/bash

if [ -d ../dist ]; then rm -Rf ../dist; fi
mkdir ../dist
zip -r ../dist/hpms-tools.zip ../addon/*.py
