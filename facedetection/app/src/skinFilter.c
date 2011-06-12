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
  int pIndex_line_adder = (COMPUTE_LINE-1)*inputImage->width*3;
  int pIndex_column_adder = COMPUTE_COLUMN*3;
  //printf("Start skinFilter, Adder=%i\n",pIndex_adder);
  //Index des Bytes wo Information gesetzt wird
  uint16_t bpIndex=0;
  //Index innerhalb eines Bytes, welches Bit gesetzt wird.
  uint16_t byteIndex=0;
  for (y = 0; y < outputImage->height; ++y) {
    for (x = 0; x < outputImage->width; ++x) {  
      ycbcr_color_t ycbcr = getYCbCrColorValue(inputImage, pIndex);
      //printf("Farbumrechnung funktioniert \n");

      if (ycbcr.y >= Y_LOW && ycbcr.y <= Y_HIGH
	  && ycbcr.cb >= CB_LOW && ycbcr.cb <= CB_HIGH
	  && ycbcr.cr >= CR_LOW && ycbcr.cr <= CR_HIGH) {
	// set output pixel white
        outputImage->data[bpIndex] |= (1<<byteIndex);
      }
      
      //neue Indexe setzen
      pIndex+=pIndex_column_adder;
      byteIndex++;
      if(byteIndex>=8){
        byteIndex=0;
        bpIndex++;
        outputImage->data[bpIndex]=0x00;
      }
    }
    pIndex+=pIndex_line_adder;
    //printf("Schleife %i von %i\n", y, outputImage->height);
  }
}


