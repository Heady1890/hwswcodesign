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
  uint32_t counter=0;

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
  printf("%i von %i ",counter,(inputImage->height*inputImage->width));
}

uint8_t checkPaint(int x, int y, bit_image_t *inputImage){
  uint8_t temp;

  //linkes Bit checken
  //1. byteIndex um eins verringern
  if(byteIndex2==0){
    byteIndex2=7;
    bpIndex2--;
  }
  else byteIndex2--;
  temp=(inputImage->data[bpIndex]>>byteIndex)&0x01;
  if(!temp)return 0x00;

  //rechtes Bit checken
  byteIndex2++;
  if(byteIndex2>=8){
    byteIndex2=0;
    bpIndex2++;
  }
  byteIndex2++;
  if(byteIndex2>=8){
    byteIndex2=0;
    bpIndex2++;
  }
  temp=(inputImage->data[bpIndex]>>byteIndex)&0x01;
  if(!temp)return 0x00;
  
  //oberes Bit checken
  if(byteIndex2==0){
    byteIndex2=7;
    bpIndex2--;
  }
  else byteIndex2--;
  
}

void dilateFilter(bit_image_t *inputImage, bit_image_t *outputImage){
  int x, y, dx, dy, wx, wy;
  //Index des Bytes wo Information gesetzt wird
  uint16_t bpIndex=0;
  uint16_t bpIndex2=0;
  //Index innerhalb eines Bytes, welches Bit gesetzt wird.
  uint8_t byteIndex=0;
  uint8_t byteIndex2=0;

  //Debug
  uint32_t counter=0;

  for (y = 0; y < inputImage->height; ++y) {
    for (x = 0; x < inputImage->width; ++x) {
      uint8_t temp=(inputImage->data[bpIndex]>>byteIndex)&0x01;
      //wenn Pixel weiß ist, dann weißes Quadrat zeichnen
      if (temp){
        counter++;
        //if(checkPaint(x,y,&inputImage))

        for (dy = -WINDOW_OFFSET; dy <= WINDOW_OFFSET; ++dy) {
	  wy = y+dy;
	  if (wy >= 0 && wy < inputImage->height) {
            uint32_t temp2 = ((x-2)+wy*inputImage->width);
            bpIndex2=temp2>>3;
            byteIndex2=temp2&0x07;
	    for (dx = -WINDOW_OFFSET; dx <= WINDOW_OFFSET; ++dx) {
	      wx = x+dx;
	      if (wx >= 0 && wx < inputImage->width) {
                outputImage->data[bpIndex2] |= (1<<byteIndex2);

                byteIndex2++;
	        if(byteIndex2>=8){
		  byteIndex2=0;
		  bpIndex2++;
                }
	      }
	    }
	  }
	}
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
