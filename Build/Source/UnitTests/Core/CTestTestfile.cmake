# CMake generated Testfile for 
# Source directory: /Users/willcobb/Dropbox/Xcode/dolphin-emu/Source/UnitTests/Core
# Build directory: /Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Source/UnitTests/Core
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
if("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
  add_test(MMIOTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/MMIOTest")
elseif("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
  add_test(MMIOTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/MMIOTest")
elseif("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
  add_test(MMIOTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/MMIOTest")
elseif("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
  add_test(MMIOTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/MMIOTest")
else()
  add_test(MMIOTest NOT_AVAILABLE)
endif()
if("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
  add_test(PageFaultTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/PageFaultTest")
elseif("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
  add_test(PageFaultTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/PageFaultTest")
elseif("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
  add_test(PageFaultTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/PageFaultTest")
elseif("${CTEST_CONFIGURATION_TYPE}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
  add_test(PageFaultTest "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Binaries/Tests/PageFaultTest")
else()
  add_test(PageFaultTest NOT_AVAILABLE)
endif()
