#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "IBD_type.h"
#include "Display_data.h"
#include "drawPic.h"
#include "dispChar.h"
#include "Hg25664.h"
#include "KeyLed.h"
#include "CommWithFPGA.h"
#include "stdio.h"
#include "KeyLed.h"
#include "delay.h"
#include  "masterSPI3.h"

unsigned char AES3_lock;
unsigned int TimerCounter=0;
unsigned int TimerLedCounter;
unsigned int TimerDumpCounter;
extern uint8_t	KeyValue;
extern uint8_t Key_messege;
extern uint8_t key_dump_tmp;
extern uint8_t Key_Sneeze_status;
unsigned char  disp =0 ;
unsigned char bootflage;
/***********************************************************************
*
************************************************************************/
#define bootstarting  0x01
#define bootend				0x00
void WaitBoot(void)
{
		if(device_boot < BOOTOK)
		{
			Fill_RAM(0x00); 
			show_string(24,48,"IBD800 BOOTING......",FONT816,NORMAL);
			OLED_Status.cursor = 0;
			OLED_Status.mainPageCurror = 0;
			OLED_Status.InPutCurror =0;
			setListenHeadPhone(OLED_Status.InPutCurror);
			Led_Driver(0);
			bootflage=bootstarting;
			if(Key_Lock_Scan()&0x01)
					OLED_Status.page = pageMain;
			else 
					OLED_Status.page = pageDelay;
				;
		}
	//show_string(32,100,"BOOTING......",FONT816,NORMAL);
	do  {
			ReadBootMode();
	}
	while(device_boot < BOOTOK);
}
/*********************************************************************/

/*****************************************************************/
void DisplayKeyLed(unsigned char mode,float delayTime)
{
	
	 if(Key_Sneeze_status == ON)
		{
			Led_Status.sneeze = BLINK;
		}
		else
		{
			Led_Status.sneeze = ON;
		}
	
	if(delayTime >=  IBD200TimePara.dumptime)
					 {
						 Led_Status.dump = ON;
					 }
			else 	 Led_Status.dump = OFF;
				
	switch(mode)
	{
		case BOOT:
		case BYPASS: {
					 Led_Status.bypass = BLINK;
					 Led_Status.dump = OFF;
					// Led_Status.music = OFF;
					// Led_Status.panic = OFF;
					 Led_Status.ramtozero = OFF;
					 Led_Status.rebuild = OFF;
					 Led_Status.sneeze = OFF;
		} break;
		
		case  ZERO_IDLE:
		case	ZEROTOZERO:
		case	ZEROBUILDING:
			{
					 Led_Status.bypass = OFF;
					//Led_Status.music = OFF;
					// Led_Status.panic = ON;
					 Led_Status.rebuild = ON;
					 Led_Status.sneeze = OFF;
				   Led_Status.ramtozero = OFF;
					 
				 } break;
			case MIDIDLE: {
					 Led_Status.bypass = OFF;
					 Led_Status.rebuild = ON;
				   Led_Status.ramtozero = ON;
			 	 } break;	
			case FULL_IDLE:
			case FULLTOZERO:
			case FULLBUILDING:
				{
					 Led_Status.bypass = OFF;
					 Led_Status.rebuild = OFF;
				   Led_Status.ramtozero = ON;
			 	 } break;	
		
		case MIDBUILDING: { 
					 Led_Status.bypass = OFF;
					// Led_Status.music = OFF;
					// Led_Status.panic = ON;
 					 Led_Status.rebuild = BLINK;
					 Led_Status.ramtozero = ON;

				 } break;
		case MIDTOZERO:
		{
				   Led_Status.bypass = OFF;
 					// Led_Status.music = OFF;
					// Led_Status.panic = ON;
 					 Led_Status.rebuild = ON;
					 Led_Status.ramtozero = BLINK;
		};break;
		default:
				{
					 Led_Status.bypass = OFF;
					 Led_Status.dump = OFF;
					// Led_Status.music = OFF;
					// Led_Status.panic = OFF;
					 Led_Status.ramtozero = OFF;
					 Led_Status.rebuild = OFF;
					 Led_Status.sneeze = OFF;
				}break;
	}
}



