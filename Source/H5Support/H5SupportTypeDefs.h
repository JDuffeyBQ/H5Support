#pragma once

#include <cstdint>

/**
 * @brief This used as a way to not have to include <hdf5.h> in a header file if
 * the code is just using hid_t.
 */
using hid_t = int64_t;
using herr_t = int32_t;
