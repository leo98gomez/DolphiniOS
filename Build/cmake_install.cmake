# Install script for directory: /Users/willcobb/Dropbox/Xcode/dolphin-emu

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/share/dolphin-emu/sys/")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/share/dolphin-emu/sys" TYPE DIRECTORY FILES "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Data/Sys/")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/Bochs_disasm/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/enet/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/xxhash/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/LZO/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/libpng/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/soundtouch/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/SFML/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/mbedtls/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/SOIL/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Externals/gtest/cmake_install.cmake")
  include("/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/Source/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/Users/willcobb/Dropbox/Xcode/dolphin-emu/Build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
