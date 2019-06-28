function(TargetCopyInstall)
  set(options COPY INSTALL)
  set(oneValueArgs NAME TARGET)
  set(multiValueArgs)
  cmake_parse_arguments(Z "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(APPLE)
    return()
  endif()

  if(MSVC_IDE)
    set(BUILD_TYPES Debug Release)
  else()
    set(BUILD_TYPES "${CMAKE_BUILD_TYPE}")
    if("${BUILD_TYPES}" STREQUAL "")
        set(BUILD_TYPES "Debug")
    endif()
  endif()

  set(INTER_DIR ".")

  set(INSTALL_DIR "lib")
  if(WIN32)
    set(INSTALL_DIR ".")
  endif()

  foreach(TYPE ${BUILD_TYPES})
    string(TOUPPER ${TYPE} TYPE_UPPER)
    if(MSVC_IDE)
      set(INTER_DIR "${TYPE}")
    endif()
    get_target_property(LIB_PATH ${Z_TARGET} IMPORTED_LOCATION_${TYPE_UPPER})
    
    if(Z_COPY)
      if(NOT "${LIB_PATH}" STREQUAL "LIB_PATH-NOTFOUND")
        if(NOT TARGET ZZ_${Z_NAME}_DLL_${TYPE}-Copy)
          add_custom_target(ZZ_${Z_NAME}_DLL_${TYPE}-Copy ALL
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIB_PATH}
            ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${INTER_DIR}/
          )
          set_target_properties(ZZ_${Z_NAME}_DLL_${TYPE}-Copy PROPERTIES FOLDER ZZ_COPY_FILES/${TYPE}/${Z_NAME})
        endif()
      endif()
    endif()

    if(Z_INSTALL)
      if(NOT "${LIB_PATH}" STREQUAL "LIB_PATH-NOTFOUND")
        install(FILES ${LIB_PATH} DESTINATION ${INSTALL_DIR} CONFIGURATIONS ${TYPE} COMPONENT Applications)
      endif()  
    endif()
  endforeach()
endfunction()
