#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_exti.h"
#include "stm32f4xx_syscfg.h"
#include "keyScanAndDeal.h"
//#include "stm32f4xx_it.h"
#include "sys.h"
#include "Display.h"
//#include "CommWithFPGA.h"
//#include "main.h"

#define keyCH1     (GPIO_Pin_2)   	//PA2
#define keyCH2     (GPIO_Pin_3)   	//PA3
#define keyCH3     (GPIO_Pin_4)   	//PA4
#define keyCH4     (GPIO_Pin_5)   	//PA5
#define keyCH5     (GPIO_Pin_6)   	//PA6
#define keyCH6     (GPIO_Pin_7)   	//PA7
#define keyCH7     (GPIO_Pin_8)   	//PA8
#define keyCH8     (GPIO_Pin_9)   	//PA9
#define keyTake  	 (GPIO_Pin_5)   		//PA10
#define keyAuto    (GPIO_Pin_6)   		//PA11
#define keyInt     (GPIO_Pin_12) 	 	//PA12
#define keyUp      (GPIO_Pin_1)      //PB1
#define keyDown    (GPIO_Pin_3)      //PB3
#define keyReturn  (GPIO_Pin_2)      //PD2
#define LockSwitch (GPIO_Pin_8)      //PC8

#define keyCh1Value     (0xF8)
#define keyCh2Value     (0xF4)
#define keyCh3Value     (0xEC)
#define keyCh4Value     (0xDC)
#define keyCh5Value     (0xBC)
#define keyCh6Value     (0x7C)
#define keyCh7Value     (0x0E)
#define keyCh8Value     (0x0D)
#define keyTakeValue    (0x0B)
#define keyAutoValue    (0x07)

#define keyMenu  			keyCh1Value
#define keyBypass  		keyCh2Value
#define keyRampToZero keyCh3Value 
#define keyRebuild  	keyCh4Value
#define keyCursor  		keyCh5Value
#define keyPanic  		keyCh6Value
#define keyMusic  		keyCh7Value
#define keySneeze     keyTakeValue
#define keyDump 			keyCh8Value

#define KEY_PRESSED      (0)
#define KEY_RELEASE      (1)

volatile SwitchAndMonitorStatus CurrentSwitchStatus;
volatile unsigned char delay_mode= BYPASS;
volatile unsigned char keyValue = 0xFF;
volatile unsigned char FlagDealKeyBoard = 0;
volatile unsigned char FlagLock = 0;
volatile unsigned char counter = 0;
volatile unsigned char count = 0;
unsigned char keySneezeState;
volatile float delay_time = 0.0;

