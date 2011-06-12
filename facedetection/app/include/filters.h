#ifndef _filters_h_
#define _filters_h_

#include "image.h"

#define FILTER_ERODE   0x01
#define FILTER_DILATE  0x00

#define COMPUTE_LINE 4
#define COMPUTE_COLUMN 4

void skinFilter(image_t *inputImage, bit_image_t *outputImage);
void erodeDilateFilter(bit_image_t *inputImage, bit_image_t *outputImage, uint8_t op);
void dilateFilter(bit_image_t *inputImage, bit_image_t *outputImage);


#endif // _filters_h_
