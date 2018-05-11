#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_syscfg.h"
#include "delay.h"
#include "IBD_type.h"
#include "Display_data.h"
#include  "masterSPI3.h"
#include "CommWithFPGA.h"

#define Key_Key1_pin			(GPIO_Pin_5)			//KEY1 	0xDE	Key_Menu
#define Key_Key2_pin			(GPIO_Pin_6) 			//KEY2	0xBE  Key_Cursor
#define Key_Key3_pin			(GPIO_Pin_7) 			//KEY3	0x7E  Key_Bypass
#define Key_Key4_pin			(GPIO_Pin_1) 			//KEY4	0xFC  Key_Rebuild
#define Key_Key5_pin			(GPIO_Pin_2) 			//KEY5  0xFA  Key_RampToZero
#define Key_Key6_pin			(GPIO_Pin_3) 			//KEY6	0xE6  Key_Sneeze
#define Key_Key7_pin			(GPIO_Pin_4) 			//KEY7	0xEE	Key_Dump
#define Key_Key8_pin			(GPIO_Pin_8) 			//PORTA  LOCK

#define Key_Key1_value					(0xDE)
#define Key_Key2_value					(0xBE)
#define Key_Key3_value					(0x7E)
#define Key_Key4_value					(0xFC)
#define Key_Key5_value		  		(0xFA)
#define Key_Key6_value					(0xE6)
#define Key_Key7_value					(0xEE)




#define Key_Menu						(1)
#define Key_Cursor					(5)
#define Key_Bypass					(2)
#define Key_Rebuild					(4)
#define Key_RampToZero		  (3)
#define Key_Sneeze					(8)
#define Key_Dump						(9)
#define Key_Sneeze_up				(10)

#define LEDTest   (GPIO_Pin_0)
#define STORE_CLK (GPIO_Pin_4)
#define LED_CLR   (GPIO_Pin_5)
#define Shift_CLK (GPIO_Pin_6)
#define LED_DATA  (GPIO_Pin_7)
/*******************1276543*************/
#define Led_Bypass		 (6)		
#define led_Rebuild		 (5)
#define Led_RampToZero (4)
#define led_Sneeze     (3)
#define led_Dump       (2)

uint8_t	KeyValue;
uint8_t Key_messege;
uint8_t Key_lock_flag;
uint8_t FlagGpioInit = 0;
uint8_t Key_Sneeze_status=0; 
uint8_t key_dump_tmp=0;
uint8_t new_para=0;
/***************************************************************/
void LedGPIOInit(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = (STORE_CLK | LED_CLR | Shift_CLK | LED_DATA | LEDTest);
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;  
  GPIO_Init(GPIOB, &GPIO_InitStructure);
}
/****************************************************/
void Led_Driver(uint8_t LedValue)
{
 int i;
	 uint8_t tempShift=LedValue;
	 if(FlagGpioInit != 0x55)
	 {
			LedGPIOInit();
		  FlagGpioInit = 0x55;
	 }
	 GPIO_ResetBits(GPIOB,STORE_CLK);
	 GPIO_SetBits(GPIOB,LED_CLR);
	 GPIO_ResetBits(GPIOB,Shift_CLK);
	 GPIO_ResetBits(GPIOB,LED_DATA);
	 delay_ms(1);
	 
	 for(i=0;i<8;i++)
	 {  // set data ready
			if(tempShift & 0x80)
			{
					GPIO_SetBits(GPIOB,LED_DATA);
			}
			else
			{
			    GPIO_ResetBits(GPIOB,LED_DATA);
			}
			// give shift_clk
			GPIO_SetBits(GPIOB,Shift_CLK);
			delay_ms(1);
			GPIO_ResetBits(GPIOB,Shift_CLK);
			tempShift <<= 1;
	 }
	 	GPIO_SetBits(GPIOB,STORE_CLK);
		delay_ms(1);
		GPIO_ResetBits(GPIOB,STORE_CLK);

}
/******************************************************/
void Led_Display(LED_STR *Led_status)
	{	
			uint8_t tempValue;
		  uint8_t static ledFlag;
	//unsigned short LedBuff[8] = {LED_MENU,LED_BYPASS,LED_MUSIC,LED_REBUILD,LED_CURSOR,LED_PANIC,LED_RAMETOZERO,LED_SNEEZE};
			tempValue = 0;
			ledFlag = !ledFlag;
	
		
			if(Led_status->bypass == BLINK)
					tempValue |= (ledFlag << Led_Bypass);
			else
					tempValue |= (((Led_status->bypass) << Led_Bypass));//bypass

			if(Led_status->rebuild == BLINK)
					tempValue |= (ledFlag << led_Rebuild);
			else
					tempValue |= (((Led_status->rebuild) << led_Rebuild));//rebuild
			
			if(Led_status->ramtozero == BLINK)
					tempValue |= (ledFlag << Led_RampToZero);
			else
					tempValue |= (((Led_status->ramtozero) << Led_RampToZero));//ramtozero
			
			if(Led_status->sneeze == BLINK)
					tempValue |= (ledFlag << led_Sneeze);
			else
					tempValue |= (((Led_status->sneeze) << led_Sneeze));//sneeze

					tempValue |= (((Led_status->dump) << led_Dump));//dump
		
		
//---------------------------------------------
			Led_Driver(tempValue);

	}
