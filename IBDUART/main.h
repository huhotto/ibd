#ifndef __MAIN_H
#define __MAIN_H 
#include "IBDGpio.h"
extern   uint8_t  time[4];
typedef struct 
{
  uint8_t  mode;
	uint8_t  dumptime;
	uint8_t  segtime[4]; 
	uint8_t  currkey;
	float    time;
	LED_STR Led_status;
	
	
}IBDTypeDef;

extern IBDTypeDef Ibd800;
#endif
