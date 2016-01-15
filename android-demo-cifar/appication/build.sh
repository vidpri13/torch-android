#!/bin/sh
ndk-build
rm -rf assets/lua
mkdir -p assets/lua/share
cp -r ../../share assets/lua/
ant debug
if [ $? -ne 0 ]; then
    exit
fi
adb install -r bin/TorchDemo-debug.apk
if [ $? -ne 0 ]; then
    exit
fi
