#include "filters.h"
#include "image.h"

#define Y_LOW    300000000
#define CB_LOW  -150000000
#define CR_LOW    50000000	//50000000

#define Y_HIGH   900000000	//750000000
#define CB_HIGH  -40000000	//10000000
#define CR_HIGH  200000000



void skinFilter(image_t *inputImage, bit_image_t *outputImage)
{
  int x, y;
  int pIndex = 0;
  int pIndex_line_adder = (COMPUTE_LINE-1)*inputImage->width*3;
  int pIndex_column_adder = COMPUTE_COLUMN*3;
  uint16_t bpIndex=0;
  uint16_t byteIndex=0;

  //Debug
  int small_y, big_y;

  for (y = 0; y < outputImage->height; ++y) {
    for (x = 0; x < outputImage->width; ++x) {  
      ycbcr_color_t ycbcr = getYCbCrColorValue(inputImage, pIndex);
      if (ycbcr.y >= Y_LOW && ycbcr.y <= Y_HIGH
	  && ycbcr.cb >= CB_LOW && ycbcr.cb <= CB_HIGH
	  && ycbcr.cr >= CR_LOW && ycbcr.cr <= CR_HIGH) {
	// set output pixel white
        //if(x>=56 && x<=89 && y>=19 && y<=69){
        //if(y>=105){
          outputImage->data[bpIndex] |= (1<<byteIndex);
          //printf("Farbe bei x:%i y:%i ist Y:%i, Cb:%i, Cr:%i\n",x,y,ycbcr.y,ycbcr.cb,ycbcr.cr);
          //printf("%i\n",ycbcr.cr);
        //}
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
  }
}