#define Key_Sneeze_status_press  ON		//0 
#define Key_Sneeze_status_up 		 OFF 	//1
void  key_sneeze_scan(void)
{
		unsigned char keySneezeState;
		keySneezeState = GPIO_ReadInputDataBit(GPIOA,Key_Key6_pin);
		if((Key_Sneeze_status ==Key_Sneeze_status_up) && (keySneezeState == Key_Sneeze_status_press)) //1-0
		 {  
			  Key_Sneeze_status = Key_Sneeze_status_press;
		    SendKeyValu(Key_Sneeze);
		 }
		 else if((Key_Sneeze_status ==Key_Sneeze_status_press) && (keySneezeState == Key_Sneeze_status_up))//0-1
		 {
		    Key_Sneeze_status = Key_Sneeze_status_up;
		    SendKeyValu(Key_Sneeze_up);
		 
		 }
	
			
			

}
uint8_t Key_Lock_Scan(void)
{
	uint8_t tmp0=0;
	if(GPIO_ReadInputDataBit(GPIOA,Key_Key8_pin))
		tmp0 = 0; //dealy
	else
		tmp0=  1;//main page
	
   tmp0 += (Key_lock_flag <<1);
	 Key_lock_flag = tmp0 & 0x01;
	 if((tmp0 > 0) && (tmp0 <3) )
				new_para = 0 ;  
	 return tmp0;
}
/****************************************************/
uint8_t KeySCan(void)
{
	unsigned char result = 0;
	unsigned char temp=0xff;

	temp= GPIO_ReadInputData(GPIOA) & 0xfe;
	if(temp != 0xfe)
	{
		switch(temp)
		{
			case Key_Key1_value: result = Key_Menu; break;
			case Key_Key2_value: result = Key_Cursor; break;
			case Key_Key3_value: result = Key_Bypass; break;
			case Key_Key4_value: result = Key_Rebuild; break;
			case Key_Key5_value: result = Key_RampToZero; break;
			//case Key_Key6_value: result = Key_Sneeze; break;
			case Key_Key6_value: result = 0xfe; break;
			case Key_Key7_value: result = Key_Dump;break;
	
			default: break;
		}
		
	}
	
	
	return result;

	}
/*********************************************************************
	Key_lock_flag =1  pagemain   0 pagedelay 
*********************************************************************/	
	
