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

//#define CF_EXPORT extern

// for 64bit

typedef unsigned char           UInt8;

typedef void* CFDataRef;
typedef void* CFMutableDataRef;
typedef void* CFAllocatorRef;

typedef signed long long CFIndex;


CFMutableDataRef CFDataCreateMutable(CFAllocatorRef allocator, CFIndex capacity);
CFIndex CFDataGetLength(CFDataRef theData);
void CFDataIncreaseLength(CFMutableDataRef theData, CFIndex extraLength);
CFMutableDataRef CFDataCreateMutableCopy(CFAllocatorRef allocator, CFIndex capacity, CFDataRef theData);
void CFRelease(void*);
UInt8 *CFDataGetMutableBytePtr(CFMutableDataRef theData);
const UInt8 *CFDataGetBytePtr(CFDataRef theData);

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
