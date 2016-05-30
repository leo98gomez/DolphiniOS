#!/bin/sh
make -C $(SRCROOT)/Build/Source/UnitTests/VideoCommon -f $(SRCROOT)/Build/Source/UnitTests/VideoCommon/CMakeScripts/Test_VertexLoaderTest_preLinkCommands.make$CONFIGURATION all
