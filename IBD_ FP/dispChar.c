#include "Hg25664.h"
#include "Font.h"
#include "dispChar.h"

/***********************************************************
*
*
************************************************************/

/************************************************
ת��������D7=1,һλת������λ
************************************************/
void change	(unsigned char m,FONT_MODE NormalOrReverse)
{
  unsigned char i;
  unsigned char kk,kkk;
	unsigned char data_4byte[4];
  kk=m;
  for(i=0;i<4;i++)     // һ��λ�ķ�ʽд��  2*4=8λ
   {
     kkk=kk&0xc0;     //��i=0ʱ ΪD7,D6λ ��i=1ʱ ΪD5,D4λ

     /****����4�ֿ��ܣ�16��ɫ��,һ����ַ�������أ�һ�����ض�Ӧ4λ***/

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
    kk=kk<<2;                                //������λ
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
 д��һ��8*8���ַ�
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
����ʾ����дһ��8*16���ַ�
// ����ģ��tab816(1ά����),
//�����꣨x���꣩��y���꣩λ����ʾһ���֣����Ͻ����꣩��
//����x�������Ϊż����
//��ռrow�У�һ��col�㡣
//���϶��嶼��unsigned charȫ�ֱ�����SSD1322
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
	Set_Column_Address(AdjustEndY,AdjustEndY+1);   //set start and end column 1����ַ����4����ʾ��  8����ʾ����Ҫ2����ַ
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



