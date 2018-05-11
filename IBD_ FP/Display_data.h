#ifndef __Display_data_H
#define __Display_data_H
#include "IBD_type.h"


#define MS20      (20)       //20ms
#define MS50      (50)
#define MS100     (100)      //100ms
#define MS200     (200)
#define MS500     (500)     //1000ms
#define MS1000    (1000)     //1000ms
#define PageAlarmFrameLen (1)
#define MainPageFramDataLen (8)
#define PageINPUTDataLen (6)
#define PageMeterCorrDataLen (6)
#define PageC_IPFrameLen (6)
#define PageAOIPFrameLen (14)
#define pageParaFrameLen (12)
#define PageMeterFrameLen (7)
#define INIT     (12)
#define OFFSET   (28)
extern float delay_time;
extern unsigned char IBS300AES3[3];

extern DelayMode delay_mode;
extern DeviceBoot device_boot;
extern LED_STR Led_Status;
extern IBD200PARA_STR IBD200TimePara;
extern OLEDDispStatus OLED_Status;
extern MeterSTR IBS300Meter;
extern IBS300InputType IBD200Status;
extern DanteIpObj IBS300DanteIp;
extern IpObject IBS300ArmIP;
extern IBS300NameStr IBS300Name;

extern const Position AinVuPosition[8];

extern FramDataStruct 		  MainPageFramData[MainPageFramDataLen];
extern FramDataStruct const Page1Data[PageINPUTDataLen];
extern FramDataStruct const PageMeterCorrData[PageMeterCorrDataLen];
extern FramDataStruct const PageMeterData[PageMeterFrameLen];
extern FramDataStruct const PageC_IPData[PageC_IPFrameLen];
extern FramDataStruct const PageAOIPData[PageAOIPFrameLen];
extern FramDataStruct const PageParaData[pageParaFrameLen];
#endif
