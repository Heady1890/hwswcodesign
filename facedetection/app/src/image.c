#include "image.h"

//obsolet
rgb_color_t getRGBColorValue(image_t *i, int pIndex)
{
  rgb_color_t result;
  //int pIndex = (y*i->width+x)*3;
  result.b = i->data[pIndex];
  result.g = i->data[pIndex+1];
  result.r = i->data[pIndex+2];
  return result;
}

ycbcr_color_t getYCbCrColorValue(image_t *i, int pIndex)
{  
  //rgb_color_t c1 = getRGBColorValue(i, pIndex);
  ycbcr_color_t result;

  int rf = (i->data[pIndex+2] * 1000)>>8;;
  int gf = (i->data[pIndex+1] * 1000)>>8;;
  int bf = (i->data[pIndex] * 1000)>>8;;

  result.y = 299000 * rf + 587000 * gf + 114000 * bf;
  result.cb = -168736 * rf + -331264 * gf + 500000 * bf;
  result.cr = 500000 * rf + -418688 * gf + -81312 * bf;

  return result;
}
