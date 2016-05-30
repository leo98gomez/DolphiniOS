#!/bin/sh
make -C $(SRCROOT)/Build/Source/UnitTests/Core -f $(SRCROOT)/Build/Source/UnitTests/Core/CMakeScripts/Test_PageFaultTest_preLinkCommands.make$CONFIGURATION all