#define MAXTIME_LEN 13	
void Key_Fun(void)	  
{
	unsigned char maxtime[MAXTIME_LEN]={4,8,10,16,20,30,40,50,60,70,80,90,100};
	unsigned char i;
	Key_messege=0;
	switch(OLED_Status.page)
	{
		case pageMain:
									 if(KeyValue==Key_Menu)
										 {
												OLED_Status.page = OLED_Status.mainPageCurror;
											  OLED_Status.InPutCurror =0;
												OLED_Status.cursor = 0;
											 
										 } 
										else if(KeyValue==Key_Cursor)
											{	
												 OLED_Status.cursor = (OLED_Status.cursor > 5)?1:(OLED_Status.cursor + 1);
												 OLED_Status.mainPageCurror=OLED_Status.cursor;
											}
												 break;
	  case pageINPUT:
										 if(KeyValue==Key_Menu)
											{
												if(OLED_Status.cursor > 2)
													{
														OLED_Status.page = pageMain;
														OLED_Status.InPutCurror =0;
														OLED_Status.cursor = OLED_Status.mainPageCurror;
													} 
												  else 
															OLED_Status.cursor++;//1,2,3
												}
											else if(KeyValue==Key_Cursor)
											{
												if(OLED_Status.cursor == 1)
												{
													  OLED_Status.InPutCurror =IBD200Status.type;
													  OLED_Status.InPutCurror = ( OLED_Status.InPutCurror > 4)?0:(OLED_Status.InPutCurror + 1);
													  setInputSrc(OLED_Status.InPutCurror);
												}
												else if(OLED_Status.cursor == 2)
												{
													  OLED_Status.InPutCurror = !OLED_Status.InPutCurror;
														setMusic(OLED_Status.InPutCurror);
												}
												else if(OLED_Status.cursor == 3)
												{
													  OLED_Status.InPutCurror =IBD200Status.ch_num;
													  OLED_Status.InPutCurror = (OLED_Status.InPutCurror > 5)?0:(OLED_Status.InPutCurror + 1);
														setListenHeadPhone(OLED_Status.InPutCurror);
												}
											
											}break;
		case pageMETER:  
		case pageAOIP:
										if(KeyValue==Key_Menu)
												{
												 OLED_Status.page = pageMain;
												 OLED_Status.cursor = OLED_Status.mainPageCurror;
												}
										else if(KeyValue==Key_Cursor)
												OLED_Status.cursor = !OLED_Status.cursor;
		
										break;
		case pagePARA:
										if(KeyValue==Key_Menu)
											{
												if(OLED_Status.cursor > 1)
													{
														 OLED_Status.page = pageMain;
													   OLED_Status.cursor = OLED_Status.mainPageCurror;
														
														if(new_para==1)
														{
																new_para = 0;
																SetTimePara();
																WriteBootMode();
														}
													} 
												  else 
															OLED_Status.cursor++; //1,2
												}
											
											else if(KeyValue==Key_Cursor)
											{
												
												
												if(OLED_Status.cursor == 1)
												{  
													for(i =0;i < MAXTIME_LEN; i++)
													{
														if(maxtime[i]==IBD200TimePara.maxtime)
																 OLED_Status.InPutCurror = i;
														}
													  OLED_Status.InPutCurror = (OLED_Status.InPutCurror > (MAXTIME_LEN -2))?0:(OLED_Status.InPutCurror + 1);
														IBD200TimePara.maxtime =maxtime[OLED_Status.InPutCurror];
														IBD200TimePara.buildtime = IBD200TimePara.maxtime * 15;
														new_para = 1;
												}
												else if(OLED_Status.cursor == 2)
												{
														OLED_Status.InPutCurror =(unsigned char) IBD200TimePara.dumptime;
												  	OLED_Status.InPutCurror = (OLED_Status.InPutCurror > 10)?1:(OLED_Status.InPutCurror + 1);
													  IBD200TimePara.dumptime = OLED_Status.InPutCurror;
													  new_para = 1;
													
												}
												
											 }break;
		default: if(KeyValue==Key_Menu)
						{
						 OLED_Status.page = pageMain;
						 OLED_Status.cursor = OLED_Status.mainPageCurror;
						}
					  break;
	}	
}

