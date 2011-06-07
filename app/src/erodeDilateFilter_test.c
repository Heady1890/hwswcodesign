#include "filters.h"
#include "image.h"

#define WINDOW_LENGTH 5
#define WINDOW_OFFSET ((WINDOW_LENGTH-1)/2)
#define BACKGROUND_COLOR_R   0
#define BACKGROUND_COLOR_G   0
#define BACKGROUND_COLOR_B   0
#define FOREGROUND_COLOR_R   0xff
#define FOREGROUND_COLOR_G   0xff
#define FOREGROUND_COLOR_B   0xff


uint8_t checkPixel(image_t *inputImage, int pIndex, uint8_t check){
  uint8_t b=inputImage->data[pIndex];
  if(b==check)
  {
    return 0x01;
  }
  return 0x00;
}

void erodeDilateFilter(image_t *inputImage, image_t *outputImage, uint8_t op)
{
  int x, y, dx, dy, wx, wy;
  int pIndex=0, pIndex2=0;
  rgb_color_t c, compare;
  uint8_t foundMatch;

  if (op == FILTER_ERODE) {
    // erode: look for neighbor pixels in background color
    compare.r = BACKGROUND_COLOR_R;
    compare.g = BACKGROUND_COLOR_G;
    compare.b = BACKGROUND_COLOR_B;
  }
  else {
    // dilate: look for neighbor pixels in foreground color
    compare.r = FOREGROUND_COLOR_R;
    compare.g = FOREGROUND_COLOR_G;
    compare.b = FOREGROUND_COLOR_B;
  }

  for (y = 0; y < inputImage->height; ++y) {
    for (x = 0; x < inputImage->width; ++x) {  

      foundMatch = 0;
      pIndex = (y*inputImage->width+x)*3;  

      uint8_t temp = inputImage->data[pIndex];
      if(!(temp != compare.r)){
      for (dy = -WINDOW_OFFSET; dy <= WINDOW_OFFSET; ++dy) {
	wy = y+dy;
	if (wy >= 0 && wy < inputImage->height) {
          pIndex2=(wy*inputImage->width + (x-2))*3;
	  for (dx = -WINDOW_OFFSET; dx <= WINDOW_OFFSET; ++dx) {
	    wx = x+dx;
	    if (wx >= 0 && wx < inputImage->width && foundMatch == 0) {
	      c.b = inputImage->data[pIndex2];
	      c.g = inputImage->data[pIndex2 + 1];
	      c.r = inputImage->data[pIndex2 + 2];
	      if (c.r == compare.r && c.g == compare.g && c.b == compare.b) {
		foundMatch = 1;
		break;
	      }
              pIndex2+=3;
	    }
	  }
	}
	if (foundMatch) {
	  break;
	}
      }
      }

      if ((op == FILTER_ERODE && !foundMatch) ||
	  (op == FILTER_DILATE && foundMatch)) {
	// set output pixel white
	outputImage->data[pIndex] = 0xFF;
	outputImage->data[pIndex+1] = 0xFF;
	outputImage->data[pIndex+2] = 0xFF;
      }
      else{
        // default: set background color
        outputImage->data[pIndex] = 0x00;
        outputImage->data[pIndex+1] = 0x00;
        outputImage->data[pIndex+2] = 0x00;
      }

      //pIndex+=3;
    }
  }
}
