/************************************************************
*                      Hg25664.c
*  It is a low level driver program of the oled25664
* Programmer : XiaoPo Dong            Version: V01
* HardWare platform:  STM32F405RG6    Compiler: MDK5.12
* Time: 2015-8-12
**************************************************************/
#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "delay.h"
#include "Hg25664.h"

#define SET_COLUMN_ADDR  					(0x15)
#define SET_LINE_ADDR    					(0x75)
#define WRITE_RAM_EN     					(0x5c)
#define SET_DCOM_REMAP   					(0xA0)
#define SET_DISP_START_LINE			  (0xA1)
#define SET_DISP_OFFSET  					(0xA2)
#define SET_DISP_ALLOFF  					(0xA4)
#define SET_DISP_ALLON   					(0xA5)
#define SET_DISP_NORMAL  					(0xA6)
#define SET_DISP_REVERSE 					(0xA7)
#define EXIT_PARTIAL_DISPLAY  		(0xA9)
#define SET_INTER_VDD_REGULATOR   (0xAB)
#define OLED_DISP_OFF    					(0xAE)
#define OLED_DISP_ON     				  (0xAF)
#define SET_PHASE_LEN    					(0xB1)
#define SET_OSC_FREQ     					(0xB3)
#define SET_GPIO        				  (0xB5)
#define SET_2nd_PreCharge_PERIOD  (0xB6)
#define SET_GRAY_TABLE   					(0xB8)
#define SET_PRECHARGE_VOLT 				(0xBB)
#define SET_VCOMH_VOLT   					(0xBE)
#define ENABLE_GRAY_TABLE 				(0x00)
#define SET_CONTRAST_CURRENT  		(0xC1)
#define SET_MASTE_CURRENT 				(0xC7)
#define SET_MULTIPLEX_RATIO  			(0xCA)
#define SET_CMD_LOCK     					(0xFD)


#define OLEDDATA (GPIO_Pin_0 | GPIO_Pin_1 | GPIO_Pin_2 | GPIO_Pin_3 | GPIO_Pin_4 | GPIO_Pin_5 | GPIO_Pin_6 | GPIO_Pin_7 )   //GPIOC
#define DATAPORT (GPIOC)
//----------------------------------------------------------
#define OLED_RST (GPIO_Pin_10)   //GPIOB(10)
#define OLED_DC  (GPIO_Pin_11)   //GPIOB(11)
#define OLED_WR  (GPIO_Pin_12)   //GPIOB(12)
#define OLED_RD  (GPIO_Pin_13)   //GPIOB(13)
#define CNTLPort (OLED_RST | OLED_DC | OLED_WR | OLED_RD ) 
#define CNTLPORT (GPIOB)
//-----------------------------------------------------------
#define OLED_CS  (GPIO_Pin_14)   //GPIOC(14)
#define OLED_CS_PORT  (GPIOC)

#define OLED_CMD   Bit_RESET			//0
#define OLED_DATA  Bit_SET				//1


/************************************************************
* Function :
* Finish the GPIO relatived with the OLED
* Used PORTC(0:7) and PORTB(10:13)
**************************************************************/
void OledGpioInit(void)
{
	GPIO_InitTypeDef GPIO_InitStruct;
	
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB|RCC_AHB1Periph_GPIOC, ENABLE);
	
  GPIO_InitStruct.GPIO_Pin  = OLEDDATA;
  GPIO_InitStruct.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_UP;
	GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
	
	GPIO_Init(GPIOC,&GPIO_InitStruct);
	
	GPIO_InitStruct.GPIO_Pin  = CNTLPort;
  GPIO_InitStruct.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
	
	GPIO_Init(GPIOB,&GPIO_InitStruct);
	
	GPIO_InitStruct.GPIO_Pin  = OLED_CS;
  GPIO_InitStruct.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
	
	GPIO_Init(GPIOC,&GPIO_InitStruct);
}
/*************************************************************
* Function : Write Data or CMD to OLED
* Parameters:  unsigned char Data, CMDorData
* retrival:   NO
**************************************************************/
void WriteToOled(unsigned char Data,BitAction CMDorData)
{
	// int i; Bit_RESET =0  Bit_SET  BSRR =BSRRL + BSRRH      BSRRL 写1 置位 写 0 无效   BSRRH 写1 清零 写 0 无效 

	 GPIO_WriteBit(CNTLPORT,OLED_DC,CMDorData);
	 GPIO_WriteBit(OLED_CS_PORT,OLED_CS,Bit_RESET);
	 GPIO_WriteBit(CNTLPORT,OLED_RD,Bit_SET);
	 GPIO_WriteBit(CNTLPORT,OLED_WR,Bit_RESET);
	 GPIO_Write(DATAPORT,Data);
	 //for(i=100;i>0;i--);
	 GPIO_WriteBit(CNTLPORT,OLED_WR,Bit_SET);
	 GPIO_WriteBit(OLED_CS_PORT,OLED_CS,Bit_SET);
}
/*************************************************************
* Function : Read Reg From OLED
* Parameters:  unsigned char RegAddress, the result
* retrival:   0: sucess, -1 : failure
**************************************************************/
void ReadFromOled(unsigned char RegAddr,unsigned char *Result)
{
	 int i;
	 GPIO_Write(DATAPORT,RegAddr);
	 GPIO_WriteBit(CNTLPORT,OLED_DC,Bit_SET);  //CMD
	 GPIO_WriteBit(OLED_CS_PORT,OLED_CS,Bit_RESET);
	 GPIO_WriteBit(CNTLPORT,OLED_WR,Bit_SET);
	 GPIO_WriteBit(CNTLPORT,OLED_RD,Bit_RESET);
	 for(i=100;i>0;i--);
	 GPIO_WriteBit(CNTLPORT,OLED_RD,Bit_SET);
	 *Result = GPIO_ReadInputData(DATAPORT) & 0xff;
	 for(i=100;i>0;i--);
	 GPIO_WriteBit(OLED_CS_PORT,OLED_CS,Bit_SET);
}
/*************************************************************/
int Write_cmd(unsigned char cmd)
{
	WriteToOled(cmd,OLED_CMD);
	return 0;
}
/******************************************************************/
int Write_dat(unsigned char data)
{
	WriteToOled(data,OLED_DATA);
	return 0;
}
/*******************************************************************/
/**************************************************************
* Set the Start column address,pixel
**************************************************************/
void Set_Column_Address(unsigned char a,unsigned char b)
{
	Write_cmd(SET_COLUMN_ADDR);			  // Set Column Address
	Write_dat(a);											//   Default => 0x00
	Write_dat(b);			  							//   Default => 0x77
}
/**************************************************************
* Set the Start column address,pixel
**************************************************************/
void Set_Row_Address(unsigned char a, unsigned char b)
{
	Write_cmd(SET_LINE_ADDR);			// Set Column Address
	Write_dat( a);								//   Default => 0x00
	Write_dat( b);								//   Default => 0x77
}
/****************************************************************
* Enable MCU write to RAM
*
*****************************************************************/
void Set_Write_RAM(void)
{
	Write_cmd(WRITE_RAM_EN);			// Enable MCU to Write into RAM
}
/*****************************************************************
*
*
******************************************************************/
void Set_Remap_Format(unsigned char data)
{
	Write_cmd(SET_DCOM_REMAP);			// Set Re-Map / Dual COM Line Mode
	Write_dat(data);							//   Default => 0x40
	Write_dat(0x11);							//   Default => 0x01 (Disable Dual COM Mode)
}
/******************************************************************/
/***************************************
* Fill Display RAM with same data
**************************************/

