#include "Hg25664.h"
#include "drawPic.h"
#include "Font.h"
/*****************************************************************************************
* rectangle line framework
*******************************************************************************************/
void drawRect(unsigned char startX,unsigned char startY,unsigned char endX,unsigned char endY)
  {
     unsigned char i;
		 unsigned char AdjustStartY,AdjustEndY;
		 unsigned char integerY,fracY;

		if(startX > 63 || endX > 63 || startY > 255 || endY > 255)
		{
			return;
		}
		integerY = (endY-startY)/4;
		fracY    = (endY-startY) % 4;
		
		AdjustStartY = startY/4 + 0x1C;
		AdjustEndY   = endY/4   + 0x1C;

//-------------------draw top line-----------------------------
    Set_Remap_Format(0x14);          //horizontal increasement
		
	  Set_Column_Address(AdjustStartY,AdjustEndY);   //set start and end column
	  Set_Row_Address(startX,startX);		             //set start and end line

    Set_Write_RAM();

		for(i=0;i<integerY;i++)
		{
			 Write_dat(0xff);
			 Write_dat(0xff);
		}
 		 switch(fracY)
		 {
			 case 0: break;
			 case 1: {Write_dat(0xf0);Write_dat(0x00);}break;
			 case 2: {Write_dat(0xff);Write_dat(0x00);}break;
			 case 3: {Write_dat(0xff);Write_dat(0xf0);}break;
			 default : break;
		 }
  
//--------------------draw bottom line-------------------------
		Set_Remap_Format(0x14);
		 Set_Column_Address(AdjustStartY,AdjustEndY);   //set start and end column
	  Set_Row_Address(endX,endX);		             //set start and end line
    
		Set_Write_RAM();

		for(i=0;i<integerY;i++)
		{
			 Write_dat(0xff);
			 Write_dat(0xff);
		}
 		 switch(fracY)
		 {
			 case 0: break;
			 case 1: {Write_dat(0xf0);Write_dat(0x00);}break;
			 case 2: {Write_dat(0xff);Write_dat(0x00);}break;
			 case 3: {Write_dat(0xff);Write_dat(0xf0);}break;
			 default : break;
		 }
//-------------------draw left line ---------------------------
    Set_Remap_Format(0x15);
	  Set_Column_Address(AdjustStartY,AdjustStartY); //set start and end column
	  Set_Row_Address(startX+1,endX-1);		             //set start and end line
    
		Set_Write_RAM();
    
		for(i=0;i<(endX-startX)-1;i++)
		{
			Write_dat(0xf0);
			Write_dat(0x00);
		}
//-----------------draw right line----------------------------
	  Set_Remap_Format(0x15);
		if(fracY == 0)
		{	
			Set_Column_Address(AdjustStartY+integerY-1,AdjustStartY+integerY); 
		}
		else
		{
			Set_Column_Address(AdjustStartY+integerY,AdjustStartY+integerY); 
		}
		Set_Row_Address(startX+1,endX-1);		             //set start and end line
		
    Set_Write_RAM();
		for(i=0;i<(endX-startX)-1;i++)
		{
 		 switch(fracY)
		 {
			 case 0: {Write_dat(0x00);Write_dat(0x0f);}break;
			 case 1: {Write_dat(0xf0);Write_dat(0x00);}break;
			 case 2: {Write_dat(0x0f);Write_dat(0x00);}break;
			 case 3: {Write_dat(0x00);Write_dat(0xf0);}break;
			 default : break;
		 }
		}
//-------------------------------------------------------------
    Set_Remap_Format(0x14);
}
/*************************************************************
* draw line Meter_on 
*
**************************************************************/
void drawLine(unsigned char startX,unsigned char startY,unsigned char endX,unsigned char endY,unsigned char data)
{
	   unsigned char i;
		 unsigned char AdjustStartY,AdjustEndY;
		 unsigned char integerY,fracY;

		if(startX > 63 || endX > 63 || startY > 255 || endY > 255)
		{
			return;
		}
		integerY = (endY-startY)/4;
		fracY    = (endY-startY) % 4;
		
		AdjustStartY = startY/4 + 0x1C;
		AdjustEndY   = endY/4   + 0x1C;
		
		if(startX == endX)             // draw horizon line
		{
				//-------------------draw top line-----------------------------
			Set_Remap_Format(0x14);          //horizontal increasement
			
			Set_Column_Address(AdjustStartY,AdjustEndY);   //set start and end column
			Set_Row_Address(startX,startX);		             //set start and end line

			Set_Write_RAM();

			for(i=0;i<integerY;i++)
			{
				 Write_dat(data);
				 Write_dat(data);
			}
			 switch(fracY)
			 {
				 case 0: break;
				 case 1: {Write_dat(0xf0);Write_dat(0x00);}break;
				 case 2: {Write_dat(0xff);Write_dat(0x00);}break;
				 case 3: {Write_dat(0xff);Write_dat(0xf0);}break;
				 default : break;
			 }
		}
		if(startY == endY)
		{
				Set_Remap_Format(0x15);
				Set_Column_Address(AdjustStartY,AdjustEndY); 
				Set_Row_Address(startX,endX);		             //set start and end line
				Set_Write_RAM();
				for(i=0;i<(endX-startX);i++)
				{
					 Write_dat(data);
				   Write_dat(0x00);
  			 }	
		}
}

