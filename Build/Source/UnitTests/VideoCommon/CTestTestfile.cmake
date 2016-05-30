# CMake generated Testfile for 
# Source directory: /Users/willcobb/Dropbox/Xcode/dolphin-emu/Source/UnitTests/VideoCommon
# Build directory: /Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Source/UnitTests/VideoCommon
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
if("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
  add_test(VertexLoaderTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/VertexLoaderTest")
elseif("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
  add_test(VertexLoaderTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/VertexLoaderTest")
elseif("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
  add_test(VertexLoaderTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/VertexLoaderTest")
elseif("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
  add_test(VertexLoaderTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/VertexLoaderTest")
else()
  add_test(VertexLoaderTest NOT_AVAILABLE)
endif()
