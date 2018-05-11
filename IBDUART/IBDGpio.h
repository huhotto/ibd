#ifndef __IBDGpio_H
#define __IBDGpio_H 	
#include "stm32f10x_conf.h"
typedef enum {ON=0,OFF=1,BLINK}LEDSTATUS;
typedef enum  {BOOT=0x00,BYPASS=0x01,
	             ZERO_IDLE   =0x12,MIDIDLE    =0x22,FULL_IDLE    =0x32,
							 ZEROBUILDING=0x13,MIDBUILDING=0x23,FULLBUILDING= 0x33,
							 ZEROTOZERO  =0x14,MIDTOZERO=  0x24,FULLTOZERO   =0x34}DelayMode;
typedef struct ledDisp
{
	LEDSTATUS bypass;
	//LEDSTATUS panic;
	LEDSTATUS rebuild;
	LEDSTATUS ramtozero;
	LEDSTATUS sneeze;
	LEDSTATUS dump;
//	LEDSTATUS music;
}LED_STR;

extern void delay_ms(int time);
extern void delay_us(int time);
extern void SEG4_Display (void);
extern void SEG4_Display_mask (void);
extern void Led_Driver(uint8_t LedValue);
extern void IBD_GpioInit(void);
extern void Led_Display(LED_STR *Led_status);

#endif