/*******************************************************************
* draw a little block
*
********************************************************************/
void drawBlock(unsigned char startX,unsigned char startY,unsigned char howMany,unsigned char data)
{
		unsigned char i,j;
		unsigned char AdjustStartY;
	
		if(startX > 55 || startY > (254-8*howMany))
		{
			return;
		}
	
		AdjustStartY = startY/4 + 0x1C;
	  
		Set_Remap_Format(0x14);          //horizontal increasement
			

		for(j=0;j<howMany;j++)
		{	
			Set_Column_Address(AdjustStartY+j*2,AdjustStartY+j*2);   //set start and end column
		  Set_Row_Address(startX,startX+8);

		  Set_Write_RAM();
			for(i=0;i<8;i++)
			{
				Write_dat(data);
				Write_dat(data);
			}
		}
		
}

/********************************************************************/
void draw84Block(unsigned char startX,unsigned char startY,unsigned char data)
{
		unsigned char i;
		unsigned char AdjustStartY;
	
	  if(startX > 60) startX = 60;
		if(startY > 252) startY = 252;
	
		AdjustStartY = startY/4 + 0x1C;
		AdjustStartY = AdjustStartY + startY%4; 
	  
		Set_Remap_Format(0x14);          //horizontal increasement
			
		Set_Column_Address(AdjustStartY,AdjustStartY+1);   //set start and end column
	  Set_Row_Address(startX,startX+4);

	  Set_Write_RAM();
		for(i=0;i<8;i++)
		{
			Write_dat(data);
			Write_dat(data);
		}
}
/********************************************************************/
void drawMeterBar(unsigned char startX,unsigned char startY,unsigned char meterL,unsigned char meterR)
{
	unsigned char j;
	unsigned char intervalX,intervalY;

	if(meterL > VU_SEG_MAX) meterL = VU_SEG_MAX;
	if(meterR > VU_SEG_MAX) meterR = VU_SEG_MAX;
	
		intervalY = startY;
		intervalX = startX;
		for(j=0;j<meterL;j++)
		{
			draw84Block(intervalX,intervalY,Meter_on);
			intervalX = intervalX - 6;
		}
		for(j=meterL;j<VU_SEG_MAX;j++)
		{
			draw84Block(intervalX,intervalY,Meter_off);
			intervalX = intervalX - 6;
  	}
		
	 	intervalY = intervalY + 12;
		intervalX = startX;
		
		for(j=0;j<meterR;j++)
		{
			draw84Block(intervalX,intervalY,Meter_on);
			intervalX = intervalX - 6;
		}
		for(j=meterR;j<VU_SEG_MAX;j++)
		{
			draw84Block(intervalX,intervalY,Meter_off);
			intervalX = intervalX - 6;
  	}
}
/*********************************************************************/
void drawCorrBar(unsigned char startX,unsigned char startY,float corrValue)
{
	unsigned char i;
	unsigned short blockList =0;
	
	if(corrValue < 0)
	{
		if(corrValue < -0.8f)
		{
				blockList = 0x03E0;
		}
		else if(corrValue < -0.6f)
		{
				blockList = 0x01E0;
		}
		else if(corrValue < -0.4f)
		{
				blockList = 0x00E0;
		}
		else if(corrValue < -0.2f)
		{
				blockList = 0x0060;
		}
		else 
		{
				blockList = 0x0020;
		}
	}
	else
	{
		if(corrValue > 0.8f)
		{
				blockList = 0x001F;
		}
		else if(corrValue > 0.6f)
		{
				blockList = 0x001E;
		}
		else if(corrValue > 0.4f)
		{
				blockList = 0x001C;
		}
		else if(corrValue > 0.2f)
		{
				blockList = 0x0018;
		}
		else 
		{
				blockList = 0x0010;
		}
	}
	drawRect(startX-2,startY-4,startX+10,startY+80);
	blockList = blockList << 6;
	for(i=0;i<10;i++)
	{
		 if((blockList & 0x8000) == 0x8000)
		 {
			  drawBlock(startX,startY+i*8,1,Meter_on);
		 }
		 else
		 {
			  drawBlock(startX,startY+i*8,1,Meter_off);
		 }
		 blockList <<= 1;
	}
}
/****************************************************
* draw seven segment
*
*****************************************************/
void drawBigNum(unsigned char x,unsigned char y,unsigned char num)
{
	unsigned char i;
	unsigned char startx[7],starty[7],endx[7],endy[7];
//-----------------------------	
	startx[0] = x;
	startx[1] = x;
	startx[2] = x;
	startx[3] = x+4+segLen;
	startx[4] = x+4+2*segLen;
	startx[5] = x+4+segLen;
	startx[6] = x+2+segLen;
//-----------------------------
  starty[0] = y;
	starty[1] = y+4;
	starty[2] = y+8+segLen;
	starty[3] = y+8+segLen;
	starty[4] = y+4;
	starty[5] = y;
	starty[6] = y+4;
//------------------------------
  endx[0] = x+segLen;
	endx[1] = x;
	endx[2] = x+segLen;
	endx[3] = x+4+2*segLen;
	endx[4] = x+4+2*segLen;
	endx[5] = x+4+2*segLen;
	endx[6] = x+2+segLen;
//------------------------------
	endy[0] = y;
	endy[1] = y+4+segLen;
	endy[2] = y+8+segLen;
	endy[3] = y+8+segLen;
	endy[4] = y+4+segLen;
	endy[5] = y;
	endy[6] = y+4+segLen;

//------------------------------
	for(i = 0;i<7;i++)
	{
		if(FontbigNum[num][i] != 0)
		{
			drawLine(startx[i],starty[i],endx[i],endy[i],Meter_on);
		}
		else
		{
			drawLine(startx[i],starty[i],endx[i],endy[i],Meter_off);
		}

	}
}
//----------------------------------------------------
void drawDelayMask()
{
	drawBigNum(4,4,10);
	drawBigNum(4,64,10);
	drawBigNum(4,124,10);
	drawBigNum(4,184,10);
}