/*******************************************************************
*
*
********************************************************************/
void dispPageFont(FramDataStruct const *FramData, int FramDataLen)
{
	int i;
	for(i=0;i<FramDataLen;i++)
	{
		 show_string (
		                (FramData+i)->x,(FramData+i)->y, (FramData+i)->buff,
										(FramData+i)->resolution,(FramData+i)->normalOrInverse
		               );
	}
}

/******************************************************************************/
void DispLabel(unsigned char startY)
{
	unsigned char i =0;
	unsigned char j =0;
	for(i=1;i<62;i=i+2)
	{
		if(j++ %5 == 0)
		{
			drawLine(i,startY,i,startY+8,Meter_on);
		}
		else
		{
			drawLine(i,startY,i,startY+4,Meter_on);
		}
	}
}

/******************************************************************/
void DispPageMain(void)
{

	dispPageFont(MainPageFramData,MainPageFramDataLen);

	drawRect(0,16,28,82);
	drawRect(33,16,61,82);
	
	drawRect(0,90,28,152);
	drawRect(33,90,61,152);
	
	drawRect(0,156,28,212);
	drawRect(33,156,61,212);
}
/********************************************************************/
void DispMainPageCusor(unsigned char Cursor)
{
	unsigned char i;
//	Position Location[12] = {20,20,20,92,20,160,52,20,52,92,52,160};
	if(Cursor <= 6)
	{
		/*DisplayContent(FONT88,">",1,Location[Cursor-1].x,Location[Cursor-1].y,NORMAL);
		for(i=0;i<6;i++)
		{
			if(i != (Cursor-1))
			{
				DisplayContent(FONT88," ",1,Location[i].x,Location[i].y,NORMAL);
			}
		}
		*/
		for(i = 0;i<6;i++) 
		{
			MainPageFramData[i].normalOrInverse = NORMAL;
		}
		  MainPageFramData[Cursor-1].normalOrInverse = REVERSE;
	}
	/*else if(Cursor == 0)
	{
		for(i=0;i<6;i++)
		{
			DisplayContent(FONT88," ",1,Location[i].x,Location[i].y,NORMAL);
		}
	}*/
}
/**********************************************************************************************/
void DispMainPageVu(unsigned char startX,unsigned startY,unsigned char VuL,unsigned char VuR)
{
	if(startX > 60) startX = 60;
	if(startY > 251) startY = 251;
	
	//DispLabel(startY);
	drawMeterBar(startX,startY+16,VuL,VuR); // call the displayMainContent intervally
}
/**********************************************************************************************/
/***********************************************************************************************/

/************************************************************/
void DispPage1Frame(void)
{
	dispPageFont(Page1Data,PageINPUTDataLen);
}
//****************************************************************************
void DispAES3Lock(unsigned char lock_or_not)
{
//	unsigned char i;
  char lock[] = "LOCKED";
  char unlock[] = "UNLOCK";
	char *pointer;
	
	if(lock_or_not)
		{
			pointer = lock;
		}
		else
		{
			pointer = unlock;
		}
		show_string(Page1Data[3].x,Page1Data[3].y,pointer,FONT816,NORMAL);
}
/************************************************************/
void DispPage1Content(IBS300InputType *IBD200Status,uint8_t cursor)
{
//	unsigned char i;
//	char temp[3];
	FONT_MODE  fontmode[3];
//NORMAL_REREVERSE
	unsigned char j=1;
  char TypeEnum[7][7] = {"AES3  ","ANALOG","AOIP-1","AOIP-2","AOIP-3","AOIP-4","OUTPUT"};
	char TypeMusci[3][8]={"Disable","Enable "};
	fontmode[0]=NORMAL;
	fontmode[1]=NORMAL;
	fontmode[2]=NORMAL;
	if((cursor<4) && (cursor > 0))
		fontmode[cursor -1]=REVERSE;
	show_string(Page1Data[j].x,Page1Data[j].y,&TypeEnum[IBD200Status->type][0],FONT816,fontmode[0]);
	j=3;
	show_string(Page1Data[j].x,Page1Data[j].y,&TypeMusci[IBD200Status->music][0],FONT816,fontmode[1]);
	j=5;
	show_string(Page1Data[j].x,Page1Data[j].y,&TypeEnum[IBD200Status->ch_num][0],FONT816,fontmode[2]);

	// display audio input type
 /*	for(i=0;i<PageINPUTDataLen;i++)
	{
		if(i==j) 
		{
			show_string(Page1Data[j].x,Page1Data[j].y,&TypeEnum[IBS300InputStatus[j/4].type][0],FONT816,NORMAL);
			j = j+4;
		}
	}*/
	// display input audio channel
	/*j = 2;
	for(i=0;i<PageINPUTDataLen;i++)
	{
		if(i == j)
		{
			temp[0]= temp[1] = 0;
			sprintf(temp,"%d",IBS300InputStatus[j/4].ch_num);
			show_string(Page1Data[j].x,Page1Data[j].y,temp,FONT816,NORMAL);
			j = j+4;
		}
	}*/
	//DispAES3Lock(AES3_lock);
}

