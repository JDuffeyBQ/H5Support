cmake_minimum_required(VERSION 3.12)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_EXTENSIONS False)

project(H5Support LANGUAGES C CXX VERSION 1.0.0.0)

# ---------- Setup output Directories -------------------------
if(NOT DEFINED CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY
    ${H5Support_BINARY_DIR}/Bin
    CACHE PATH
    "Single Directory for all Libraries"
  )
endif()

# --------- Setup the Executable output Directory -------------
if(NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
    ${H5Support_BINARY_DIR}/Bin
    CACHE PATH
    "Single Directory for all Executables."
  )
endif()

# --------- Setup the Executable output Directory -------------
if(NOT DEFINED CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY
    ${H5Support_BINARY_DIR}/Bin
    CACHE PATH
    "Single Directory for all static libraries."
  )
endif()

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(H5Support_DISABLE_MSVC_WARNINGS "Disable some MSVC warnings" OFF)
option(H5Support_USE_MUTEX "Use mutex in functions" ON)
option(H5Support_ENABLE_NAMESPACE "Wrap all code in namespace \"H5Support\"" OFF)

set(H5Support_USER_NAMESPACE "H5Support" CACHE STRING "Namespace for H5Support")

if(H5Support_ENABLE_NAMESPACE)
  set(H5Support_NAMESPACE ON)
endif()

get_filename_component(H5Support_PARENT ${H5Support_SOURCE_DIR} DIRECTORY CACHE)

#------------------------------------------------------------------------------
# If the developer has set another CMP directory then use that, otherwise look
# for the CMP directory at the same level as the SIMPL directory
if("${CMP_SOURCE_DIR}" STREQUAL "")
  if(EXISTS "${H5Support_SOURCE_DIR}/ExternalProjects/CMP")
    set(CMP_SOURCE_DIR "${H5Support_SOURCE_DIR}/ExternalProjects/CMP")
  elseif(EXISTS "${H5Support_PARENT}/CMP")
    set(CMP_SOURCE_DIR ${H5Support_PARENT}/CMP)
  else()
    message(FATAL_ERROR "CMP_SOURCE_DIR was not set. Where is the CMP project directory. Please set the CMP_SOURCE_DIR variable to the CMP directory.")
  endif()
  message(STATUS "CMP_SOURCE_DIR: ${CMP_SOURCE_DIR}")
endif()

option(CMP_HDF5_ENABLE_INSTALL "Add install rules for HDF5" OFF)
option(CMP_QT5_ENABLE_INSTALL "Add install rules for Qt5" OFF)

include(${CMP_SOURCE_DIR}/ExtLib/HDF5Support.cmake)

option(H5Support_INSTALL_FILES "Install as lib" OFF)

option(BUILD_SHARED_LIBS "Build as shared library" ON)

#-------------------------------------------------------------------------------
# Set our H5Lite codes to also compile the Qt API version of H5Lite
#-------------------------------------------------------------------------------
set(H5Support_USE_QT 0)
option(H5Support_INCLUDE_QT_API "Include support for using Qt classes with H5Lite" OFF)
if(H5Support_INCLUDE_QT_API)
  set(H5Support_USE_QT 1)
endif()

if(H5Support_INCLUDE_QT_API)
  include(${CMP_SOURCE_DIR}/ExtLib/Qt5Support.cmake)
  set(H5Support_USE_QtWebEngine FALSE)
  set(H5Support_Qt5_Components Core)
  CMP_AddQt5Support(  "${H5Support_Qt5_Components}"
                      "${H5Support_USE_QtWebEngine}"
                      "${H5Support_BINARY_DIR}"
                      "H5Support")
endif()

set(H5Support_GENERATED_DIR "H5Support")

set(H5Support_TOP_HEADER_FILE ${PROJECT_NAME}.h)
set(H5Support_VERSION_HEADER_FILE ${PROJECT_NAME}Version.h)

