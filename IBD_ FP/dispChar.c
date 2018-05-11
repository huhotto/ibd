#include "Hg25664.h"
#include "Font.h"
#include "dispChar.h"

/***********************************************************
*
*
************************************************************/

/************************************************
转换函数，D7=1,一位转换成四位
************************************************/
void change	(unsigned char m,FONT_MODE NormalOrReverse)
{
  unsigned char i;
  unsigned char kk,kkk;
	unsigned char data_4byte[4];
  kk=m;
  for(i=0;i<4;i++)     // 一两位的方式写入  2*4=8位
   {
     kkk=kk&0xc0;     //当i=0时 为D7,D6位 当i=1时 为D5,D4位

     /****出现4种可能，16阶色素,一个地址两个像素，一个像素对应4位***/

     switch(kkk)
     {
			case 0x00:
           data_4byte[i]=0x00;
         break;
      case 0x40:
           data_4byte[i]=0x0f;
         break;
			case 0x80:
           data_4byte[i]=0xf0;
         break;
      case 0xc0:
           data_4byte[i]=0xff;
         break;
      	 default:
      	 break;
	   }
    kk=kk<<2;                                //左移两位
		if(NormalOrReverse == REVERSE)
		{
			Write_dat(~data_4byte[i]); 
		}
		else	
    {
			Write_dat(data_4byte[i]); 
		}               /* 8 column  a nibble of command is a dot*/
   }
}
/*********************************************************
 写入一行8*8的字符
**********************************************************/
void write_oled8(unsigned char x,unsigned char y,unsigned char coder,FONT_MODE NormalOrReverse)
{
 unsigned char dat;
	  unsigned char i;
		 unsigned char AdjustEndY;

		if(x > 63 || y > 255)
		{
			return;
		}
		AdjustEndY   = y/4 + 0x1C;
//-------------------draw top line-----------------------------
    Set_Remap_Format(0x14);                        //horizontal increasement
	  Set_Column_Address(AdjustEndY,AdjustEndY+1);   //set start and end column
	  Set_Row_Address(x,x+8);		                     //set start and end line
    Set_Write_RAM();

		for(i=0;i<8;i++)
		{
			dat=Font88[coder-32][i];
			change(dat,NormalOrReverse);
		}
}
/**********************************************************
在显示屏上写一个8*16的字符
// 用字模表tab816(1维数组),
//在坐标（x坐标）（y坐标）位置显示一行字（左上脚坐标），
//其中x坐标必须为偶数。
//字占row行，一行col点。
//以上定义都是unsigned char全局变量，SSD1322
************************************************************/
void write_oled816(unsigned char x,unsigned char y,unsigned char coder, FONT_MODE NormalOrReverse)
{
 unsigned char dat;
 unsigned char i;
 unsigned char AdjustEndY;

 if(x > 63 || y > 255)
 {
		return;
 }
	AdjustEndY   = y/4 + 0x1C;
//-------------------draw top line-----------------------------
  Set_Remap_Format(0x14);                        //horizontal increasement
	Set_Column_Address(AdjustEndY,AdjustEndY+1);   //set start and end column 1个地址包含4个显示点  8个显示点需要2个地址
	Set_Row_Address(x,x+16);		                     //set start and end line
  Set_Write_RAM();

 for(i=0;i<16;i++)
 {
    dat=Font816[coder-32][i];
	  change(dat,NormalOrReverse);
 }
}


/****************************************************************/
void show_string(unsigned char startX,unsigned char startY,
                   char *Data,FONT font, FONT_MODE NormalOrInverse)
{
unsigned char j=0;
while(1)
	{		
			if(*Data == 0) break;	
			if(font==FONT88)
								write_oled8(startX,startY+j,*Data,NormalOrInverse);
				else if(font==FONT816)
								write_oled816(startX,startY+j,*Data,NormalOrInverse);
				Data++;
				j+=8;
				
	}
}



