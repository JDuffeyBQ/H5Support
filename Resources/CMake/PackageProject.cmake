# ------------------------------------------------------------------------------
# This CMake code sets up for CPack to be used to generate native installers
# ------------------------------------------------------------------------------

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "H5Support")
set(CPACK_PACKAGE_VENDOR "BlueQuartz Software, LLC")

# Create an ZIP based installer for Windows Systems
if(WIN32 AND NOT UNIX)
  # There is a bug in NSIS that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backlasshes.
  SET(CPACK_NSIS_DISPLAY_NAME "H5Support Software Tools")
  SET(CPACK_NSIS_MODIFY_PATH ON)
  SET(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "H5Support Software Tools")
endif()

if(APPLE)
  set(CPACK_GENERATOR "ZIP")
  option(CPACK_BINARY_DRAGNDROP    "Enable to build DMG packages"     OFF)
  option(CPACK_BINARY_TGZ  "Enable to build TGZ packages"     OFF)
  option(CPACK_BINARY_ZIP  "Enable to build ZIP packages"     ON)
endif()

#set(CPACK_GENERATOR "")
if(NOT CPACK_GENERATOR)
  if(UNIX)
      if(APPLE)
        option(CPACK_BINARY_PACKAGEMAKER "Enable to build PackageMaker packages" OFF)
        option(CPACK_BINARY_OSXX11       "Enable to build OSX X11 packages"      OFF)
        option(CPACK_BINARY_DRAGNDROP    "Enable to build DMG packages"     OFF)
      else()
        option(CPACK_BINARY_TZ  "Enable to build TZ packages"     OFF)
        option(CPACK_BINARY_TGZ  "Enable to build TGZ packages"   ON)
      endif()
      option(CPACK_BINARY_STGZ "Enable to build STGZ packages"    OFF)
      option(CPACK_BINARY_TBZ2 "Enable to build TBZ2 packages"    OFF)
      option(CPACK_BINARY_DEB  "Enable to build Debian packages"  OFF)
      option(CPACK_BINARY_RPM  "Enable to build RPM packages"     OFF)
      option(CPACK_BINARY_NSIS "Enable to build NSIS packages"    OFF)
      option(CPACK_BINARY_ZIP  "Enable to build ZIP packages"     OFF)
  else()
    option(CPACK_BINARY_NSIS "Enable to build NSIS packages" OFF)
    option(CPACK_BINARY_ZIP  "Enable to build ZIP packages" ON)
  endif()
endif()

set(CPACK_SOURCE_GENERATOR "TGZ")

set(CPACK_SOURCE_TOPLEVEL_TAG "Source")
set(CPACK_IGNORE_FILES "/i386/;/x64/;/VS2008/;/zRel/;/Build/;/\\\\.git/;\\\\.*project")
set(CPACK_SOURCE_IGNORE_FILES "/i386/;/x64/;/VS2008/;/zRel/;/Build/;/\\\\.git/;\\\\.*project")

# THIS MUST BE THE LAST LINE OF THIS FILE BECAUSE ALL THE CPACK VARIABLES MUST BE
# DEFINED BEFORE CPack IS INCLUDED
include(CPack)
