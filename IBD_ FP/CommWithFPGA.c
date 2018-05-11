#include "Display_data.h"
#include "stm32f4xx_gpio.h"
#include  "masterSPI3.h"
#include "drawPic.h"
#include "dispChar.h"

#define FPGA_RST (GPIO_Pin_14)
#define FPGA_RDY (GPIO_Pin_15)

#define FPGA_AOUT       			(0x01)   //1-8 main output 
#define FPGA_HEADPHONE  			(0x02)   //1-8 pre-listen channel number
#define FPGA_AUTO_RETURN      (0x03)   //1: enable, 0: disable
#define FPGA_SMART_STUATUS	  (0x04)   //1: enable, 0: disable
#define FPGA_Power 						(0x05)   //[1:0] two bits [master power,slave power]
#define FPGA_AES3Status				(0x06)   //[2:0] three bits [AES3:AES2:AES1], 1: locked, 0:unlocked
#define FPGA_GPI              (0x07)
#define FPGA_GPO              (0x08)

#define FPGA_CHIN_TYPE_START  (0x09)   // 8 input channels' type, 1:AES3, 2:Internal Music,3: MADI, 4:AOIP  
#define FPGA_CHIN_TYPE_END    (0x10)   // each channel one byte, 8bytes total.

#define FPGA_CH1Type   (0x09)
#define FPGA_CH2Type   (0x0A)
#define FPGA_CH3Type   (0x0B)
#define FPGA_CH4Type   (0x0C)
#define FPGA_CH5Type   (0x0D)
#define FPGA_CH6Type   (0x0E)
#define FPGA_CH7Type   (0x0F)
#define FPGA_CH8Type   (0x10)

#define FPGA_CHIN_CHnum_START (0x11)   // 8 input channels' channel number, this number scope will differ
#define FPGA_CHIN_CHnum_END  (0x18)    // when the channel type is different. each channel one byte
// whenn AES3: 1-3, when MADI: 1-64, when AOIP: 1-16, when internal music, it is always 1 
#define FPGA_CH1Num  (0x11)
#define FPGA_CH2Num  (0x12)
#define FPGA_CH3Num  (0x13)
#define FPGA_CH4Num  (0x14)
#define FPGA_CH5Num  (0x15)
#define FPGA_CH6Num  (0x16)
#define FPGA_CH7Num  (0x17)
#define FPGA_CH8Num  (0x18)

#define FPGA_Listen           (0X19)  // 8 input channels's priority, the scope is 1-8
#define FPGA_VuThrdH          (0X1A)  // each channel one byte, 8 bytes total.
#define FPGA_VuThrdL          (0x1B)
#define FPGA_SW_TIME          (0x1C)
//#define FPGA_RT_TIME          (0x1D) //IBD CHANGE CHANGE MEASS
#define FPGA_PARA_CHANGE          (0x1D) //IBD CHANGE CHANGE MEASS


#define FPGA_ARM_IP_START   (0x21)  // 0x21-0x24 : ARM Ip, 0x25-0x28: ARM netmask, 0x29-0x2C: ARM GateWay
#define FPGA_ARM_IP_END     (0x2c)  

#define FPGA_DANTE_IP_START (0x2D)  // 0x2D-0x30: DANTE Master PORT IP, 0x31-0x34: Dante Slave PORT Ip
#define FPGA_DANTE_IP_END   (0X34)  //

#define FPGA_DANTE_NAME_START (0x35) // 0x35-0x54: Local Dante Module Name
#define FPGA_DANTE_NAME_END   (0x4E) // maxim 25 bytes ascii characters.

#define FPGA_AOIP1_NAME_START (79) // 79-104: the 1st stereo AOIP name
#define FPGA_AOIP1_NAME_END   (104) // 25 bytes mas

#define FPGA_AOIP2_NAME_START (105) // 105-130: the 2nd stereo AOIP name
#define FPGA_AOIP2_NAME_END   (130)

#define FPGA_AOIP3_NAME_START (131) // 131-156: the 3rd stereo AOIP name
#define FPGA_AOIP3_NAME_END   (156)

#define FPGA_AOIP4_NAME_START (157) // 157-182: the 4th stereo AOIP name
#define FPGA_AOIP4_NAME_END   (182)

#define FPGA_MADI_SEL_START   (183) // 183-191: 8 ch MADI input selection
#define FPGA_MADI_SEL_END     (191) 

