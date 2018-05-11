#ifndef __keyScanAndDeal_H
#define __keyScanAndDeal_H
#include "IBD_type.h"



//--This three keys need to checked seperately
//--just to judge the logic level 




extern unsigned char keySneezeState;
extern volatile SwitchAndMonitorStatus CurrentSwitchStatus;
extern volatile float delay_time;
extern volatile unsigned char delay_mode;
extern volatile unsigned char keyValue;
extern volatile unsigned char FlagDealKeyBoard;
extern void keyGpioInit(void);
extern unsigned char keyScan(void);
extern void KeyDeal(void);
extern void ExtInterruptInit(void);


#endif
