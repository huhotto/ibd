#ifndef __Hg25664_H
#define __Hg25664_H

extern void OLED_Initialization(void);
extern void Fill_RAM(unsigned char Data);
extern int Write_dat(unsigned char data);
extern void Set_Write_RAM(void);
extern void Set_Remap_Format(unsigned char data);
extern void Set_Column_Address(unsigned char a,unsigned char b);
extern void Set_Row_Address(unsigned char a, unsigned char b);
#endif