#-------------------------------------------------------------------------------
# Include the cmp project to perform all the basic configuration tests for the
# project.
#-------------------------------------------------------------------------------
set(CMP_HEADER_DIR ${${PROJECT_NAME}_BINARY_DIR}/${H5Support_GENERATED_DIR})
set(CMP_CONFIGURATION_FILE_NAME "${PROJECT_NAME}Configuration.h")
set(CMP_EXPORT_FILE_NAME "${PROJECT_NAME}DLLExport.h")
set(CMP_TYPES_FILE_NAME "${PROJECT_NAME}Types.h")
set(CMP_VERSION_HEADER_FILE_NAME "${H5Support_GENERATED_DIR}/${PROJECT_NAME}Version.h")
set(CMP_VERSION_SOURCE_FILE_NAME "${H5Support_GENERATED_DIR}/${PROJECT_NAME}Version.cpp")
set(CMP_TOP_HEADER_FILE "${H5Support_GENERATED_DIR}/${H5Support_TOP_HEADER_FILE}")
set(CMP_PROJECT_NAMESPACE "${PROJECT_NAME}")
set(CMP_PROJECT_NAME "${PROJECT_NAME}")
set(CMP_ENABLE_PLUGINS "0")
set(CMP_LIB_SEARCH_DIRS "")
set(CMP_GENERATE_VERSION_STRING 1)

if(H5Support_INCLUDE_QT_API)
  set(CMP_STRING_CLASS "QString")
  set(CMP_STRING_INCLUDE "<QtCore/QString>")
else()
  set(CMP_STRING_CLASS "std::string")
  set(CMP_STRING_INCLUDE "<string>")
endif()

set(PROJECT_INSTALL_HEADERS "${H5Support_INSTALL_FILES}")

include(${CMP_SOURCE_DIR}/cmpProject.cmake)

set(H5Support_SRCS
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5Lite.cpp
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5Utilities.cpp
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5ScopedSentinel.cpp
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5ScopedErrorHandler.cpp
)

set(H5Support_HDRS
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5Lite.h
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5Utilities.h
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5ScopedSentinel.h
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5ScopedErrorHandler.h
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5Macros.h
)

if(H5Support_USE_QT)
  set(H5Support_SRCS
    ${H5Support_SRCS}
    ${H5Support_SOURCE_DIR}/Source/H5Support/QH5Lite.cpp
    ${H5Support_SOURCE_DIR}/Source/H5Support/QH5Utilities.cpp
  )
  set(H5Support_HDRS
    ${H5Support_HDRS}
    ${H5Support_SOURCE_DIR}/Source/H5Support/QH5Lite.h
    ${H5Support_SOURCE_DIR}/Source/H5Support/QH5Utilities.h
  )
endif()

#---------------------------------
# Now configure the main header file.
configure_file(${H5Support_SOURCE_DIR}/Resources/CMake/H5Support.h.in
               ${H5Support_BINARY_DIR}/${CMP_TOP_HEADER_FILE}
)

cmp_IDE_SOURCE_PROPERTIES("H5Support" "${H5Support_HDRS}" "${H5Support_SRCS}" "0")

set(H5Support_GENERATED_HEADERS
  ${H5Support_BINARY_DIR}/${CMP_VERSION_HEADER_FILE_NAME}
  ${CMP_HEADER_DIR}/${CMP_TYPES_FILE_NAME}
  ${H5Support_BINARY_DIR}/${CMP_TOP_HEADER_FILE}
  ${CMP_HEADER_DIR}/${CMP_CONFIGURATION_FILE_NAME}
)

set(H5Support_GENERATED_SOURCES
  ${H5Support_BINARY_DIR}/${CMP_VERSION_SOURCE_FILE_NAME}
)

set(PROJECT_SRCS
  ${H5Support_SRCS}
  ${H5Support_HDRS}
  ${H5Support_GENERATED_HEADERS}
  ${H5Support_GENERATED_SOURCES}
)

set(EXE_DEBUG_EXTENSION "_d")

set(LIB_TYPE STATIC)
if(BUILD_SHARED_LIBS)
  set(LIB_TYPE SHARED)
endif()

add_library(${PROJECT_NAME} ${LIB_TYPE} ${PROJECT_SRCS})
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
CMP_AddDefinitions(TARGET ${PROJECT_NAME})
LibraryProperties(${PROJECT_NAME} ${EXE_DEBUG_EXTENSION})

target_include_directories(${PROJECT_NAME}
  PUBLIC
    $<INSTALL_INTERFACE:include>
    $<BUILD_INTERFACE:${H5Support_SOURCE_DIR}/Source>
    $<BUILD_INTERFACE:${H5Support_BINARY_DIR}>
)

set(H5Support_EXPORT_FILE_NAME ${H5Support_BINARY_DIR}/H5Support/H5SupportDLLExport.h)

