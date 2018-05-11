#ifndef __dispChar_H
#define __dispChar_H
#include "IBD_type.h"
extern void change(unsigned char m,FONT_MODE NormalOrReverse);
extern void write_oled8(unsigned char x,unsigned char y,unsigned char coder,FONT_MODE NormalOrReverse);
extern void write_oled816(unsigned char x,unsigned char y,unsigned char coder, FONT_MODE NormalOrReverse);
extern void show_string(unsigned char startX,unsigned char startY, char *Data,FONT font, FONT_MODE NormalOrInverse);

#endif
