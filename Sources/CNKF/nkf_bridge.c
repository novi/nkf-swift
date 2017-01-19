#include "include/CFHeader.h"

#ifndef CF_NKF_H
#define CF_NKF_H

#undef getc
#undef ungetc
#define getc(f)         (input_ctr>=i_len?-1:input[input_ctr++])
#define ungetc(c,f)     input_ctr--

#define INCSIZE         32

#undef putchar
#undef TRUE
#undef FALSE
#define putchar(c)      cf_nkf_putchar(c)

static const uint8_t *input;

static CFIndex input_ctr;
static CFIndex i_len;

static CFIndex output_ctr;
static uint8_t* outputPtr;
static size_t outputPtrCapacity;

static CFIndex incsize = 0;

void* cf_nkf_realloc_copy(void* ptr, unsigned int newSize)
{
    return realloc(ptr, newSize);
}

static int
cf_nkf_putchar(unsigned int c)
{
    if (outputPtr == NULL) return c;
    
    if (output_ctr >= outputPtrCapacity) {
        outputPtr = cf_nkf_realloc_copy(outputPtr, incsize);
        incsize *= 2;
    }
    outputPtr[output_ctr++] = c;
    
    return c;
}

#define PERL_XS 1

#include "nkf/config.h"
#include "nkf/utf8tbl.c"
#include "nkf/nkf.c"

#ifdef __linux__
uint8_t* cf_nkf_convert(CFDataRef src, CFDataRef optsString,  CFIndex*  outLength)
#else
uint8_t* cf_nkf_convert(__nonnull CFDataRef src, __nonnull CFDataRef optsString,  CFIndex* _Nonnull  outLength)
#endif
{
    
    reinit();
    incsize = INCSIZE;
    
    CFMutableDataRef optsDataM = CFDataCreateMutableCopy(NULL, CFDataGetLength(optsString), optsString);
    options(CFDataGetMutableBytePtr(optsDataM));
    
    input_ctr = 0;
    input = CFDataGetBytePtr(src);
    i_len = CFDataGetLength(src);
    
    outputPtrCapacity = i_len*3 + 10;
    outputPtr = malloc(outputPtrCapacity);
    
    output_ctr = 0;
    *outputPtr    = '\0';
    
    kanji_convert(NULL);
    
    CFRelease(optsDataM);
    
    *outLength = output_ctr;
    
    return outputPtr;
}

#ifdef __linux__
const char* cf_nkf_guess(CFDataRef src)
#else
CF_RETURNS_RETAINED const char* cf_nkf_guess(__nonnull CFDataRef src)
#endif
{
    reinit();
    incsize = INCSIZE;
    
    input_ctr = 0;
    input = CFDataGetBytePtr(src);
    i_len = CFDataGetLength(src);
    
    outputPtr = NULL; // no output data
    outputPtrCapacity = 0;
    
    kanji_convert(NULL);
    
    return get_guessed_code();
}


#endif

