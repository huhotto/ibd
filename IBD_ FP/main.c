#include "delay.h"
#include "Hg25664.h"
#include "IBD_type.h"
#include "dispChar.h"
#include "KeyLed.h"
#include <stdio.h>
#include "drawPic.h"
#include "Display_data.h"
#include  "masterSPI3.h"
#include  "Display.h"
#include "CommWithFPGA.h"
extern uint8_t	KeyValue;
extern uint8_t Key_messege;
/*KeySCan�������delay_mode==FULLBUILDINGʱ�����ν�������20180413*/
int main(void)
{
	
	delay_init(168);
	delay_ms(200);
	OLED_Initialization();
	keyGpioInit();
	ExtInterruptInit();
	LedGPIOInit();
	FPGA_Init();
	while(1)
	{	
		WaitBoot();	
	  IBD_Fun();
	}
}