void DispPageMeter(MeterSTR meter)
{
	unsigned char i;
	for(i=0;i<6;i++)
	{
//		if(IBS300InputStatus[i].type == NOSRC)
//			continue;
		
		drawMeterBar(AinVuPosition[i].x,AinVuPosition[i].y,meter.vu[i*2],meter.vu[i*2+1]); // INPUT VU
	}
	drawMeterBar(48,236,meter.vu[16],meter.vu[17]); //OUT VU
}
//------------------------------------------------------

void DispCorrFrame(void)
{
	dispPageFont(PageMeterCorrData,PageMeterCorrDataLen);
}
void DispCorrContent(float *corr)
{
  char temp[8] ;
	unsigned char i;
	if(corr == NULL)
		return ;
	else
	{
		for(i=0;i<6;i++)
		{
			//if (i==6) continue;
			sprintf(temp,"%6.3f",*(corr+i));
			show_string(PageMeterCorrData[i].x,PageMeterCorrData[i].y+40,temp,FONT816,NORMAL);
		}
	}
}
//****************************************************************************

void DispC_IPFrame(void)
{
	dispPageFont(PageC_IPData,PageC_IPFrameLen);
}
void DispC_IPContent(IpObject ArmIp)
{
	 char temp[20];
//	 unsigned char i;
	
	 sprintf(temp,"%d.%d.%d.%d    ",ArmIp.localIp[0],ArmIp.localIp[1],ArmIp.localIp[2],ArmIp.localIp[3]);
	 show_string(PageC_IPData[1].x,PageC_IPData[1].y,temp,FONT816,NORMAL);
	 
	 sprintf(temp,"%d.%d.%d.%d    ",ArmIp.netmask[0],ArmIp.netmask[1],ArmIp.netmask[2],ArmIp.netmask[3]);
	 show_string(PageC_IPData[3].x,PageC_IPData[3].y,temp,FONT816,NORMAL);
	 
   sprintf(temp,"%d.%d.%d.%d    ",ArmIp.gateway[0],ArmIp.gateway[1],ArmIp.gateway[2],ArmIp.gateway[3]);
	 show_string(PageC_IPData[5].x,PageC_IPData[5].y,temp,FONT816,NORMAL);
}
/*********************************************************************/
//****************************************************************************

void DispAOIPFrame(unsigned char page)
{
	if(page == 0)
	{
		dispPageFont(PageAOIPData,6);
	}
	else
	{
		dispPageFont(&PageAOIPData[6],8);
	}
}
void DispAOIPContent(DanteIpObj DtIp,IBS300NameStr DtName,unsigned char cursor)
{
	char temp[25];
	unsigned char i;
	if(cursor == 0)
	{
		sprintf(temp,"%s  ",DtName.LocalDanteName);
		show_string(PageAOIPData[1].x,PageAOIPData[1].y,temp,FONT816,NORMAL);
		

		sprintf(temp,"%d.%d.%d.%d    ",DtIp.masterIp[0],DtIp.masterIp[1],DtIp.masterIp[2],DtIp.masterIp[3]);
 	  show_string(PageAOIPData[3].x,PageAOIPData[3].y,temp,FONT816,NORMAL);
		
		sprintf(temp,"%d.%d.%d.%d    ",DtIp.slaveIp[0],DtIp.slaveIp[1],DtIp.slaveIp[2],DtIp.slaveIp[3]);
    show_string(PageAOIPData[5].x,PageAOIPData[5].y,temp,FONT816,NORMAL);
	}
	else
	{
		for(i=0;i<4;i++)
		{
				sprintf(temp,"%s    ",DtName.AOIPName[i]);
				show_string(PageAOIPData[7+2*i].x,PageAOIPData[7+2*i].y,temp,FONT816,NORMAL);
		}
	}
}
/*********************************************************************/