// 0xC0-0xE0 : 8 ch input vu registers
// 16 mono channels,each two bytes, 32bytes total
// 0xE1-0xE4 : 2 mono channels output VU, 4bytes total
#define FPGA_VU_START         (0xC0) 
#define FPGA_VU_END           (0xE4) 

#define FPGA_Corr_START       (0xE5) // 0xE5-0xED : 8 input channels' correlation result
#define FPGA_Corr_END         (0xEE) // 0xEE: 1 output channel's correlation result
#define FPGA_READY_REG        (0xEF)
#define FPGA_Counter14        (0xF0)
#define FPGA_Counter15        (0xF1)

#define FPGA_DelayTimeH				(0xF2)
#define FPGA_DelayTimeL				(0xF3)
#define FPGA_BuildTimeL				(0xF4)
#define FPGA_DumpTime 				(0xF5)
#define FPGA_MaxTime				  (0xF6)
#define FPGA_SafeTime				  (0xF7)
#define FPGA_PanicTime				(0xF8)
#define FPGA_Mode							(0xF9)
#define FPGA_KeyValu					(0xFa)
#define FPGA_MUSCIC						(0xFb)
#define FPGA_BuildTimeH				(0xFC)

#define FPGA_InputSrc   FPGA_Listen  
#define FPGA_CHANGE_MESSAGE_REG   (0xFE)  // inter-operation information message register.


#define MESSAGE_LINEOUT      (0X01)
#define MESSAGE_SMART_SWITCH (0X02)
#define MESSAGE_AUTO_RETURN  (0X04)
#define MESSAGE_ALARM        (0x08)

#define LOCKED  (0x01)
#define UNLOCK  (0x00)

unsigned char HeadPhoneChNum = 1;
unsigned char LineOutChNum = 1;
unsigned char historyDspStatus = 0;
int timeCounter = 0;
volatile unsigned char mdefCounter = 0;
volatile unsigned char SPILock = 0;
extern uint8_t new_para;
/*********************************************************************/


