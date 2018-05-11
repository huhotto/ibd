#ifndef __KEY_LED_H
#define __KEY_LED_H
#include "IBD_type.h"
#include "stm32f4xx.h"
extern void keyGpioInit(void);
extern void ExtInterruptInit(void);
extern void LedGPIOInit(void);
extern void Led_Display(LED_STR *Led_status);
extern void Key_Fun(void)	;
//extern uint8_t  key_sneeze_scan(void);
extern uint8_t Key_Lock_Scan(void);
extern void Led_Driver(uint8_t LedValue);
extern void key_process(void);
#endif
