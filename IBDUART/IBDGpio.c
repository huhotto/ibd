#include "IBDGpio.h"
#include "main.h"
#define Key1_pin    GPIO_Pin_0  /*GPIO A*/
#define Key2_pin  	GPIO_Pin_1
#define Key3_pin 	  GPIO_Pin_2
#define Key4_pin  	GPIO_Pin_3
#define Key5_pin  	GPIO_Pin_4

#define SEG_data	  GPIO_Pin_5
#define SEG_sfclk 	GPIO_Pin_6
#define SEG_clr 		GPIO_Pin_7
#define SEG_stclk 	GPIO_Pin_0  /*GPIO B*/

#define LED_data	  GPIO_Pin_3
#define LED_stclk 	GPIO_Pin_4  /*GPIO B*/
#define LED_sfclk 	GPIO_Pin_5
#define LED_clr 		GPIO_Pin_6

#define Led_Bypass		 (4)		
#define led_Rebuild		 (1)
#define Led_RampToZero (0)
#define led_Sneeze     (3)
#define led_Dump       (2)
/*EXIT(LED1) BUILD(LED2) DUMP(LED3) SNEEZE(LED4) BYPASS(LED5) */
uint8_t const segbit[]={0x0e,0x0d,0x0b,0x07};
uint8_t const SEG_Table[] = 
{// 0	 1	  2	   3	4	 5	  6	   7	8	 9	  A	   b	C    d	  E    F    -
	 0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71
};
uint8_t const SEG_Table_dp[] = 
{// 0	 1	  2	   3	4	 5	  6	   7	8	 9	  A	   b	C    d	  E    F    -
	 0xbf,0x86,0xdb,0xcf,0xe6,0xed,0xfd,0x87,0xff,0xef,0xf7,0xfc,0xb9,0xde,0xf9,0xf1

};
//LED_STR Led_Status;
/*************************************************************************************/
void delay_us(int time)
{
   uint8_t i;
	 for(;time>0;time--)
			for(i=8;i>0;i--);
			
}
void delay_ms(int time)
{
  for(;time>0;time--)
				delay_us(1000);

}
/* GPIO配置
（1）GPIO_Mode_AIN 模拟输入 
（2）GPIO_Mode_IN_FLOATING 浮空输入
（3）GPIO_Mode_IPD 下拉输入 
（4）GPIO_Mode_IPU 上拉输入 
（5）GPIO_Mode_Out_OD 开漏输出
（6）GPIO_Mode_Out_PP 推挽输出
（7）GPIO_Mode_AF_OD 复用开漏输出 
（8）GPIO_Mode_AF_PP 复用推挽输出
GPIO_Speed_10MHz 最高输出速率10MHz 
GPIO_Speed_2MHz 最高输出速率2MHz 
GPIO_Speed_50MHz 最高输出速率50MHz
 */
void IBD_GpioInit(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO | RCC_APB2Periph_GPIOA | RCC_APB2Periph_GPIOB | RCC_APB2Periph_GPIOC, ENABLE); 
	GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable, ENABLE); //PA13/14/15 & PB3/4 设置为IO脚	
	GPIO_InitStructure.GPIO_Pin = (Key1_pin | Key2_pin | Key3_pin |  Key4_pin | Key5_pin);/*in*/
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(GPIOA, &GPIO_InitStructure);	
	
	GPIO_InitStructure.GPIO_Pin = (SEG_data | SEG_sfclk | SEG_clr); /*out*/
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP ;
	GPIO_Init(GPIOA, &GPIO_InitStructure);	
	
	
	GPIO_InitStructure.GPIO_Pin = (SEG_stclk | LED_data | LED_stclk |LED_sfclk | LED_clr );/*out*/
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP ;
	GPIO_Init(GPIOB, &GPIO_InitStructure);	


}

void Led_Driver(uint8_t LedValue)
{
 int i;
	 uint8_t tempShift=LedValue;
	
	 /*GPIO_ResetBits(GPIOB,LED_stclk);*/
	 GPIO_SetBits(GPIOB,LED_clr);
	 GPIO_ResetBits(GPIOB,LED_sfclk);
	 GPIO_ResetBits(GPIOB,LED_data);
	 delay_us(1);
	 
	 for(i=0;i<8;i++)
	 {  // set data ready
		
			if(tempShift & 0x80)
			{
					GPIO_SetBits(GPIOB,LED_data);
			}
			else
			{
			    GPIO_ResetBits(GPIOB,LED_data);
			}
			// give shift_clk
		
			GPIO_ResetBits(GPIOB,LED_sfclk);
			tempShift <<= 1;
		  delay_us(2);
	    GPIO_SetBits(GPIOB,LED_sfclk);
		  delay_us(1);
	 }
	 	GPIO_SetBits(GPIOB,LED_stclk);
		 delay_us(2);
		GPIO_ResetBits(GPIOB,LED_stclk);
	 delay_us(1);
}
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
	

/*********************************SEG*********************************************/
void SEG_Driver(uint8_t const LedValue)
{
 int i;
	 uint8_t tempShift=LedValue;
	
	 /*GPIO_ResetBits(GPIOB,SEG_stclk);*/
	 GPIO_SetBits(GPIOA,SEG_clr);
	 GPIO_ResetBits(GPIOA,SEG_sfclk);
	 GPIO_ResetBits(GPIOA,SEG_data);
	 delay_us(1);
	 
	 for(i=0;i<8;i++)
	 {  // set data ready
	
			if(tempShift & 0x80)
			{
					GPIO_SetBits(GPIOA,SEG_data);
			}
			else
			{
			    GPIO_ResetBits(GPIOA,SEG_data);
			}
			// give shift_clk
		

			tempShift <<= 1;
		  GPIO_ResetBits(GPIOA,SEG_sfclk);//0
		  delay_us(2);
			GPIO_SetBits(GPIOA,SEG_sfclk);//1
			delay_us(1);
	 }
	/* 	GPIO_SetBits(GPIOB,SEG_stclk);
		delay_ms(1);
		GPIO_ResetBits(GPIOB,SEG_stclk);*/

}
void SEG1_driver(uint8_t const data,uint8_t const Position)
{


	SEG_Driver(data);		
	SEG_Driver(Position);		
	GPIO_ResetBits(GPIOB,SEG_stclk);
  delay_us(2);
  GPIO_SetBits(GPIOB,SEG_stclk);
	delay_us(1);

}
void SEG4_Display (void)
{
	SEG1_driver(SEG_Table[Ibd800.segtime[0]],    segbit[0]);
	delay_ms(1);
  SEG1_driver(SEG_Table_dp[Ibd800.segtime[1]], segbit[1]);
	delay_ms(1);
	SEG1_driver(SEG_Table[Ibd800.segtime[2]],    segbit[2]);
	delay_ms(1);
	SEG1_driver(SEG_Table[Ibd800.segtime[3]],    segbit[3]);
	delay_ms(1);

}

void SEG4_Display_mask (void)
{
	SEG1_driver(0x40,    segbit[0]);
	delay_ms(1);
  SEG1_driver(0x40, segbit[1]);
	delay_ms(1);
	SEG1_driver(0x40,    segbit[2]);
	delay_ms(1);
	SEG1_driver(0x40,    segbit[3]);
	delay_ms(1);

}