/**********************************************************************
* set the pre-listen channel register
***********************************************************************/
void setListenHeadPhone(unsigned char ch)
{
  if(ch <= 7 ) 	
	{
		writeFPGAReg(FPGA_HEADPHONE,ch);
	}
}
void setMusic(unsigned char ch)
{
  if(ch) 	
		ch=1;
	writeFPGAReg(FPGA_MUSCIC,ch);
	
}
void setInputSrc(unsigned char ch)
{
  if(ch <= 6 ) 	
	{
		writeFPGAReg(FPGA_InputSrc,ch);
	}
}
/*********************************************************************
* set the switch channel to fpga and then inform the arm
**********************************************************************/
void setLineOutReg(unsigned char ch)
{
	unsigned char temp = 0;
	if(ch <= 7)
	{
		writeFPGAReg(FPGA_AOUT,ch);
		readFPGAReg(FPGA_CHANGE_MESSAGE_REG,&temp);  //inform the arm
		temp |= MESSAGE_LINEOUT;
		writeFPGAReg(FPGA_CHANGE_MESSAGE_REG,temp);
	}
}
/********************************************************************
* Read the switch channel status, interval
*********************************************************************/
int readLineOutReg(void)
{
	unsigned char temp = 0;
//	unsigned char i;

	readFPGAReg(FPGA_AOUT,&temp);
	if(temp <=7)
	{
		return temp+1;
	}
	else
		return -1;
}
/*********************************************************************
* set the auto-return enable or disable status to fpga and inform the arm
**********************************************************************/
/*void setAutoReturnStatus(void)
{
	unsigned char temp = 0;
	
		writeFPGAReg(FPGA_AUTO_RETURN,CurrentSwitchStatus.auto_return_flag);
		readFPGAReg(FPGA_CHANGE_MESSAGE_REG,&temp);  //inform the arm
		temp |= MESSAGE_AUTO_RETURN;
		writeFPGAReg(FPGA_CHANGE_MESSAGE_REG,temp);
}*/
/********************************************************************
* Read the AutoReturn status, interval
*********************************************************************/
/*void readAutoReturnStatus(void)
{
	unsigned char temp;
	unsigned char i;

	readFPGAReg(FPGA_AUTO_RETURN,&temp);
	if(temp)
	{
		CurrentSwitchStatus.auto_return_flag = 1;
	}
	else 
		CurrentSwitchStatus.auto_return_flag =0;
}*/
/*********************************************************************
* set the smart-switch enable or disable status to fpga and inform the arm
**********************************************************************/
/*void setSmartSwitchStatus(void)
{
	unsigned char temp = 0;
		writeFPGAReg(FPGA_SMART_STUATUS,CurrentSwitchStatus.smart_flag);
   	readFPGAReg(FPGA_CHANGE_MESSAGE_REG,&temp);  //inform the arm
		temp |= MESSAGE_SMART_SWITCH;
		writeFPGAReg(FPGA_CHANGE_MESSAGE_REG,temp);

}*/
/********************************************************************
* Read the smart switch status, interval
*********************************************************************/
/*void readSmartSwitchStatus(void)
{
	unsigned char temp;
	unsigned char i;

	readFPGAReg(FPGA_SMART_STUATUS,&temp);
	if((temp & 0x01) == 0x01)
	{
		CurrentSwitchStatus.smart_flag = 1;
	}
	else
		CurrentSwitchStatus.smart_flag = 0;

}*/
/*************************************************************/
/*void setChTypeAndNum(void)
{
	unsigned char i;
	for(i=0;i<8;i++)
	{
		writeFPGAReg(FPGA_CHIN_TYPE_START+i,IBS300InputStatus[i].type);
		writeFPGAReg(FPGA_CHIN_CHnum_START+i,IBS300InputStatus[i].ch_num);
	}
}*/
/*************************************************************/
void setThreshHold(void)
{
	writeFPGAReg(FPGA_VuThrdH,0);
  writeFPGAReg(FPGA_VuThrdL,104);   // set vu threshold = -50dbfs
	writeFPGAReg(FPGA_SW_TIME,5);    // set autoSwitch time = 10s
	//writeFPGAReg(FPGA_RT_TIME,5);    // set autoreturn time = 3s
}
/**********************************************************************/
void setDefaultChConfig(void)
{
	writeFPGAReg(FPGA_CH1Type,0); //AES3
	writeFPGAReg(FPGA_CH2Type,0); //AES3
	writeFPGAReg(FPGA_CH3Type,0); //AES3
  writeFPGAReg(FPGA_CH4Type,1); //AOIP	
  writeFPGAReg(FPGA_CH5Type,1); //AOIP	
  writeFPGAReg(FPGA_CH6Type,1); //AOIP
  writeFPGAReg(FPGA_CH7Type,1); //AOIP	
	writeFPGAReg(FPGA_CH8Type,3); //Music
	
	writeFPGAReg(FPGA_CH1Num,0);  //AES3-1
	writeFPGAReg(FPGA_CH2Num,1);  //AES3-2
	writeFPGAReg(FPGA_CH3Num,2);  //AES3-3
	writeFPGAReg(FPGA_CH4Num,0);  //AOIP-1
	writeFPGAReg(FPGA_CH5Num,1);  //AOIP-2
	writeFPGAReg(FPGA_CH6Num,2);  //AOIP-3
	writeFPGAReg(FPGA_CH7Num,3);  //AOIP-4
	writeFPGAReg(FPGA_CH8Num,0);  //music
}
void setDefaultSwitch(void)
{
	writeFPGAReg(FPGA_SMART_STUATUS,1);
	writeFPGAReg(FPGA_AUTO_RETURN,1);
}
/*****************************************************************/

