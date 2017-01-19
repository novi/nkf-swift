//
//  CFHeader.h
//  CNKF
//
//  Created by Yusuke Ito on 6/16/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

#ifndef CFHeader_h
#define CFHeader_h

#ifdef __linux__
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

// for 64bit

typedef void* CFDataRef;
typedef void* CFMutableDataRef;
typedef void* CFAllocatorRef;

typedef signed long long CFIndex;

CFIndex CFDataGetLength(CFDataRef theData);
void CFRelease(void*);
const uint8_t *CFDataGetBytePtr(CFDataRef theData);

/* nullability */
#ifndef __nullable
#define __nullable
#endif

#ifndef __nonnull
#define __nonnull
#endif

#ifndef _Nonnull
#define _Nonnull
#endif

#ifndef __null_unspecified
#define __null_unspecified
#endif
/* nullability */

/* */
#ifndef CF_RETURNS_RETAINED
#define CF_RETURNS_RETAINED
#endif
/* */

#else
#include <CoreFoundation/CoreFoundation.h>
#endif /* Linux only */

#endif /* CFHeader_h */
