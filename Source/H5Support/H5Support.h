/* This file is auto generated. DO NOT EDIT THIS FILE. Edit the original template file and then rerun CMake
 * again to regenerate this file.
 */

#pragma once

/* Define the namespace we are going to use for the H5Support Codes */
/* #undef H5Support_NAMESPACE */

/* Define if H5Support is using Qt classes in addition to STL classes */
/* #undef H5Support_USE_QT */

/* Include the DLL export preprocessor defines */
#define H5Support_EXPORT

/* We are going to disable some warnings just to get a grip on all the warnings that get produced
 * during an MSVC build */
/* #undef H5Support_DISABLE_MSVC_WARNINGS */

#define H5Support_USE_MUTEX

#ifdef H5Support_USE_MUTEX
#include <mutex>
#define H5SUPPORT_MUTEX_LOCK()                                                                                                                                                                         \
  std::mutex mutex;                                                                                                                                                                                    \
  std::lock_guard<std::mutex> lock(mutex);
#else
#define H5SUPPORT_MUTEX_LOCK()
#endif

#if(_MSC_VER >= 1)
#pragma warning(error : 4715) /* Not all control points return a value */

#ifdef H5Support_DISABLE_MSVC_WARNINGS
#pragma warning(disable : 4244)
#pragma warning(disable : 4267)
#pragma warning(disable : 4305)

#pragma warning(disable : 4251)
#pragma warning(disable : 4710)
#pragma warning(disable : 4820)
#pragma warning(disable : 4668)
#pragma warning(disable : 4265)
#pragma warning(disable : 4189)
#pragma warning(disable : 4640)
#pragma warning(disable : 4996)
#pragma warning(disable : 4548)
#endif
#endif