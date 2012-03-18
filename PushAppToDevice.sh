#!/bin/sh
#
#
# This script will love an hacked up /usr/bin/codesign that always return 0... That way the build don't fail with Xcode.
#
# Define the device'ip and app to install on the device + path to app
REMOTEHOST=192.168.0.183
APPNAME=Calculator
# Old things had to go away... XCODEAPPPATH=/Users/louis/Library/Developer/Xcode/DerivedData/Calculator-eexldvdtzdmfixcpnjljpgszhdcc/Build/Products/Debug-iphoneos/
XCODEAPPPATH=/Users/louis/Xcode/STANFORD iOS lesson/Calculator/build/Release-iphoneos/
cd $XCODEAPPPATH
rm $APPNAME.zip
zip -or $APPNAME.zip $APPNAME.app
scp $APPNAME.zip root@$REMOTEHOST:/Applications
ssh root@$REMOTEHOST "killall $APPNAME, cd /Applications, rm -rf $APPNAME.app, unzip $APPNAME.zip, ldid -S $APPNAME.app/$APPNAME, chmod +x $APPNAME.app/$APPNAME, killall SpringBoard "