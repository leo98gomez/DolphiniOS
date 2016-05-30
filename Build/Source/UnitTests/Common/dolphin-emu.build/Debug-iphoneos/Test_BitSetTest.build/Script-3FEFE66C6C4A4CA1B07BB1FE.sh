#!/bin/sh
make -C $(SRCROOT)/Build/Source/UnitTests/Common -f $(SRCROOT)/Build/Source/UnitTests/Common/CMakeScripts/Test_BitSetTest_preLinkCommands.make$CONFIGURATION all
