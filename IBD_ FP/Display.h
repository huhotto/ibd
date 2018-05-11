#ifndef  __Display_H
#define  __Display_H
#include "IBD_type.h"
extern void WaitBoot(void);
extern void DisplayKeyLed(unsigned char mode,float delayTime);
extern void IBD_Fun(void);

extern void DispPageMain(void);
extern void DispMainPageCusor(unsigned char Cursor);
extern void DispMainPageVu(unsigned char startX,unsigned startY,unsigned char VuL,unsigned char VuR);
extern void DispPage1(IBS300InputType IBS300InputStatus);
extern void DispPage1Frame(void);
extern void DispPage1Content(IBS300InputType *IBS300InputStatus);
extern void DispPageMeter(MeterSTR meter);
extern void DispCorrFrame(void);
extern void DispCorrContent(float *corr);
extern void DispC_IPFrame(void);
extern void DispC_IPContent(IpObject ArmIp);
extern void DispAOIPFrame(unsigned char page);
extern void OledDispFrame(unsigned char page);
#endif