void Fill_RAM(unsigned char Data)
{
unsigned char i,j;

	Set_Column_Address(0x1c,0x5b);
	Set_Row_Address(0x00,0x3f);
	Set_Write_RAM();

	for(i=0;i<64;i++)
	{
		for(j=0;j<64;j++)
		{
			Write_dat(Data);
			Write_dat(Data);
		}
	}
}
/********************************************/
/******************************************************************
* OLED initialization
*
********************************************************************/
void OLED_Initialization(void)
{
	 OledGpioInit();   // initialize the gpio port	
	
	 GPIO_WriteBit(CNTLPORT,OLED_RST,Bit_RESET);
		delay_ms(150);
	 GPIO_WriteBit(CNTLPORT,OLED_RST,Bit_SET);
    delay_ms(50);                       // reset oled

	 Write_cmd(SET_CMD_LOCK);
		Write_dat(0x12);  							    // open the mcu communication
		
	 Set_Column_Address(0x1c,0x5b);				//256 columns
	 Set_Row_Address(0x00,0x3f);		 			//64 lines

	 Write_cmd(OLED_DISP_OFF);  						//  DISPLAY OFF,Sleep ON
		Write_cmd(SET_OSC_FREQ);  					// Set Osc frequency
		Write_dat(0x91);

	Write_cmd(SET_MULTIPLEX_RATIO); 
		Write_dat(0x3F);

	Write_cmd(SET_DISP_OFFSET);
		Write_dat(0x00);   							// rolling start address

	Write_cmd(SET_DISP_START_LINE);
		Write_dat(0x00); 

  Write_cmd(SET_DISP_NORMAL);	 		//Display normal

	Write_cmd(SET_DCOM_REMAP);
		Write_dat(0x14);
		Write_dat(0x11);  							//scan direction

	Write_cmd(SET_GPIO); 						//set gpio
		Write_dat(0x00);                

	Write_cmd(SET_INTER_VDD_REGULATOR);  
		Write_dat(0x01); 									//Enable internal Voltage regulator

	Write_cmd(0xB4); 									//Display Enhancement a
		Write_dat(0xA0);
		Write_dat(0xfd);   								//0xb5

	Write_cmd(SET_CONTRAST_CURRENT);   //Set Contrast Current
		Write_dat(0x7f); //9f

	Write_cmd(SET_MASTE_CURRENT);     //Master Contrast	Current Control
		Write_dat(0x0A);

	Write_cmd(SET_GRAY_TABLE);  //
		Write_dat(0x0c);
		Write_dat(0x18);
		Write_dat(0x24);
		Write_dat(0x30);
		Write_dat(0x3c);
		Write_dat(0x48);
		Write_dat(0x54);
		Write_dat(0x60);
		Write_dat(0x6c);
		Write_dat(0x78);
		Write_dat(0x84);
		Write_dat(0x90);
		Write_dat(0x9c);
		Write_dat(0xa8);
		Write_dat(0xb4);

	Write_cmd(ENABLE_GRAY_TABLE);
	
	Write_cmd(SET_PHASE_LEN); //Set Phase Length
		Write_dat(0xE2);

	Write_cmd(0xD1); //Display Enhancement B
		Write_dat(0xa2);
		Write_dat(0x20);// reverse Display

	Write_cmd(SET_PRECHARGE_VOLT);
		Write_dat(0x1F);

	Write_cmd(SET_2nd_PreCharge_PERIOD);
		Write_dat(0x08);

 	Write_cmd(SET_VCOMH_VOLT);
		Write_dat(0x07);//0.86VCC

 	Write_cmd(SET_DISP_NORMAL);
	Write_cmd(EXIT_PARTIAL_DISPLAY);
	Write_cmd(WRITE_RAM_EN);
	Fill_RAM(0x00);
  Write_cmd(OLED_DISP_ON);  				//OLED DISPLAY_ON, Exit Sleep mode
}

/******************end**********************/
