#include "stm32f10x_conf.h"
#include "IBDGpio.h"
#include "key.h"
#include "RS232.h"
#include "main.h"
//uint8_t  time[4]={0,0,0,0};
//uint8_t  TimeSegCnt=0;
//uint8_t  TimeCnt=0;
#define KEY_DUMP_COUNTER 3
uint8_t  ledTimeCnt=0;
uint8_t  key_dump_cnt=0;
IBDTypeDef Ibd800;

int main(void)
{
 	
	IBD_GpioInit();
  KeyInit();
	USART_Config();
	Ibd800.Led_status.bypass = OFF;
  Ibd800.Led_status.rebuild = OFF;
  Ibd800.Led_status.ramtozero = OFF;
  Ibd800.Led_status.sneeze = OFF;
	Ibd800.Led_status.dump = OFF;
//	delay_ms(200);
	while(1)
  {
		
	if(ledTimeCnt++==80)	
	{
		ledTimeCnt=0;
		Led_Display(&Ibd800.Led_status);	
	}
	if(ledTimeCnt%40==0)	
		{
				KeyFun();
		if(key_dump_cnt<KEY_DUMP_COUNTER)	
				key_dump_cnt++;
		switch(Ibd800.currkey)
		{
			case KEYSNEEZE:
			case KEYSNEEZE_UP:
									Usart_Sendkey();
									Ibd800.currkey=0;break;	
			case KEYDUMP  :
											if((key_dump_cnt>=KEY_DUMP_COUNTER) && (keysneeze_status))
												{  
														Usart_Sendkey();
														key_dump_cnt =0; 
													  Ibd800.currkey=0;
												}break;	
			case  KEYBYPASS  :
		  case  KEYREBULID :
			case  KEYEXIT    :
											if(keysneeze_status)
																				Usart_Sendkey();
																				Ibd800.currkey=0;
			default : break;	
			}

   }
		


	//Led_Driver(0x02);
	 if(Ibd800.mode > 1 )
			SEG4_Display();// 4ms√ø¥Œ
	 else 
			SEG4_Display_mask();
	
	
		}
}
