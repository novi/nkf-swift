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

static UInt8 *output;
static const UInt8 *input;

static CFIndex input_ctr;
static CFIndex i_len;

static CFIndex output_ctr;
static CFMutableDataRef outputData;

static CFIndex incsize = INCSIZE;

static int
cf_nkf_putchar(unsigned int c)
{
    if (outputData == NULL) return c;
    
    if (output_ctr >= CFDataGetLength(outputData)) {
        CFDataIncreaseLength(outputData, incsize);
        incsize *= 2;
    }
    output[output_ctr++] = c;
    
    return c;
}

#define PERL_XS 1

#include "nkf/config.h"
#include "nkf/utf8tbl.c"
#include "nkf/nkf.c"

#ifdef __linux__
 CF_RETURNS_RETAINED CFDataRef cf_nkf_convert(CFDataRef src, CFDataRef optsString,  CFIndex*  outLength)
#else
 CF_RETURNS_RETAINED __nonnull CFDataRef cf_nkf_convert(__nonnull CFDataRef src, __nonnull CFDataRef optsString,  CFIndex* _Nonnull  outLength)
#endif
{
    
    reinit();
    incsize = INCSIZE;
    
    CFMutableDataRef optsDataM = CFDataCreateMutableCopy(NULL, CFDataGetLength(optsString), optsString);
    options(CFDataGetMutableBytePtr(optsDataM));
    
    input_ctr = 0;
    input = CFDataGetBytePtr(src);
    i_len = CFDataGetLength(src);
    
    outputData = CFDataCreateMutable(NULL, i_len*3 + 10);
    output = CFDataGetMutableBytePtr(outputData);
    
    output_ctr = 0;
    *output    = '\0';
    
    kanji_convert(NULL);
    
    CFRelease(optsDataM);
    
    *outLength = output_ctr;
    
    return outputData;
}

#ifdef __linux__
CF_RETURNS_RETAINED const char* cf_nkf_guess(CFDataRef src)
#else
CF_RETURNS_RETAINED const char* cf_nkf_guess(__nonnull CFDataRef src)
#endif
{
    reinit();
    incsize = INCSIZE;
    
    input_ctr = 0;
    input = CFDataGetBytePtr(src);
    i_len = CFDataGetLength(src);
    
    outputData = NULL; // no output data
    
    kanji_convert(NULL);
    
    return get_guessed_code();
}


#endif