/********************************************************************/
/*void KeyDeal(void)
{
	 if(keyValue == keyMenu)
	 {
		 	if(OLED_Status.page != pageMain)
			{	
				OLED_Status.page = pageMain;
				OLED_Status.cursor = OLED_Status.mainPageCurror;
			}
			else
			{
				OLED_Status.page = OLED_Status.mainPageCurror;
				OLED_Status.cursor = 0;
			}
	 }
	 else if(keyValue == keyCursor)
	 {
		 switch(OLED_Status.page)
		 {
			 case pageMain:  
				 {
						OLED_Status.cursor = (OLED_Status.cursor == 6)?1:(OLED_Status.cursor + 1);
					  OLED_Status.mainPageCurror = OLED_Status.cursor;
				 };break;
			 case pageMETER:
			 case pageAOIP:
			 {
					OLED_Status.cursor = !OLED_Status.cursor;
			 };break;
			 default:
			 {
				OLED_Status.cursor = 0;
			 }
		 }
	 }
	else if((FlagLock != 1) && (keyValue == keyBypass) )
	{
		if(delay_mode != BYPASS)
		{
			delay_mode = BYPASS;
			delay_time = 0;
			dispThis = 0;
		}
		else
		{
			delay_mode = WAITING;
		}
	}
	else if((FlagLock != 1) && (keyValue == keyPanic) )
	{
		if( (delay_mode != PANIC) && (delay_mode != BYPASS) )
		{
			delay_mode = PANIC;
			delay_time = 0;
			dispThis = 0;
		}
		else if(delay_mode == PANIC)
		{
			delay_mode = REBUILDING;
			clrScreen();
		}
	
	}
	else if((FlagLock != 1) && (keyValue == keyDump) &&(delay_time >0) )
	{
		delay_time = (delay_time >= IBD200TimePara.dumptime)?(delay_time-IBD200TimePara.dumptime):0;
	}
	else if(FlagLock != 1)
	{
		switch(delay_mode)
		{
			case BYPASS:{
									};break;
			case WAITING: {
												  if((keyValue == keyRebuild) &&(delay_time  < IBD200TimePara.maxtime))
													{
														delay_mode = REBUILDING;
													}
													else if( (keyValue == keyRampToZero) && (delay_time >0))
													{
														delay_mode = RAMPTOZERO;
													}
									};break;
			case REBUILDING:
			{
					if(keyValue == keyRebuild)
					{
						delay_mode = WAITING;
					}
					else if(keyValue == keyRampToZero)
					{
						delay_mode = RAMPTOZERO;
					}
			};break;
			case RAMPTOZERO:
			{
					if(keyValue == keyRebuild)
					{
						delay_mode = REBUILDING;
					}
					else if(keyValue == keyRampToZero)
					{
						delay_mode = WAITING;
					}
			};break;			
			case REBUILD_COMPLETE:
			{
				if(keyValue == keyRampToZero)
				{
					delay_mode = RAMPTOZERO;
				}
			};break;
		}
	}
}*/

/*********************************************************************
* Read the ports
*
**********************************************************************/
unsigned char keyScan(void)
{
	unsigned char temp=0xff;
	
	if(GPIO_ReadInputDataBit(GPIOC,LockSwitch))
	{
		FlagLock = 0;
	}
	else
	{
		FlagLock = 1;
	}
	
	temp = GPIO_ReadInputData(GPIOA) & 0xFC;
	
	if(temp != 0xfc)
			return temp;
	temp = ((GPIO_ReadInputData(GPIOA) & 0x0F00) >> 8) & 0x0f;
	if(temp != 0x0F)
			return temp;
	
		return 0;
}
/*********************************************************************
* Initialization the key port as input
*
**********************************************************************/
void keyGpioInit(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB | RCC_AHB1Periph_GPIOA | RCC_AHB1Periph_GPIOD, ENABLE);  
	
  GPIO_InitStructure.GPIO_Pin = (keyCH1 | keyCH2 | keyCH3 | 
	                               keyCH4 | keyCH5 | keyCH6 | 
	                               keyCH7 | keyCH8 | keyTake | keyAuto | keyInt
	                               );
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;  
  GPIO_Init(GPIOA, &GPIO_InitStructure);	
	

	GPIO_InitStructure.GPIO_Pin = (keyUp | keyDown);    
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;     
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;  
  GPIO_Init(GPIOB, &GPIO_InitStructure);	
	
	GPIO_InitStructure.GPIO_Pin = keyReturn;    
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;     
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;  
  GPIO_Init(GPIOD, &GPIO_InitStructure);

	GPIO_InitStructure.GPIO_Pin = 	LockSwitch;    
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;     
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;  
  GPIO_Init(GPIOC, &GPIO_InitStructure);
}

/*********************************************************************
* keyInterrupt and Interrupt initialization
*
**********************************************************************/
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
/**********************************************************************
* Key Interrupt service function
* 
***********************************************************************/
void EXTI15_10_IRQHandler(void)
{
	keyValue = keyScan();
	if((keyValue !=0) && (keyValue != 0xff))
	{
			if(!FlagDealKeyBoard)
					FlagDealKeyBoard = 1;
	}
  EXTI_ClearITPendingBit(EXTI_Line12);
		
}
