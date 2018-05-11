#ifndef __CommWithFPGA_H
#define __CommWithFPGA_H
#include "IBD_type.h"

extern void setLineOutReg(unsigned char ch);
extern int readLineOutReg(void);
extern void setAutoReturnStatus(void);
extern void setListenHeadPhone(unsigned char ch);
extern void readAutoReturnStatus(void);
extern void setSmartSwitchStatus(void);
extern void readSmartSwitchStatus(void);
//extern void setChTypeAndNum(void);
extern void readARMIp(void);
extern void readDanteIp(void);
extern void setDefaultChConfig(void);
extern void setDefaultSwitch(void);
//extern void writeFPGAReg(unsigned short addr,unsigned char data);
//extern int readFPGAReg(unsigned short addr,unsigned char *data);
extern void setThreshHold(void);
extern int CheckFpgaReady(void);
extern void FpgaMessageReset(void);
extern void checkFpagReadyInit(void);
extern int readThreshold(unsigned char *VuThd_H,unsigned char *VuThd_L,unsigned char *SwTimeThd,unsigned char *RtTimeThd);
extern void AlarmClear(void);
extern void GetTimePara(void);
extern void SetTimePara(void);
extern void GetDelayTime(void);
extern void ReadMode(void);
extern void ReadBootMode(void);
extern void WriteBootMode(void);
extern void SendKeyValu(unsigned char tmp);


extern void readOutVu(void);
extern void readSrcInputStatus(void);
extern void readAESStatus(void);
extern void readAOIPDanteName(void);
extern void readLocalDanteName(void);
extern void readCorrFromFpga(MeterSTR *result);
extern void readAllVu(void);
extern void dsipaly_selvu(void);
extern void setMusic(unsigned char ch);
extern void setInputSrc(unsigned char ch);
#endif

