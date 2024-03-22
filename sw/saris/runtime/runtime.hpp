#pragma once

// C linkage macros
#ifdef __cplusplus
#define EXTERN_C extern "C"
#define EXTERN_C_BEGIN extern "C" {
#define EXTERN_C_END }
#else
#define EXTERN_C
#define EXTERN_C_BEGIN
#define EXTERN_C_END
#endif

// Include C runtime, ignoring benign CXX-only warnings
EXTERN_C_BEGIN
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-register"
#include "runtime.h"
#pragma GCC diagnostic pop
EXTERN_C_END
