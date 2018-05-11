#ifndef __drawPic_H
#define __drawPic_H
#define VU_SEG_MAX  (8)
#define Meter_on	 0xff
#define Meter_off  0x00
#define NOSRC   (4)
#define NULL     0
extern void drawRect(unsigned char startX,unsigned char startY,unsigned char endX,unsigned char endY);
//extern void drawLine(unsigned char startX,unsigned char startY,unsigned char endX,unsigned char endY);
//extern void DrawBlock(unsigned char startX,unsigned char startY,unsigned char count,unsigned char data);

extern void drawMeterBar(unsigned char startX,unsigned char startY,unsigned char meterL,unsigned char meterR);
//extern void drawCorrBar(unsigned char startX,unsigned char startY,float meterValu);
//extern void clearLine(unsigned char startX,unsigned char startY,unsigned char endX,unsigned char endY);
extern void drawBigNum(unsigned char x,unsigned char y,unsigned char num);
extern void drawDelayMask(void);
extern void drawLine(unsigned char startX,unsigned char startY,unsigned char endX,unsigned char endY,unsigned char data);

#endif
