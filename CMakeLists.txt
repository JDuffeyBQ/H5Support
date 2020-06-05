cmake_policy(SET CMP0002 NEW)
cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0079 NEW)
cmake_policy(SET CMP0077 NEW)

cmake_minimum_required(VERSION 3.14)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project(H5Support LANGUAGES C CXX VERSION 1.0.0.0)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(H5Support_USE_MUTEX "Use mutex in functions" ON)
option(H5Support_ENABLE_NAMESPACE "Wrap all code in namespace \"H5Support\"" OFF)

set(H5Support_USER_NAMESPACE "H5Support" CACHE STRING "Namespace for H5Support")

option(H5Support_INCLUDE_QT_API "Include support for using Qt classes with H5Lite" ON)

find_package(HDF5 NAMES hdf5 REQUIRED CONFIG)

add_library(H5Support INTERFACE)
add_library(H5Support::H5Support ALIAS H5Support)

target_compile_features(H5Support
  INTERFACE
    cxx_std_14
)

if(H5Support_INCLUDE_QT_API)
  target_compile_definitions(H5Support INTERFACE H5Support_USE_QT)
endif()

if(H5Support_ENABLE_NAMESPACE)
  target_compile_definitions(H5Support INTERFACE H5Support_NAMESPACE=${H5Support_USER_NAMESPACE})
endif()

if(H5Support_USE_MUTEX)
  target_compile_definitions(H5Support INTERFACE H5Support_USE_MUTEX)
endif()

set(H5Support_HDRS
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5Lite.h
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5Utilities.h
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5ScopedSentinel.h
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5ScopedErrorHandler.h
  ${H5Support_SOURCE_DIR}/Source/H5Support/H5Macros.h
)

if(H5Support_USE_QT)
  list(APPEND H5Support_HDRS
    ${H5Support_SOURCE_DIR}/Source/H5Support/QH5Lite.h
    ${H5Support_SOURCE_DIR}/Source/H5Support/QH5Utilities.h
  )
endif()

target_sources(H5Support
  INTERFACE
    ${H5Support_HDRS}
)

source_group("H5Support" FILES ${H5Support_HDRS})

target_include_directories(H5Support
  INTERFACE
    $<BUILD_INTERFACE:${H5Support_SOURCE_DIR}/Source>
)

include(${H5Support_SOURCE_DIR}/Resources/CMake/TargetCopyInstall.cmake)

option(H5Support_INSTALL_HDF5 "Enable install of HDF5 dlls" OFF)
option(H5Support_INSTALL_QT5 "Enable install of Qt5 dlls" OFF)

set(HDF5_RULES COPY)
if(H5Support_INSTALL_HDF5)
  list(APPEND HDF5_RULES " " INSTALL)
endif()

#TargetCopyInstall(${HDF5_RULES} NAME "hdf5" TARGET hdf5::hdf5-shared)

set(H5Support_Link_Libs hdf5::hdf5-shared)
if(H5Support_USE_QT)
  set(QT5_RULES COPY)
  if(H5Support_INSTALL_QT5)
    list(APPEND QT5_RULES " " INSTALL)
  endif()
  find_package(Qt5 COMPONENTS Core REQUIRED)
  #TargetCopyInstall(${QT5_RULES} NAME "Qt5Core" TARGET Qt5::Core)
  list(APPEND H5Support_Link_Libs Qt5::Core)
endif()

target_link_libraries(H5Support
  INTERFACE
    ${H5Support_Link_Libs}
)

export(TARGETS H5Support
  NAMESPACE H5Support::
  FILE ${H5Support_BINARY_DIR}/H5SupportTargets.cmake
)

option(H5Support_BUILD_TESTING "Build H5Support tests" OFF)

if(H5Support_BUILD_TESTING)
  include(${H5Support_SOURCE_DIR}/Test/CMakeLists.txt)
endif()