void DispPageParaFrame(void)
{
	dispPageFont(PageParaData,pageParaFrameLen);
}
void DispParaContent(IBD200PARA_STR timePara)
{
	#define pageParaDispStrLen (8)
	unsigned char i;
	char temp[pageParaDispStrLen] ={0,0,0,0,0,0,0,0};
	FONT_MODE  fontmode[2];
	fontmode[0]=NORMAL;
	fontmode[1]=NORMAL;
	if((OLED_Status.cursor<3) && (OLED_Status.cursor > 0))
		fontmode[OLED_Status.cursor -1]=REVERSE;
	sprintf(temp,"%4.1f",timePara.maxtime);
	show_string(PageParaData[1].x,PageParaData[1].y,temp,FONT816,fontmode[0]);
	
	for(i=0;i<pageParaDispStrLen;i++) {temp[i] = 0;}
	sprintf(temp,"%4.1f",timePara.dumptime);
	show_string(PageParaData[4].x,PageParaData[4].y,temp,FONT816,fontmode[1]);
	
	for(i=0;i<pageParaDispStrLen;i++) {temp[i] = 0;}
	sprintf(temp,"%4.1f  ",timePara.buildtime);//
	temp[7]=0;//这2行修改是为了显示
	show_string(PageParaData[7].x,PageParaData[7].y,temp,FONT816,NORMAL);
	

		
	for(i=0;i<pageParaDispStrLen;i++) {temp[i] = 0;}
	sprintf(temp,"%4.1f",timePara.safetime);
	show_string(PageParaData[10].x,PageParaData[10].y,temp,FONT816,NORMAL);
	
}
/********************************************************************/

void DispPageMeterFrame(void)
{
	dispPageFont(PageMeterData,PageMeterFrameLen);
}
/********************************************************************/

