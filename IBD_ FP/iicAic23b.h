#ifndef __iicAic23b_H
#define __iicAic23b_H
#include "sys.h" 
//////////////////////////////////////////////////////////////////////////////////	 
//本程序只供学习使用，未经作者许可，不得用于其它任何用途
//ALIENTEK STM32F407开发板
//IIC 驱动代码	   
//正点原子@ALIENTEK
//技术论坛:www.openedv.com
//创建日期:2014/5/6
//版本：V1.0
//版权所有，盗版必究。
//Copyright(C) 广州市星翼电子科技有限公司 2014-2024
//All rights reserved									  
////////////////////////////////////////////////////////////////////////////////// 	
   	   		   
//IO方向设置
#define SDA_IN()  {GPIOB->MODER&=~(3<<(9*2));GPIOB->MODER|=0<<9*2;}	//PB9输入模式
#define SDA_OUT() {GPIOB->MODER&=~(3<<(9*2));GPIOB->MODER|=1<<9*2;} //PB9输出模式
//IO操作函数	 
#define IIC_SCL    PBout(8) //SCL
#define IIC_SDA    PBout(9) //SDA	 
#define READ_SDA   PBin(9)  //输入SDA 

#define AIC23B_ADDR    (0x34)
#define PHONE          (0x00)
#define LINE           (0x01)
#define ALL            (0x02)
#define UP             (0x01)
#define DOWN           (0x02)
#define MUTE           (0x03)

extern void AIC23B_init(void);
extern void AIC23B_headphone_volume_control(unsigned char volume);
extern unsigned short AIC23B_mute(unsigned short Line_or_headphone);
extern void AIC23B_powerdown(void);
extern void AIC23B_unMute(unsigned short volume);
extern void CS8427Ini(void);

#endif
















