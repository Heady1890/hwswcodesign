#include "filters.h"
#include "image.h"

#define Y_LOW    100000000
#define CB_LOW  -150000000
#define CR_LOW    50000000

#define Y_HIGH  1000000000
#define CB_HIGH   50000000
#define CR_HIGH  200000000



void skinFilter(image_t *inputImage, bit_image_t *outputImage)
{
  int x, y;
  int pIndex = 0;
  //Index des Bytes wo Information gesetzt wird
  uint16_t bwpIndex=0;
  //Index innerhalb eines Bytes, welches Bit gesetzt wird.
  uint16_t byteIndex=0;
  for (y = 0; y < inputImage->height; ++y) {
    for (x = 0; x < inputImage->width; ++x) {  
      ycbcr_color_t ycbcr = getYCbCrColorValue(inputImage, pIndex);

      if (ycbcr.y >= Y_LOW && ycbcr.y <= Y_HIGH
	  && ycbcr.cb >= CB_LOW && ycbcr.cb <= CB_HIGH
	  && ycbcr.cr >= CR_LOW && ycbcr.cr <= CR_HIGH) {
	// set output pixel white
        outputImage->data[bwpIndex] |= (1<<byteIndex);
      }
      
      //neue Indexe setzen
      pIndex+=3;
      byteIndex++;
      if(byteIndex>=8){
        byteIndex=0;
        printf("Index: %i, Inhalt: %x",bwpIndex,outputImage->data[bwpIndex]);
        bwpIndex++;
        outputImage->data[bwpIndex]=0x00;
      }
    }
  }
}