void readAESStatus(void)
{
	unsigned char temp;
	unsigned char i;

	readFPGAReg(FPGA_AES3Status,&temp);
	temp = temp & 0x0f;
	
	for(i=0;i<3;i++)
	{
		if((temp >> i) & 0x01)
			IBS300AES3[i] = UNLOCK;
		else
			IBS300AES3[i] = LOCKED;
  }
}
void readSrcInputStatus(void)
{
	//unsigned char i;
		unsigned char temp;
		readFPGAReg(FPGA_InputSrc,&temp);// select chanl type
	  if(temp > 5 )
				temp =0;
		IBD200Status.type = temp;
		readFPGAReg(FPGA_HEADPHONE,&temp); //HEAD PHONE NUM
		if(temp > 6 )
				temp =0;
		IBD200Status.ch_num = temp ;
		readFPGAReg(FPGA_MUSCIC,&temp); //MUSIC
		if(temp > 1 )
				temp =0;
		IBD200Status.music = temp ;
	
	/*for(i=0;i<8;i++)
	{
		readFPGAReg(FPGA_CHIN_TYPE_START+i,&temp[i]);
		IBS300InputStatus[i].type = temp[i];
	}

	for(i=0;i<8;i++)
	{
		readFPGAReg(FPGA_CHIN_CHnum_START+i,&temp[i]);
		IBS300InputStatus[i].ch_num = temp[i] + 1;
	}*/
}
/************************** ARM IP *************************************
***********************************************************************/
void readARMIp(void)
{
	unsigned char i;
  unsigned char temp[12];
	for(i=0;i<12;i++)
	{
		readFPGAReg(FPGA_ARM_IP_START+i,&temp[i]);
	}
	IBS300ArmIP.localIp[0] = temp[3];
	IBS300ArmIP.localIp[1] = temp[2];
	IBS300ArmIP.localIp[2] = temp[1];
	IBS300ArmIP.localIp[3] = temp[0];
	IBS300ArmIP.netmask[0] = temp[7];
	IBS300ArmIP.netmask[1] = temp[6];
	IBS300ArmIP.netmask[2] = temp[5];
	IBS300ArmIP.netmask[3] = temp[4];
	IBS300ArmIP.gateway[0] = temp[11];
	IBS300ArmIP.gateway[1] = temp[10];
	IBS300ArmIP.gateway[2] = temp[9];
	IBS300ArmIP.gateway[3] = temp[8];
}
/***************************************************************
* Read Dante IP
****************************************************************/
void readDanteIp(void)
{
	unsigned char i;
	unsigned char temp[8];
	for(i=0;i<8;i++)
	{
		readFPGAReg(FPGA_DANTE_IP_START+i,&temp[i]);
	}
	IBS300DanteIp.masterIp[0] = temp[3];
	IBS300DanteIp.masterIp[1] = temp[2];
	IBS300DanteIp.masterIp[2] = temp[1];
	IBS300DanteIp.masterIp[3] = temp[0];
	IBS300DanteIp.slaveIp[0] = temp[7];
	IBS300DanteIp.slaveIp[1] = temp[6];
	IBS300DanteIp.slaveIp[2] = temp[5];
	IBS300DanteIp.slaveIp[3] = temp[4];
}
/***********************Read Vu**********************************/
void vuCaculate(MeterSTR *result,unsigned char *buffIn,unsigned char len)
{
	unsigned char i;
	unsigned char j = 0;
	int tempDBVu[18];
//	float temp = 0;
//	float STD[9] = {-70.0,-50.0,-40.0,-30.0,-25.0,-20.0,-15,-10,-6.0};
//  int STD[VU_SEG_MAX] = {11,104,328,1035,1840,3144,5692,10349,16399,32639};	
  int STD[VU_SEG_MAX] = {26,328,1840,3144,5692,10349,16399,32639};	
	
	for(i=0;i<len/2;i++)
	{
		tempDBVu[j++] = 	(*(buffIn+2*i)<<8)+*(buffIn+(2*i+1));
//		temp = temp / 32768.0;
//		tempDBVu[j++] = 20.0*log10(temp);
	}

	for(i=0;i<len/2;i++)
	{
		for(j=0;j<VU_SEG_MAX;j++)
		{
			if(tempDBVu[i] < STD[j])
			{
				result->vu[i] = j;
				break;
			}
			else if(j==(VU_SEG_MAX-1))
			{
				result->vu[i] = VU_SEG_MAX;
			}
		}
	}
	
}
/**********************************************************************
*  
***********************************************************************/
void readAllVu(void)
{
	unsigned char i;
#define  LEN1 36
 unsigned char vuTemp[LEN1];
	
	for(i=0;i<LEN1;i++)
	{ 
		vuTemp[i] = 0;
		readFPGAReg(FPGA_VU_START+i,&vuTemp[i]);
	}
	vuCaculate(&IBS300Meter,vuTemp,LEN1);
}
/*****************************************************************************

*
******************************************************************************/
void vuOutCaculate(MeterSTR *result,unsigned char *buffIn,unsigned char len)
{
	unsigned char i;
	unsigned char j = 0;
	int tempDBVu[4];
//	float temp = 0;
  //int STD[10] = {11,104,328,1035,1840,3144,5692,10349,16399,32639};	
	int STD[VU_SEG_MAX] = {26,328,1840,3144,5692,10349,16399,32639};
	
	for(i=0;i<2;i++)
	{
		tempDBVu[j++] = 	(*(buffIn+2*i)<<8)+*(buffIn+(2*i+1));
	}

	for(i=0;i<2;i++)
	{
		for(j=0;j<VU_SEG_MAX;j++)
		{
			if(tempDBVu[i] < STD[j])
			{
				result->vu[i+16] = j;
				break;
			}
			else if(j==VU_SEG_MAX-1)
			{
				result->vu[i+16] = VU_SEG_MAX;
			}
		}
	}
	
}
//---------------- only read the output audio meter-------------------------//
void readOutVu(void)
{
	unsigned char i;
	unsigned char vuTemp[4]={0,0,0,0};
	
	for(i=0;i<4;i++)
	{
		readFPGAReg(FPGA_VU_START+0x20+i,&vuTemp[i]);   //read the output channel
	}
	vuOutCaculate(&IBS300Meter,vuTemp,4);
}
/*********************************************************************/
/*********************************************************************/
float convertToFloat(unsigned char buffin)
{
	float temp = 0;
	unsigned char i;
	float coffe[7] = {0.5,0.25,0.125,0.0625,0.03125,0.015625,0.0078125};
	unsigned char testBit = 0x40;

	if(buffin >=0x80)
	{
		buffin &= 0x7f;
		buffin = buffin -1;
		buffin = ~buffin;
		buffin |= 0x80;
	}
	for(i = 0; i < 7; i++)
	{
		if((buffin & testBit) == testBit)
		{
			temp = temp + coffe[i];
		}
		testBit = testBit >> 1;
	}
	if(buffin >= 0x80) 
        return (0-temp);
	else 
        return temp;
}