/********************************************************************/
void displayDelay(float time)
{
	unsigned int num;
	unsigned char num4bit[4] = {0,0,0,0};
	if(num > 100)
				num =0;    //max num =100
	num = (time *100);
  num4bit[3] = num % 10;  
	num = num / 10; 
	num4bit[2] = num % 10; 
	num = num / 10; 	
	num4bit[1] = num % 10;  
	num = num / 10; 
	num4bit[0] = num % 10;  
	
	show_string(40,104,".",FONT816,NORMAL);
	if(num4bit[0] >= 1)
	{
		drawBigNum(4,4,num4bit[0]);
	}
	else
	{
		drawBigNum(4,4,0x0B);
	}
	drawBigNum(4,64,num4bit[1]);
	drawBigNum(4,124,num4bit[2]);
	drawBigNum(4,184,num4bit[3]);
}
void displayMute(void)
{
	show_string(20,112,"MUTE",FONT816,NORMAL);
}
void DispPageAlarmFrame(void)
{
	show_string(2,16,"   ",FONT816,NORMAL);
}
/*----------------------------------------------*/
void DispPageDelayContent(unsigned char mode,float time)
{
	
	if((mode == BYPASS) || (mode == BOOT))
		
		{ 
			if(!disp)
			{
			Fill_RAM(0x00);
			drawDelayMask();
			disp =1;
			}
		}
  else 
		{
		displayDelay(time);
		disp=0;
		}
	
	
}
#define FPGA_Listen           (0X19) 
/*******************************************************************/

	
/*******************************************************************
* Oled Display MainApp
********************************************************************/
void OledDispFrame(unsigned char page)
{
	switch(page)
	{
		case pageMain: {
											
											DispMainPageCusor(OLED_Status.cursor);
											DispPageMain();
											drawRect(0,224,63,252);
											/*display IBS300 and the output VU*/};break;
		case pageINPUT: {
											DispPage1Frame();
											/*display 8 input channel type and priority*/};break;
		case pageC_IP: { 
			               DispC_IPFrame(); 
		               };break;
		case pageAOIP: {
										 DispAOIPFrame(OLED_Status.cursor);
									 };break;
		case pageMETER: {
											if(OLED_Status.cursor)
											{
												DispCorrFrame();
											}
											else
											{
												DispPageMeterFrame();
											}
										};break;
		case pagePARA: {
											DispPageParaFrame();
		                 
									 };break;
		case pageDelay: {
											
											DispPageAlarmFrame();/*display alarm message*/
										};break;
		
	}
	TimerCounter = 0;
}
void OledContentRefresh(unsigned char page)
{

	switch(page)
	{
		case pageMain: {
											disp=0;
		                  if(TimerCounter++ == MS20)
											{
													TimerCounter = 0;
													readOutVu();
													DispMainPageVu(58,212,IBS300Meter.vu[16],IBS300Meter.vu[17]);
											}
									 }break;
		case pageINPUT:{
											if(TimerCounter++ == MS100)
											{
													TimerCounter = 0;
													readSrcInputStatus();
												//  readAESStatus();
													DispPage1Content(&IBD200Status,OLED_Status.cursor);
											}
									};break;
		case pageC_IP: { 
											if(TimerCounter++ == MS100)
											{
													TimerCounter = 0;
													readARMIp();
													DispC_IPContent(IBS300ArmIP);
											}
		               };break;
		case pageAOIP: {
											if(TimerCounter++ == MS100)	
											{
												  TimerCounter = 0;
													if(OLED_Status.cursor)
													{
														readAOIPDanteName();
													}
													else
													{
														readDanteIp();
														readLocalDanteName();
													}
													DispAOIPContent(IBS300DanteIp,IBS300Name,OLED_Status.cursor);
											}
									 };break;
		case pageMETER:{
												if(OLED_Status.cursor)
												{
													if(TimerCounter++ == MS100)
													{
														TimerCounter = 0;
														readCorrFromFpga(&IBS300Meter);
														DispCorrContent(IBS300Meter.corr);
													}
												}
												else
												{
													if(TimerCounter++ == MS20)
													{
														TimerCounter = 0;
														readAllVu();
														DispPageMeter(IBS300Meter);
													}
												}
		               };break;
		case pagePARA: {
											if(TimerCounter++ == MS100)
											{
												TimerCounter = 0;
												//readTimePara();
											//	GetTimePara();
												DispParaContent(IBD200TimePara);
											}
									 };break;
		case pageDelay: {
					
					
					 if(TimerCounter++   == MS20)
					 {
								TimerCounter =0;
								if(delay_mode > BYPASS)
								{
									disp=0;
									dsipaly_selvu();
									readOutVu();
									drawMeterBar(48,232,IBS300Meter.vu[16],IBS300Meter.vu[17]);
							  }	
							}
							GetDelayTime();
							DispPageDelayContent(delay_mode,delay_time);
						}; break;
						 
		default: break;
		}
}
/*********************************************************************/
#define pagemain_lock  1
#define pagedelay_lock 2
void IBD_Fun(void)
{
	unsigned char static currentPage;	
	unsigned char static currentCursor;
  unsigned char key_lock_tmp;

	GetTimePara();
	ReadMode();
	key_process();
	if(key_dump_tmp )
		{
		  if(TimerDumpCounter++ ==MS100)
			{   
			  key_dump_tmp =0;
				TimerDumpCounter=0;
			}
			
		}
			key_lock_tmp  =Key_Lock_Scan();
		if(key_lock_tmp == pagedelay_lock)            //
			{	
				OLED_Status.page = pageDelay;
			 }
		else if( key_lock_tmp == pagemain_lock )
			{	
				OLED_Status.page = pageMain;
			  OLED_Status.cursor =0;
			  OLED_Status.mainPageCurror=0;
			}
		
	if( (currentPage != OLED_Status.page) || (currentCursor != OLED_Status.cursor) || bootflage)
		{
				Fill_RAM(0x00);
				OledDispFrame(OLED_Status.page);
			  currentPage = OLED_Status.page;
			  currentCursor = OLED_Status.cursor;
				bootflage = bootend;
		} 
		
	if(TimerLedCounter++ == MS200)
							{
								
								TimerLedCounter=0;
								GetDelayTime();
								DisplayKeyLed(delay_mode,delay_time);
								Led_Display(&Led_Status);
					
							}
				
			 delay_ms(1);
//			BlinkCounter = 0;

		
		OledContentRefresh(OLED_Status.page);
//----------------------------------------

}


