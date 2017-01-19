//#include "./nkf_bridge.c"


#ifdef __linux__
#include "CFHeader.h"

uint8_t* cf_nkf_convert(CFDataRef src, CFDataRef optsString, CFIndex* outLength);
const char* cf_nkf_guess(CFDataRef src);

#else
#import <CoreFoundation/CoreFoundation.h>
CF_EXPORT uint8_t* cf_nkf_convert(__nonnull CFDataRef src, __nonnull CFDataRef optsString,  CFIndex* _Nonnull  outLength);
CF_EXPORT CF_RETURNS_RETAINED const char* _Nullable  cf_nkf_guess(__nonnull CFDataRef src);

#endif
