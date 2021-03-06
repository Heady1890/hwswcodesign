#ifndef _image_h_
#define _image_h_

#include <stdint.h>

typedef struct {
  uint8_t r;
  uint8_t g;
  uint8_t b;
} rgb_color_t;

typedef struct {
  int y;
  int cb;
  int cr;
} ycbcr_color_t;

//allokiert bei 640x480 921,6kB Speicher
typedef struct {
  uint16_t width;
  uint16_t height;
  uint32_t dataLength;
  //unsigned char *data;
  uint8_t *data;
} image_t;

//allokiert bei 640x480 38,3kB Speicher
typedef struct {
  uint16_t width;
  uint16_t height;
  uint8_t *data;
} bit_image_t;

rgb_color_t getRGBColorValue(image_t *i, int pIndex);
ycbcr_color_t getYCbCrColorValue(image_t *i, int pIndex);

#endif // _image_h_
