#ifndef __IBD_TYPE_H
#define __IBD_TYPE_H

typedef enum{ NORMAL,REVERSE}FONT_MODE;
typedef enum{ FONT88, FONT816}FONT;
typedef enum {ON=0,OFF=1,BLINK}LEDSTATUS;
typedef enum{ pageMain		=0,pageINPUT  =1, pageC_IP 	=2, pageAOIP 	=3, pageMETER 	=4, pagePARA 	=5, pageDelay 	=6}OLED_PAGE;
typedef enum  {BOOT=0x00,BYPASS=0x01,
	             ZERO_IDLE   =0x12,MIDIDLE    =0x22,FULL_IDLE    =0x32,
							 ZEROBUILDING=0x13,MIDBUILDING=0x23,FULLBUILDING=0x33,
							 ZEROTOZERO  =0x14,MIDTOZERO=  0x24,FULLTOZERO   =0x34}DelayMode;
typedef enum {BOOT0=0,BOOT1=1,BOOTOK=2} DeviceBoot;

typedef struct FramDataStruct
{
	unsigned char x;
	unsigned char y;
	FONT resolution;
	FONT_MODE normalOrInverse;
  char  *buff;
}FramDataStruct;

typedef struct Position
{
	unsigned char x;
	unsigned char y;
}Position;

typedef struct OLEDDispStatus
{
	unsigned char page;
	unsigned char cursor;
	unsigned char mainPageCurror;
	unsigned char InPutCurror;
}OLEDDispStatus;

typedef struct ledDisp
{
	LEDSTATUS bypass;
	LEDSTATUS panic;
	LEDSTATUS rebuild;
	LEDSTATUS ramtozero;
	LEDSTATUS sneeze;
	LEDSTATUS dump;
	LEDSTATUS music;
}LED_STR;

/*typedef struct AIC23B_REG
{
	unsigned char dumy[2];
	unsigned char First[2];
	unsigned char reset[2];
	unsigned char power_down_control[2];       //mic in off
	unsigned char analog_audio_path_control[2]; //sidetone off dac on byp off line mic mute
	unsigned char digital_audio_path_control[2]; 
	unsigned char digital_audio_interface_format[2]; //iis 24bit left in low master
	unsigned char sample_rate_control[2]; //48k adc 48k dac iis
	unsigned char digital_interface_activation[2];
	unsigned char left_line_input_volume_control[2]; //l-r simultaneous 0db
	unsigned char right_line_input_volume_control[2]; //l-r sim  0db
	unsigned char left_headphone_volume_control[2]; // l-r sim 0db
	unsigned char right_headphone_volume_control[2]; //l-r sim 0db
}AIC23B_REG;*/


typedef struct IpObject
{
	unsigned char mac[6];
	unsigned char localIp[4];
	unsigned char netmask[4];
	unsigned char gateway[4];
}IpObject;



typedef struct DanteIpObj
{
	unsigned char masterIp[4];
	unsigned char slaveIp[4];
}DanteIpObj;



typedef struct IBS300NameStr
{
	char LocalDanteName[26];
  char AOIPName[4][26];
}IBS300NameStr;



typedef struct IBS300InputType
{
	unsigned char type;
	char ch_num;
	unsigned char music;
}IBS300InputType;

typedef struct Meter
{
	unsigned char vu[18];
	float corr[8];
}MeterSTR;

typedef struct flashSaveStr
{
	unsigned char outCh;
	unsigned char chType[8];
	unsigned char chNum[8];
	unsigned char autoState;
	unsigned char backupState;
}flashSaveStr;


typedef struct IBD200ParaTimeStruct
{
	float maxtime;
	float buildtime;
	float dumptime;
	float safetime;
	float panictime;
}IBD200PARA_STR;

typedef struct keyLed
{
	unsigned char keyNo;
	unsigned char ledStatus;
	unsigned char keyEnable;
}KEY_LED;

typedef struct SwitchAndMonitorStatus
{
	unsigned char Monitor_ch;  //current pre-listen channel number
	unsigned char Output_ch;   //current switch output channel number
	unsigned char blink_flag;  //whether is here blink key
	unsigned char smart_flag;
	unsigned char auto_return_flag;
}SwitchAndMonitorStatus;
#endif
