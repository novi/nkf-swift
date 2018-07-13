//#include "./nkf_bridge.c"


#ifdef __linux__
#ifndef CF_EXPORT
#define CF_EXPORT extern
#include <assert.h>
#endif
#include "CFHeader.h"
#else
#import <CoreFoundation/CoreFoundation.h>
#endif

CF_EXPORT uint8_t* cf_nkf_convert(const uint8_t* src, size_t srcLength, const char* opts, CFIndex* outLength);
CF_EXPORT const char* cf_nkf_guess(const uint8_t* src, size_t srcLength);