set(EXPORT_HEADER_MESSAGE "// This file is auto generated. DO NOT EDIT THIS FILE. Changes will be lost on CMake rerun.")

include(GenerateExportHeader)
generate_export_header(${PROJECT_NAME}
  EXPORT_FILE_NAME ${H5Support_EXPORT_FILE_NAME}
  EXPORT_MACRO_NAME "${PROJECT_NAME}_EXPORT"
  DEPRECATED_MACRO_NAME "${PROJECT_NAME}_DEPRECATED"
  NO_EXPORT_MACRO_NAME "${PROJECT_NAME}_NO_EXPORT"
  INCLUDE_GUARD_NAME "${PROJECT_NAME}_DLL_EXPORT_H"
  STATIC_DEFINE "${PROJECT_NAME}_STATIC_DEFINE"
  NO_DEPRECATED_MACRO_NAME "${PROJECT_NAME}_NO_DEPRECATED"
  CUSTOM_CONTENT_FROM_VARIABLE EXPORT_HEADER_MESSAGE
)

target_sources(${PROJECT_NAME}
  PRIVATE
    ${H5Support_EXPORT_FILE_NAME}
)

list(APPEND H5Support_GENERATED_HEADERS ${H5Support_EXPORT_FILE_NAME})

cmp_IDE_GENERATED_PROPERTIES("Generated" "${H5Support_GENERATED_HEADERS}" "${H5Support_GENERATED_SOURCES}")

set(H5Support_Link_Libs ${HDF5_C_TARGET_NAME})
if(H5Support_USE_QT)
  set(H5Support_Link_Libs ${H5Support_Link_Libs} Qt5::Core)
endif()

target_link_libraries(${PROJECT_NAME} 
  PUBLIC
    ${H5Support_Link_Libs}
)

set(install_dir "bin")
set(lib_install_dir "lib")

if(APPLE)
  get_property(H5Support_PACKAGE_DEST_PREFIX GLOBAL PROPERTY H5Support_PACKAGE_DEST_PREFIX)
  set(install_dir "${H5Support_PACKAGE_DEST_PREFIX}bin")
  set(lib_install_dir "${H5Support_PACKAGE_DEST_PREFIX}lib")
elseif(WIN32)
  if(H5Support_INSTALL_FILES)
    set(install_dir "bin")
    set(lib_install_dir "bin")
  else()
    set(install_dir ".")
    set(lib_install_dir ".")
  endif()
endif()

install(TARGETS ${PROJECT_NAME}
    EXPORT H5SupportTargets
    COMPONENT Applications
    RUNTIME DESTINATION ${install_dir}
    LIBRARY DESTINATION ${lib_install_dir}
    ARCHIVE DESTINATION lib
    BUNDLE DESTINATION "."
)

set(ConfigPackageLocation cmake/${PROJECT_NAME})

# --------------------------------------------------------------------
# Allow the generation and installation of a CMake configuration file
# which makes using H5Support from another project easier.
# --------------------------------------------------------------------
export(EXPORT H5SupportTargets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}Targets.cmake"
  NAMESPACE H5Support::
)

if(H5Support_INSTALL_FILES)
  install(EXPORT H5SupportTargets
    FILE
      ${PROJECT_NAME}Targets.cmake
    NAMESPACE
      ${PROJECT_NAME}::
    DESTINATION
      ${ConfigPackageLocation}
  )

  configure_file(${H5Support_SOURCE_DIR}/Resources/CMake/H5SupportConfig.cmake.in H5SupportConfig.cmake @ONLY)

  install(FILES
      ${H5Support_BINARY_DIR}/H5SupportConfig.cmake
    DESTINATION cmake/H5Support
  )

  install(FILES 
      ${H5Support_HDRS}
      ${H5Support_GENERATED_HEADERS}
    DESTINATION
      include/${PROJECT_NAME}
  )
endif()

option(H5Support_BUILD_TESTING "Build H5Support tests" OFF)

# ------- Enable the CTest testing. ---------------
# -------------------------------------------------------------------- 
# If Testing is enabled, turn on the Unit Tests 
if(H5Support_BUILD_TESTING)
    include(${H5Support_SOURCE_DIR}/Test/CMakeLists.txt)
endif()

include(${H5Support_SOURCE_DIR}/Resources/CMake/PackageProject.cmake)
