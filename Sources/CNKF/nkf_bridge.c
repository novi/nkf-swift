#include "include/CFHeader.h"
#include "include/nkf_bridge.h"

#ifndef CF_NKF_H
#define CF_NKF_H

#define CNKF_MAX(a,b) \
({ __typeof__ (a) _a = (a); \
__typeof__ (b) _b = (b); \
_a > _b ? _a : _b; })

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

void* cf_nkf_realloc_copy(void* ptr, CFIndex newSize)
{
    void* reallocatedPtr = realloc(ptr, newSize);
    assert(reallocatedPtr);
    //printf("reallocated %lld, %lld\n", newSize, output_ctr);
    return reallocatedPtr;
}

static int
cf_nkf_putchar(unsigned int c)
{
    if (outputPtr == NULL) return c; // for guess, outputPtr should be NULL
    
    if (output_ctr+1 >= outputPtrCapacity) {
        outputPtr = cf_nkf_realloc_copy(outputPtr, incsize);
        outputPtrCapacity = incsize;
        if (incsize < 1024*1000*1000) {
            incsize *= 2;
        } else {
            incsize = ((double)incsize) * 1.25;
        }
    }
    outputPtr[output_ctr++] = c;
    return c;
}

#define PERL_XS 1

#include "../c_nkf/config.h"
#include "../c_nkf/utf8tbl.c"
#include "../c_nkf/nkf.c"

CF_EXPORT uint8_t* cf_nkf_convert(const uint8_t* src, size_t srcLength, const char* opts, CFIndex* outLength)
{
    
    reinit();
    
    options((unsigned char*)opts);
    
    input_ctr = 0;
    input = src;
    i_len = srcLength;
    
    // initial outout buffer size
    outputPtrCapacity = CNKF_MAX(i_len * 2, INCSIZE);
    incsize = outputPtrCapacity;
    outputPtr = malloc(outputPtrCapacity);
    assert(outputPtr);
    
    output_ctr = 0;
    *outputPtr = '\0';
    
    kanji_convert(NULL);
    
    cf_nkf_putchar('\0');
    *outLength = output_ctr;
    
    return outputPtr;
}

CF_EXPORT const char* cf_nkf_guess(const uint8_t* src, size_t srcLength)
{
    reinit();
    incsize = INCSIZE;
    
    input_ctr = 0;
    input = src;
    i_len = srcLength;
    
    outputPtr = NULL; // no output data
    outputPtrCapacity = 0;
    
    kanji_convert(NULL);
    
    return get_guessed_code();
}


#endif