void key_process(void)
{
	key_sneeze_scan();
if(Key_messege == 1)
	{
	Key_messege =0;
		switch(KeyValue)
		{
			case Key_Menu:
			case Key_Cursor:
											if(Key_lock_flag)
													Key_Fun();
													break;
			case Key_Bypass: 
											SendKeyValu(KeyValue);break;
			case Key_Rebuild: 
												if((Key_Sneeze_status ==Key_Sneeze_status_up) && (delay_mode!=FULLBUILDING)) 
																SendKeyValu(KeyValue);
												break;
												
			case Key_RampToZero:
											    if(Key_Sneeze_status ==Key_Sneeze_status_up)
																SendKeyValu(KeyValue);
													break;
			//case Key_Sneeze:
			case Key_Dump: 
										  if(!key_dump_tmp) 
													key_dump_tmp =1;
											else  
													{ Key_messege=0;
														KeyValue =0;
													}
										 if(Key_Sneeze_status ==Key_Sneeze_status_up)
												SendKeyValu(KeyValue);
										 break;
			default:break;
		}
	}

}
/**********************************************************************/

/**********************************************************************
* Key Interrupt service function
* 
***********************************************************************/
void EXTI15_10_IRQHandler(void)
{
	KeyValue = KeySCan();
	if((KeyValue !=0) && (KeyValue != 0xff))
	{
			if(!Key_messege)
					Key_messege = 1;
	}
  EXTI_ClearITPendingBit(EXTI_Line12);
		
}
/****************************************************************************/
void keyGpioInit(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB | RCC_AHB1Periph_GPIOA | RCC_AHB1Periph_GPIOD, ENABLE);  
	
  GPIO_InitStructure.GPIO_Pin = (Key_Key1_pin | Key_Key2_pin | Key_Key3_pin |  Key_Key4_pin | 
																 Key_Key5_pin | Key_Key6_pin | Key_Key7_pin  |Key_Key8_pin
	                               );
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;  
  GPIO_Init(GPIOA, &GPIO_InitStructure);	
	

/*	GPIO_InitStructure.GPIO_Pin = (keyUp | keyDown);    
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;     
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;  
  GPIO_Init(GPIOB, &GPIO_InitStructure);	
	
	GPIO_InitStructure.GPIO_Pin = keyReturn;    
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;     
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;  
  GPIO_Init(GPIOD, &GPIO_InitStructure);

	GPIO_InitStructure.GPIO_Pin = 	Key_Key8_pin;    
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;     
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;  
  GPIO_Init(GPIOC, &GPIO_InitStructure);*/
}
/***********************************************************************/
void ExtInterruptInit(void)
{
	NVIC_InitTypeDef NVIC_InitStructure;
	EXTI_InitTypeDef EXTI_InitStructure;

	RCC_APB2PeriphClockCmd(RCC_APB2Periph_SYSCFG, ENABLE);
	
	SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOA,EXTI_PinSource12); //PA12 
	EXTI_InitStructure.EXTI_Line = EXTI_Line12;
	EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
	EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Falling;
	EXTI_InitStructure.EXTI_LineCmd = ENABLE;
	EXTI_Init(&EXTI_InitStructure);
	
	NVIC_InitStructure.NVIC_IRQChannel = EXTI15_10_IRQn;       //share a exti line
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 2;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	
	NVIC_Init(&NVIC_InitStructure);
}
/**********************************************************************/
void ExtIDisable(void)
{
	NVIC_InitTypeDef NVIC_InitStructure;
	EXTI_InitTypeDef EXTI_InitStructure;

	RCC_APB2PeriphClockCmd(RCC_APB2Periph_SYSCFG, ENABLE);
	
	SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOA,EXTI_PinSource12); //PA12 
	EXTI_InitStructure.EXTI_Line = EXTI_Line12;
	EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
	EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Falling;
	EXTI_InitStructure.EXTI_LineCmd = DISABLE;
	EXTI_Init(&EXTI_InitStructure);
	
	NVIC_InitStructure.NVIC_IRQChannel = EXTI15_10_IRQn;       //share a exti line
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 2;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	
	NVIC_Init(&NVIC_InitStructure);
}
