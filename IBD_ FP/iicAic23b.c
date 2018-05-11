#include "iicAic23b.h"
#include "delay.h"
#include "math.h"
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

typedef struct AIC23B_REG
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
}AIC23B_REG;

AIC23B_REG DAM100_AIC23B;
//初始化IIC
void IIC_Init(void)
{			
  GPIO_InitTypeDef  GPIO_InitStructure;

  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);//使能GPIOB时钟

  //GPIOB8,B9初始化设置
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;//普通输出模式
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;//推挽输出
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;//100MHz
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;//上拉
  GPIO_Init(GPIOB, &GPIO_InitStructure);//初始化
	IIC_SCL=1;
	IIC_SDA=1;
}
//产生IIC起始信号
void IIC_Start(void)
{
	SDA_OUT();     //sda线输出
	IIC_SDA=1;	  	  
	IIC_SCL=1;
	delay_us(4);
 	IIC_SDA=0;//START:when CLK is high,DATA change form high to low 
	delay_us(4);
	IIC_SCL=0;//钳住I2C总线，准备发送或接收数据 
}	  
//产生IIC停止信号
void IIC_Stop(void)
{
	SDA_OUT();//sda线输出
	IIC_SCL=0;
	IIC_SDA=0;//STOP:when CLK is high DATA change form low to high
 	delay_us(4);
	IIC_SCL=1; 
	IIC_SDA=1;//发送I2C总线结束信号
	delay_us(4);							   	
}
//等待应答信号到来
//返回值：1，接收应答失败
//        0，接收应答成功
unsigned char IIC_Wait_Ack(void)
{
	unsigned char ucErrTime=0;
	SDA_IN();      //SDA设置为输入  
	IIC_SDA=1;delay_us(1);	   
	IIC_SCL=1;delay_us(1);	 
	while(READ_SDA)
	{
		ucErrTime++;
		if(ucErrTime>250)
		{
			IIC_Stop();
			return 1;
		}
	}
	IIC_SCL=0;//时钟输出0 	   
	return 0;  
} 
//产生ACK应答
void IIC_Ack(void)
{
	IIC_SCL=0;
	SDA_OUT();
	IIC_SDA=0;
	delay_us(2);
	IIC_SCL=1;
	delay_us(2);
	IIC_SCL=0;
}
//不产生ACK应答		    
void IIC_NAck(void)
{
	IIC_SCL=0;
	SDA_OUT();
	IIC_SDA=1;
	delay_us(2);
	IIC_SCL=1;
	delay_us(2);
	IIC_SCL=0;
}					 				     
//IIC发送一个字节
//返回从机有无应答
//1，有应答
//0，无应答			  
void IIC_Send_Byte(unsigned char txd)
{                        
    unsigned char t;   
	  SDA_OUT(); 	    
    IIC_SCL=0;                //拉低时钟开始数据传输
    for(t=0;t<8;t++)
    {              
        IIC_SDA=(txd&0x80)>>7;
        txd<<=1; 	  
				delay_us(2);          //对TEA5767这三个延时都是必须的
				IIC_SCL=1;
				delay_us(4); 
				IIC_SCL=0;	
				delay_us(4);
    }	 
} 	    
//读1个字节，ack=1时，发送ACK，ack=0，发送nACK   
unsigned char IIC_Read_Byte(unsigned char ack)
{
	unsigned char i,receive=0;
	SDA_IN();									//SDA设置为输入
  for(i=0;i<8;i++ )
	{
     IIC_SCL=0; 
     delay_us(4);
		 IIC_SCL=1;
     receive<<=1;
     if(READ_SDA)
			 receive++;   
		 delay_us(6); 
  }					 
  if (!ack)
      IIC_NAck();						//发送nACK
  else
      IIC_Ack(); 						//发送ACK   
  return receive;
}
/********************************************************************
*
*
*********************************************************************/
int I2C_write(unsigned char address, unsigned char data[2])
{
	 IIC_Start();
	 IIC_Send_Byte(address);
	 if(IIC_Wait_Ack()) return -1;
	 IIC_Send_Byte(data[0]);
	 if(IIC_Wait_Ack()) return -1;
	 IIC_Send_Byte(data[1]);
   if(IIC_Wait_Ack()) return -1;
	 IIC_Stop();
	return 0;
}
/********************************************************************
* AIC23B init
* master mode,48K IIS 12.288M 0db line and headphone out.
*********************************************************************/
void AIC23B_REG_SET(void)
{
	int j,i = 0;

	j = 1;
	
	//j = CAT25C64_read((Uint16 *)&DAM100_AIC23B,sizeof(DAM100_AIC23B));
	
/*	if( (DAM100_AIC23B.First[0] == 0x55) && (DAM100_AIC23B.First[1] == 0xAA))
	{
		i = 1;
	}
	else
	{
		i = 0;
	} 
*/
//	if( (i == 0) || ( j != 0 ) )
//	{
		DAM100_AIC23B.dumy[0] = 0;
		DAM100_AIC23B.dumy[1] = 0;
		DAM100_AIC23B.First[0] = 0x55;
		DAM100_AIC23B.First[1] = 0xAA;

		DAM100_AIC23B.reset[0] = 0x1E;
		DAM100_AIC23B.reset[1] = 0x00;
		DAM100_AIC23B.power_down_control[0] = 0x0c;
		DAM100_AIC23B.power_down_control[1] = 0xff; //close line in and microphone and ADC
		DAM100_AIC23B.analog_audio_path_control[0] = 0x08;
		DAM100_AIC23B.analog_audio_path_control[1] = 0x12;
		DAM100_AIC23B.digital_audio_path_control[0] = 0x0A;
		DAM100_AIC23B.digital_audio_path_control[1] = 0x06;
		DAM100_AIC23B.sample_rate_control[0] = 0x10;
		DAM100_AIC23B.sample_rate_control[1] = 0x00;
		DAM100_AIC23B.digital_audio_interface_format[0] = 0x0E;
		DAM100_AIC23B.digital_audio_interface_format[1] = 0x0A;  //slave mode
		DAM100_AIC23B.digital_interface_activation[0] = 0x12;
		DAM100_AIC23B.digital_interface_activation[1] = 0x01;
		DAM100_AIC23B.left_line_input_volume_control[0] = 0x01;
		DAM100_AIC23B.left_line_input_volume_control[1] = 0x97;
		DAM100_AIC23B.right_line_input_volume_control[0] = 0x03;
		DAM100_AIC23B.right_line_input_volume_control[1] = 0x97;
		DAM100_AIC23B.left_headphone_volume_control[0] = 0x05;
		DAM100_AIC23B.left_headphone_volume_control[1] = 0x79;
		DAM100_AIC23B.right_headphone_volume_control[0] = 0x07;
		DAM100_AIC23B.right_headphone_volume_control[1] = 0x79;//f9
		//CAT25C64_write((Uint16 *)&DAM100_AIC23B,sizeof(DAM100_AIC23B));
	//}
}
/**********************************************************************
* AIC23B registers initialization
*
***********************************************************************/
void AIC23B_init(void)
{
	unsigned short j;
	
  IIC_Init();
	AIC23B_REG_SET();
	/*configure reset register*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.reset);
	delay_us(10000);
	/*configure power down control register*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.power_down_control);
	delay_us(10000);
	DAM100_AIC23B.power_down_control[1] = 0x04;
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.power_down_control);
	delay_us(10000);	
	/*configure analog_audio_path_control*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.analog_audio_path_control);
	/*configure digital_audio_path_control*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.digital_audio_path_control);
	/*configure digital_interface_format*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.digital_audio_interface_format);
	/*configure sample_rate_control*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.sample_rate_control);
	/*configure digital interface activation*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.digital_interface_activation);
	/*configure left_line_input_volume_control*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.left_line_input_volume_control);
	/*configure right_line_input_volume_control*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.right_line_input_volume_control);
	/*configure left headphome_volume_control*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.left_headphone_volume_control);
	/*configure right headphone volume_control*/
	j = I2C_write(AIC23B_ADDR, DAM100_AIC23B.right_headphone_volume_control);

}
/********************************************************************/
/********************************************************************
* AIC23B mute
*
*********************************************************************/
unsigned short AIC23B_mute(unsigned short Line_or_headphone)
{
	unsigned short j,i;

	if((Line_or_headphone == PHONE) || (Line_or_headphone == ALL))
	{
		DAM100_AIC23B.left_headphone_volume_control[1] = 0xb0;
		DAM100_AIC23B.right_headphone_volume_control[1] = 0xb0;
		j =  I2C_write(AIC23B_ADDR, DAM100_AIC23B.left_headphone_volume_control);
		i =  I2C_write(AIC23B_ADDR, DAM100_AIC23B.right_headphone_volume_control);
	}
	return(i & j);
}
/***********************************************************************
* AIC23B headphone volume control
*
************************************************************************/
/***********************************************************************
* AIC23B headphone volume control
*
************************************************************************/
void AIC23B_headphone_volume_control(unsigned char volume)
{
	DAM100_AIC23B.left_headphone_volume_control[1] = volume;
	DAM100_AIC23B.right_headphone_volume_control[1] = volume;
	if((DAM100_AIC23B.left_headphone_volume_control[1] & 0x79) <= 0x79)
	{
			DAM100_AIC23B.left_headphone_volume_control[0] = 0x05;
		  DAM100_AIC23B.left_headphone_volume_control[1]  |= 0x80;
		
		  DAM100_AIC23B.right_headphone_volume_control[0] = 0x07;
			DAM100_AIC23B.right_headphone_volume_control[1] |= 0x80;
			I2C_write(AIC23B_ADDR, DAM100_AIC23B.left_headphone_volume_control);
			I2C_write(AIC23B_ADDR, DAM100_AIC23B.right_headphone_volume_control);
	}

}
/**************************************************************************
*
***************************************************************************/
void AIC23B_powerdown(void)
{
	DAM100_AIC23B.power_down_control[1] = 0xff;
	I2C_write(AIC23B_ADDR, DAM100_AIC23B.power_down_control);
}
/***************************************************************************
*
****************************************************************************/
void AIC23B_unMute(unsigned short volume)
{
/*	DAM100_AIC23B.left_line_input_volume_control[1] &= 0x7F;
	DAM100_AIC23B.right_line_input_volume_control[1] &= 0x7F;
	I2C_write(DAM100_AIC23B.left_line_input_volume_control,2,1,AIC23B_ADDR,1,30000);
	I2C_write(DAM100_AIC23B.right_line_input_volume_control,2,1,AIC23B_ADDR,1,30000);
*/
	AIC23B_headphone_volume_control(volume);
}
/****************************************************************************/
void CS8427Ini(void)
{
	#define CS8427Addr (0x24)
	int j;
	unsigned char temp[2] = {0,0};
	IIC_Init();
//---------reset the cs8427 ------------------//	
	temp[0] = 0x04;   
	temp[1] = 0x04;
	j = I2C_write(CS8427Addr,temp);
//-------------------------------------------
	temp[0] = 0x01;
	temp[1] = 0x13;
	j = I2C_write(CS8427Addr,temp);
//---------init control2 ------------------//	
	temp[0] = 0x02;
	temp[1] = 0x20;
	j = I2C_write(CS8427Addr,temp);	
//---------init Data flow ------------------//	
	temp[0] = 0x03;
	temp[1] = 0x4C;
	j = I2C_write(CS8427Addr,temp);
//---------init output serial format--------//	
	temp[0] = 0x05;
	temp[1] = 0x05;
	j = I2C_write(CS8427Addr,temp);
//---------init input serial format---------//	
	temp[0] = 0x06;
	temp[1] = 0x05;
	j = I2C_write(CS8427Addr,temp);
//-------------------------------------------
//---------init clock src ------------------//	
	temp[0] = 0x04;
	temp[1] = 0x44;
	j = I2C_write(CS8427Addr,temp);
}

