//---------------------------------------------
void readCorrFromFpga(MeterSTR *result)
{
	unsigned char i;
#define  LEN2  8
	unsigned char temp[LEN2];

	for(i = 0; i<LEN2; i++)
	{
		readFPGAReg(FPGA_Corr_START+i,&temp[i]);
	}
	for(i=0;i<LEN2;i++)
	{
		result->corr[i] = convertToFloat(temp[i]);
	}
}
/*************************************************************/
void readLocalDanteName(void)
{
	unsigned char i;
	unsigned char temp[25];
	
	for(i=0;i<25;i++)
	{
		readFPGAReg(FPGA_DANTE_NAME_START+i,&temp[i]);
		IBS300Name.LocalDanteName[i]=temp[i];
	}
	IBS300Name.LocalDanteName[25]=0; // add a string eof
}
void readAOIPDanteName(void)
{
	unsigned char i,j;
	unsigned char temp[25];
	
	
	for(j=0;j<4;j++)
	{
			for(i=0;i<25;i++)
			{
				readFPGAReg(FPGA_AOIP1_NAME_START+i+j*26,&temp[i]);
				IBS300Name.AOIPName[j][i] = temp[i];
			}
		IBS300Name.AOIPName[j][25] = 0;// add a string eof
	}
}
/************************************************************/
void checkFpagReadyInit(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);  

	GPIO_InitStructure.GPIO_Pin = (FPGA_RDY);    
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;     
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_DOWN;  
  GPIO_Init(GPIOB, &GPIO_InitStructure);

  GPIO_InitStructure.GPIO_Pin  = FPGA_RST;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_Init(GPIOB, &GPIO_InitStructure);
	GPIO_SetBits(GPIOB,FPGA_RST);
}
/************************************************************/
int CheckFpgaReady(void)
{
	unsigned char temp = 0;
	readFPGAReg(FPGA_READY_REG,&temp);
	if((temp == 0x55)||(temp == 0xAA))
		return 1;
	else
		return 0;
}
/************************************************************/
void FpgaMessageReset(void)
{
	writeFPGAReg(FPGA_CHANGE_MESSAGE_REG,0);
/*	GPIO_ResetBits(GPIOB,FPGA_RST);
	delay_ms(5);
	GPIO_SetBits(GPIOB,FPGA_RST);
	delay_ms(10);
*/	
}
/*************************************************************/
int readThreshold(unsigned char *VuThd_H,unsigned char *VuThd_L,unsigned char *SwTimeThd,unsigned char *RtTimeThd)
{
	if(VuThd_H == NULL) return -1;
	if(VuThd_L == NULL) return -1;
	if(SwTimeThd == NULL) return -1;
	if(RtTimeThd == NULL) return -1;
	
	readFPGAReg(FPGA_VuThrdH,VuThd_H);
	readFPGAReg(FPGA_VuThrdL,VuThd_L);
	//readFPGAReg(FPGA_SW_TIME,SwTimeThd);
	//readFPGAReg(FPGA_RT_TIME,RtTimeThd);
	return 1;	
}
/***************************************************************/
void AlarmClear(void)
{
	writeFPGAReg(FPGA_GPO,0);
}
void SetTimePara(void)
{
	unsigned char tmp;
	 tmp =IBD200TimePara.maxtime;
	 writeFPGAReg(FPGA_MaxTime,tmp);
	
	 tmp =IBD200TimePara.dumptime;
	 writeFPGAReg(FPGA_DumpTime,tmp);
	
	 tmp = (unsigned char) IBD200TimePara.buildtime;
	 writeFPGAReg(FPGA_BuildTimeL,tmp);
	 tmp = ((unsigned int) IBD200TimePara.buildtime) >> 8;
	 writeFPGAReg(FPGA_BuildTimeH,tmp);
}
void GetTimePara(void)
{
	unsigned char tmp;
	if(!new_para)
		{	
			readFPGAReg(FPGA_BuildTimeH,&tmp);
			IBD200TimePara.buildtime = (tmp <<8);
			readFPGAReg(FPGA_BuildTimeL,&tmp);
			IBD200TimePara.buildtime=IBD200TimePara.buildtime + tmp;
			readFPGAReg(FPGA_DumpTime,&tmp);
			IBD200TimePara.dumptime=tmp;
			readFPGAReg(FPGA_MaxTime,&tmp);
			IBD200TimePara.maxtime =tmp;
			readFPGAReg(FPGA_SafeTime,&tmp);
			IBD200TimePara.safetime =tmp;
			readFPGAReg(FPGA_PanicTime,&tmp);
			IBD200TimePara.panictime =tmp;
			
		}
}
void GetDelayTime(void)
{
	unsigned char tmp;
	unsigned int 	tmp1;
	readFPGAReg(FPGA_DelayTimeH,&tmp);
	tmp1=tmp*100;
	readFPGAReg(FPGA_DelayTimeL,&tmp);
	tmp1+=tmp;
	delay_time=tmp1/100.0;
}
//BOOT=0,BYPASS=1,ZERO_IDLE=2,IDLE=3,FULL_IDLE=4,REBUILDING=5,RAMTOZERO
void   WriteBootMode(void)
{			
			device_boot = BOOT1;
		  writeFPGAReg(FPGA_PARA_CHANGE,BOOT1);	
			

}
void   ReadBootMode(void)
{
			unsigned char tmp;
		  readFPGAReg(FPGA_PARA_CHANGE,&tmp);
		 if(tmp <=BOOTOK)
					device_boot = (DeviceBoot) tmp;
			else 
				 writeFPGAReg(FPGA_PARA_CHANGE,BOOT0);	
}					
void   ReadMode(void)
{
		unsigned char tmp;
		readFPGAReg(FPGA_Mode,&tmp);
		switch(tmp)
		{
		 case   BYPASS      :
		 case		ZERO_IDLE   :
		 case		MIDIDLE     : /*check mode type do'nt BYPASS use delay_mode=(DelayMode)tmp;*/
		 case		FULL_IDLE   :
		 case   ZEROBUILDING:
		 case		MIDBUILDING :
		 case   FULLBUILDING:
		 case   ZEROTOZERO  :
		 case		MIDTOZERO   :
		 case   FULLTOZERO:{delay_mode=(DelayMode)tmp; break;}
				
			default :{delay_mode=BOOT; break;}	
		}
	//	delay_mode = ZERO_IDLE;//hjtest
}
void SendKeyValu(unsigned char tmp)
{
		writeFPGAReg(FPGA_KeyValu,tmp);
}

/******************************************************************************/
void dsipaly_selvu(void)
{
  char TypeEnum[7][4] = {"AES","ANA","DT1","DT2","DT3","DT4"};
	unsigned char temp;
	readFPGAReg(FPGA_Listen,&temp);// select chanl type
	IBD200Status.type = temp;
	show_string(56,232,&TypeEnum[temp][0],FONT88,NORMAL);
	}


