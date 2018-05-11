#include "key.h"
#include "IBDGpio.h"
#include "main.h"
#define KEY_INT_GPIO_CLK  (RCC_APB2Periph_AFIO | RCC_APB2Periph_GPIOB)
#define KEY_INIT_PIN  GPIO_Pin_11
#define KEY_INIT_PORT  GPIOB
#define KEY_INT_EXTI_PORTSOURCE  GPIO_PortSourceGPIOB
#define KEY_INT_EXTI_PINSOURCE   GPIO_PinSource11
#define KEY_INT_EXTI_LINE        EXTI_Line11
#define KEY_INT_EXTI_IRQ         EXTI15_10_IRQn
#define KEY_IRQHandler           EXTI15_10_IRQHandler

#define key1  GPIO_Pin_0  //GPIOA
#define key2  GPIO_Pin_1
#define key3  GPIO_Pin_2
#define key4  GPIO_Pin_3
#define key5  GPIO_Pin_4

#define key1value  0x1e  //GPIOA EXIT
#define key2value  0x1d //BUILD
#define key3value  0x1b //DUMP
#define key4value  0x17 //SNEEZE
#define key5value  0x0f //BYPASS
/*EXIT BUILD DUMP SNEEZE BYPASS */
#define KEYPORT  (key1 | key2 | key3 |key4 | key5)
uint8_t keysneeze_status;
void KeySCan(void)
{
	unsigned char temp=0xff;
	temp= GPIO_ReadInputData(GPIOA) & 0x1f;
	if(temp != 0x1f)
	{
		switch(temp)
		{
			case key1value: Ibd800.currkey = KEYEXIT; break;
			case key2value: Ibd800.currkey = KEYREBULID; break;
			case key3value: Ibd800.currkey= KEYDUMP; break;
									   /* while( (GPIO_ReadInputData(GPIOA) & 0x1f)== key5value)delay_ms(10); 
																												delay_ms(80);break;*/
			case key4value: Ibd800.currkey=  0; break;  //KEYSNEEZE no chuli
			case key5value: Ibd800.currkey = KEYBYPASS ; break;
		
		default: break;
		}
		
	}
	else 
			Ibd800.currkey=0;
	
}
#define press_up   1
#define press_down 0
void KeyFun(void)
{
	if(!GPIO_ReadInputDataBit(GPIOA,key4))
		{
			if(keysneeze_status==press_up)
			
					{
						keysneeze_status=press_down;
						Ibd800.currkey =KEYSNEEZE;
					}
				Ibd800.Led_status.sneeze = BLINK;
			
		}
		else
		{
			if(keysneeze_status ==press_down)
			{
				keysneeze_status=press_up; 
				Ibd800.currkey =KEYSNEEZE_UP;
			}
			
			Ibd800.Led_status.sneeze= ON;
		}
	
	if(Ibd800.time >  Ibd800.dumptime)
					 {
						 Ibd800.Led_status.dump = ON;
					 }
			else 	 Ibd800.Led_status.dump = OFF;
				
	switch(Ibd800.mode)
	{
		case BOOT:
		case BYPASS: {
					 Ibd800.Led_status.bypass = BLINK;
					 Ibd800.Led_status.dump = OFF;
					// Led_Status.music = OFF;
					// Led_Status.panic = OFF;
					 Ibd800.Led_status.ramtozero = OFF;
					 Ibd800.Led_status.rebuild = OFF;
					 Ibd800.Led_status.sneeze = OFF;
		} break;
		
		case  ZERO_IDLE:
		case	ZEROTOZERO:
		case	ZEROBUILDING: {
					 Ibd800.Led_status.bypass = OFF;
					//Led_Status.music = OFF;
					// Led_Status.panic = ON;
					 Ibd800.Led_status.rebuild = ON;
					 Ibd800.Led_status.sneeze = OFF;
				   Ibd800.Led_status.ramtozero = OFF;
					 
				 } break;
			case MIDIDLE: {
					 Ibd800.Led_status.bypass = OFF;
					 Ibd800.Led_status.rebuild = ON;
				   Ibd800.Led_status.ramtozero = ON;
			 	 } break;	
			case FULL_IDLE:
			case FULLTOZERO:
			case FULLBUILDING: {
					 Ibd800.Led_status.bypass = OFF;
					 Ibd800.Led_status.rebuild = OFF;
				   Ibd800.Led_status.ramtozero = ON;
			 	 } break;	
		
		case MIDBUILDING: { 
					 Ibd800.Led_status.bypass = OFF;
					// Led_Status.music = OFF;
					// Led_Status.panic = ON;
 					 Ibd800.Led_status.rebuild = BLINK;
					 Ibd800.Led_status.ramtozero = ON;

				 } break;
	  case MIDTOZERO:
		{
				   Ibd800.Led_status.bypass = OFF;
 					// Led_Status.music = OFF;
					// Led_Status.panic = ON;
 					 Ibd800.Led_status.rebuild = ON;
					 Ibd800.Led_status.ramtozero = BLINK;
		};break;
		default:  {
					 /*Ibd800.Led_status.bypass = BLINK;
					 Ibd800.Led_status.dump = OFF;
					// Led_Status.music = OFF;
					// Led_Status.panic = OFF;
					 Ibd800.Led_status.ramtozero = OFF;
					 Ibd800.Led_status.rebuild = OFF;
					 Ibd800.Led_status.sneeze = OFF;*/
		} break;
	
}

}


/******************************************************************************************/
void keyGpioInit(void)
{
 GPIO_InitTypeDef GPIO_InitStructure;
 RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA,ENABLE);
 GPIO_InitStructure.GPIO_Pin = KEYPORT;
 GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
 GPIO_InitStructure.GPIO_Mode =  GPIO_Mode_IPU;
 GPIO_Init(GPIOA, &GPIO_InitStructure);
}
static void NVIC_Configuration(void)
{
  NVIC_InitTypeDef NVIC_InitStructure;
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);
	NVIC_InitStructure.NVIC_IRQChannel = KEY_INT_EXTI_IRQ;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_Init(&NVIC_InitStructure);
	
}
void EXTI_Key_Config(void)
{
  GPIO_InitTypeDef GPIO_InitStructure;
	EXTI_InitTypeDef EXTI_InitStructure;
	RCC_APB2PeriphClockCmd(KEY_INT_GPIO_CLK,ENABLE);
	NVIC_Configuration();
	GPIO_InitStructure.GPIO_Pin = KEY_INIT_PIN; /*out*/
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING ;
	GPIO_Init(KEY_INIT_PORT, &GPIO_InitStructure);
	
	GPIO_EXTILineConfig(KEY_INT_EXTI_PORTSOURCE, KEY_INT_EXTI_PINSOURCE);// 
	                                                                     //Selects the GPIO pin used as EXTI Line.
	EXTI_InitStructure.EXTI_Line = KEY_INT_EXTI_LINE;// 设置线模式（中断 上升沿） 和使能
	EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
	EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Falling;
	EXTI_InitStructure.EXTI_LineCmd = ENABLE;
	EXTI_Init(&EXTI_InitStructure);

}

void KEY_IRQHandler(void)
{
 if (EXTI_GetITStatus(KEY_INT_EXTI_LINE) != RESET) 
	 {
		 KeySCan();
	   EXTI_ClearITPendingBit(KEY_INT_EXTI_LINE);
   }
}

void KeyInit(void)
{
	keyGpioInit();
	EXTI_Key_Config();

}
