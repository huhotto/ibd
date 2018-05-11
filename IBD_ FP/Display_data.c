#include "IBD_type.h"
#include "Display_data.h"

float delay_time;
unsigned char IBS300AES3[3];
LED_STR Led_Status;
IBD200PARA_STR IBD200TimePara;
OLEDDispStatus OLED_Status;
MeterSTR IBS300Meter;
IBS300InputType IBD200Status;
DanteIpObj IBS300DanteIp;
IpObject IBS300ArmIP;
IBS300NameStr IBS300Name;
DelayMode delay_mode;
DeviceBoot device_boot;
/**********************************************************************************************/
/***********************************************************************************************/
/*************************Display Meter page*****************************/
//Y 坐标必须为4的倍数 不然地址会变成前面的那一个
const Position AinVuPosition[8] =
{
	48,12,  //CH1-2 VU L& R
	48,40, //3-4
	48,68, //5-6
	48,96, //7-8
	48,124, //9-10
	48,152, //11-12
	48,180, //13-14
	48,180  //15-16
};



/***************************************************************/
FramDataStruct  MainPageFramData[MainPageFramDataLen] = 
{
	6,28,  FONT816, NORMAL, "INPUT",     //16  
	6,104,  FONT816, NORMAL, "C-IP",
	6,170, FONT816, NORMAL, "AOIP",
	38,30, FONT816, NORMAL, "METER",
	38,104, FONT816, NORMAL, "PARA",
	38,166, FONT816, NORMAL, "DELAY",
	2,228, FONT88,NORMAL,"L",
  2,240, FONT88,NORMAL,"R"	
};
/****************************************************************/

FramDataStruct const Page1Data[PageINPUTDataLen] = 
{
	0,8,  FONT816, NORMAL, "Delay Input:",       
	0,116, FONT816, NORMAL, "    ",
	16,8, FONT816, NORMAL, "Music:",
	16,116,FONT816,NORMAL, "       ",
	32,8, FONT816, NORMAL, "HeadPhone:",
	32,116,FONT816,NORMAL, "      "
};

/************************************************************/
//------------------------------------------------------

FramDataStruct const PageMeterCorrData[PageMeterCorrDataLen] = 
{
	3,16,  FONT816, NORMAL, "AES:",       
	3,136, FONT816, NORMAL, "ANA:",
	23,16,  FONT816, NORMAL, "DT1:",       
	23,136, FONT816, NORMAL, "DT2:",
	43,16,  FONT816, NORMAL, "DT3:",       
	43,136, FONT816, NORMAL, "DT4:",


	/*50,16,  FONT816, NORMAL, " ",       
	50,56,  FONT816, NORMAL, "     ",
	50,136, FONT816, NORMAL, "MUS:",
	50,176, FONT816, NORMAL, "     ",*/
};
FramDataStruct const PageMeterData[PageMeterFrameLen] = 
{
	56,INIT, FONT88,NORMAL, "AES",
	56,INIT+OFFSET, FONT88,NORMAL, "ANA",
	56,INIT+2*OFFSET, FONT88,NORMAL, "DT1",
	56,INIT+3*OFFSET, FONT88,NORMAL, "DT2",
	56,INIT+4*OFFSET, FONT88,NORMAL, "DT3",
	56,INIT+5*OFFSET, FONT88,NORMAL, "DT4",
	//56,INIT+6*OFFSET, FONT88,NORMAL, "7",
	//56,INIT+6*OFFSET, FONT88,NORMAL, "SEL",
	56,232, FONT88,NORMAL, "OUT",	
};

//****************************************************************************

FramDataStruct const PageC_IPData[PageC_IPFrameLen] = 
{
	2,16,  FONT816, NORMAL, "IP:",       
	2,88, FONT816, NORMAL, "               ",
	
	20,16,  FONT816, NORMAL, "MASK:",       
	20,88, FONT816, NORMAL, "               ",

	38,16,  FONT816, NORMAL, "GateWay:",       
	38,88, FONT816, NORMAL, "               ",
};
//****************************************************************************

FramDataStruct const PageAOIPData[PageAOIPFrameLen] = 
{
	2,16, FONT816,NORMAL, "DT_Name:",
	2,88, FONT816,NORMAL," ",
	
	20,16, FONT816, NORMAL, "DT_IP1:",
	20,88, FONT816,NORMAL," ",
	
	38,16, FONT816,NORMAL,"DT_IP2:",
	38,88, FONT816,NORMAL,"",
	
	0,16,  FONT816, NORMAL, "AOIP1:",       
	0,72, FONT816, NORMAL, " ",
	
	16,16,  FONT816, NORMAL, "AOIP2:",       
	16,72, FONT816, NORMAL, " ",

	32,16,  FONT816, NORMAL, "AOIP3:",       
	32,72, FONT816, NORMAL, " ",
	
	48,16,  FONT816, NORMAL, "AOIP4:",       
	48,72, FONT816, NORMAL, " ",
};

FramDataStruct const PageParaData[pageParaFrameLen] = 
{
	0,8,FONT816,NORMAL,"Max   Time:",
	0,116,FONT816,NORMAL,"     ",
	0,172,FONT816,NORMAL,"S",
	16,8,FONT816,NORMAL,"Dump  Time:",
	16,116,FONT816,NORMAL,"     ",
	16,172,FONT816,NORMAL,"S",
	32,8,FONT816,NORMAL,"Build Time:",
	32,116,FONT816,NORMAL,"     ",
	32,172,FONT816,NORMAL,"S",
	48,8,FONT816,NORMAL,"Safe  Time:",
	48,116,FONT816,NORMAL,"     ",
	48,172,FONT816,NORMAL,"S"
};

/********************************************************************/

