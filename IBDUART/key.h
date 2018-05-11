#ifndef __KEY_H
#define __KEY_H 
#include "stm32f10x_conf.h"
typedef enum {KEYBYPASS=2,KEYREBULID=4,KEYEXIT=3,KEYSNEEZE=8,KEYDUMP=9,KEYSNEEZE_UP=10}KEYNUM;
extern uint8_t keysneeze_status;
extern void KeyInit(void);
extern void KeyFun(void);
#endif
