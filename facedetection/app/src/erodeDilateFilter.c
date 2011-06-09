#include "filters.h"
#include "image.h"

#define WINDOW_LENGTH 5
#define WINDOW_OFFSET ((WINDOW_LENGTH-1)/2)


void erodeDilateFilter(bit_image_t *inputImage, bit_image_t *outputImage, uint8_t op)
{
  int x, y, dx, dy, wx, wy;
  rgb_color_t c, compare;
  uint8_t foundMatch;

  //Index des Bytes wo Information gesetzt wird
  uint16_t bpIndex=0;
  uint16_t bpIndex2=0;
  //Index innerhalb eines Bytes, welches Bit gesetzt wird.
  uint8_t byteIndex=0;
  uint8_t byteIndex2=0;

  //Debug
  uint16_t counter=0;

  for (y = 0; y < inputImage->height; ++y) {
    for (x = 0; x < inputImage->width; ++x) {  

      foundMatch = 0;
      uint8_t temp=(inputImage->data[bpIndex]>>byteIndex)&0x01;
      if (temp==op){
      counter++;
      for (dy = -WINDOW_OFFSET; dy <= WINDOW_OFFSET; ++dy) {
	wy = y+dy;
	if (wy >= 0 && wy < inputImage->height) {
          uint32_t temp = ((x-2)+wy*inputImage->width);
          bpIndex2=temp>>3;
          byteIndex2=temp&0x07;
	  for (dx = -WINDOW_OFFSET; dx <= WINDOW_OFFSET; ++dx) {
	    wx = x+dx;
	    if (wx >= 0 && wx < inputImage->width && foundMatch == 0) {
              uint8_t temp2=(inputImage->data[bpIndex2]>>byteIndex2)&0x01;
              if(temp2!=op){
                foundMatch=1;
                break;
              }
              byteIndex2++;
	      if(byteIndex2>=8){
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
      }
      else{foundMatch=1;}

      if ((op == FILTER_ERODE && !foundMatch) ||
	  (op == FILTER_DILATE && foundMatch)) {
	// set output pixel white
	outputImage->data[bpIndex] |= (1<<byteIndex);
      }

      byteIndex++;
      if(byteIndex>=8){
        byteIndex=0;
        bpIndex++;
        outputImage->data[bpIndex]=0x00;
      }
    }
  }
  printf("%i von %i",counter,(inputImage->height*inputImage->width));
}
