#ifndef __iicAic23b_H
#define __iicAic23b_H
#include "sys.h" 
//////////////////////////////////////////////////////////////////////////////////	 
//������ֻ��ѧϰʹ�ã�δ��������ɣ��������������κ���;
//ALIENTEK STM32F407������
//IIC ��������	   
//����ԭ��@ALIENTEK
//������̳:www.openedv.com
//��������:2014/5/6
//�汾��V1.0
//��Ȩ���У�����ؾ���
//Copyright(C) ������������ӿƼ����޹�˾ 2014-2024
//All rights reserved									  
////////////////////////////////////////////////////////////////////////////////// 	
   	   		   
//IO��������
#define SDA_IN()  {GPIOB->MODER&=~(3<<(9*2));GPIOB->MODER|=0<<9*2;}	//PB9����ģʽ
#define SDA_OUT() {GPIOB->MODER&=~(3<<(9*2));GPIOB->MODER|=1<<9*2;} //PB9���ģʽ
//IO��������	 
#define IIC_SCL    PBout(8) //SCL
#define IIC_SDA    PBout(9) //SDA	 
#define READ_SDA   PBin(9)  //����SDA 

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
















