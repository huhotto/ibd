#ifndef __masterSPI3_H
#define __masterSPI3_H

extern void masterSPI3_Init(void);
extern void SPI3_WriteByte(unsigned char TxData);
extern unsigned char SPI3_ReadByte(void);
extern void writeFPGAReg(unsigned short addr,unsigned char data);
extern int  readFPGAReg(unsigned short addr,unsigned char *data);
extern void FPGA_Init(void);

#endif
