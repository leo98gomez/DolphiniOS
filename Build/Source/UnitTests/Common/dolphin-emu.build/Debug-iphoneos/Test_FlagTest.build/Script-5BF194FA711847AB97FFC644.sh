#!/bin/sh
make -C $(SRCROOT)/Build/Source/UnitTests/Common -f $(SRCROOT)/Build/Source/UnitTests/Common/CMakeScripts/Test_FlagTest_preLinkCommands.make$CONFIGURATION all
