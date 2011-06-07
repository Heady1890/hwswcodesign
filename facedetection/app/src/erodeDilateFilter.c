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

uint8_t checkWindow(image_t *inputImage, int x, int y, uint8_t comp){
  int dx,dy, wx, wy;
  int pIndex=0, pIndex2=0;
  rgb_color_t c, compare;
  compare.r = compare.g = compare.b = comp;

  for (dy = -WINDOW_OFFSET; dy <= WINDOW_OFFSET; ++dy) {
    wy = y+dy;
      if (wy >= 0 && wy < inputImage->height) {
        pIndex2=(wy*inputImage->width + (x-2))*3;
	for (dx = -WINDOW_OFFSET; dx <= WINDOW_OFFSET; ++dx) {
	  wx = x+dx;
	  if (wx >= 0 && wx < inputImage->width) {
	    c.b = inputImage->data[pIndex2];
	    c.g = inputImage->data[pIndex2 + 1];
	    c.r = inputImage->data[pIndex2 + 2];
	    if (c.r == compare.r && c.g == compare.g && c.b == compare.b) {
	      return 0x01;
	    }
            pIndex2+=3;
	  }
        }
      }
    }
    return 0x00;
}

void erodeDilateFilter(image_t *inputImage, bit_image_t *outputImage, uint8_t op)
{
  int x, y, dx, dy, wx, wy;
  rgb_color_t c, compare;
  uint8_t foundMatch;

  //Index des Bytes wo Information gesetzt wird
  uint16_t bpIndex=0;
  uint16_t bpIndex2=0;
  //Index innerhalb eines Bytes, welches Bit gesetzt wird.
  uint16_t byteIndex=0;
  uint16_t byteIndex2=0;

  for (y = 0; y < inputImage->height; ++y) {
    for (x = 0; x < inputImage->width; ++x) {  

      foundMatch = 0;
      
      //if((op == FILTER_ERODE && c.r == 0xff)||op == FILTER_DILATE)
      //foundMatch = checkWindow(inputImage,x,y,compare.r);
      //if(c.r == FOREGROUND_COLOR_R){
      for (dy = -WINDOW_OFFSET; dy <= WINDOW_OFFSET; ++dy) {
	wy = y+dy;
	if (wy >= 0 && wy < inputImage->height) {
          bpIndex2=((x-2)*dy)>>8;
          byteIndex2=((x-2)*dy)%8;
	  for (dx = -WINDOW_OFFSET; dx <= WINDOW_OFFSET; ++dx) {
	    wx = x+dx;
	    if (wx >= 0 && wx < inputImage->width && foundMatch == 0) {
              uint8_t op2 = inputImage->data[pIndex2];
	      if (op2 == op) {
		foundMatch = 1;
		break;
	      }
              byteIndex2++;
	      if(byteIndex2>=9){
		byteIndex2=0;
		bpIndex2++;
	      }
	    }
	  }
	}
	if (foundMatch) {
	  break;
	}
      }
      //}

      if ((op == FILTER_ERODE && !foundMatch) ||
	  (op == FILTER_DILATE && foundMatch)) {
	// set output pixel white
	outputImage->data[bwpIndex] |= (1<<byteIndex);
      }
      else{
        // default: set background color
        outputImage->data[bwpIndex] &= ~(1<<byteIndex);
      }

      //pIndex+=3;

      byteIndex++;
      if(byteIndex>=9){
        byteIndex=0;
        bpIndex++;
      }
    }
  }
}
