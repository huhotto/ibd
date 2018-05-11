#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "delay.h"


#define mSPICs   (GPIO_Pin_15)   // slave spi chip select, GPIO_AF  PA15
#define mSPIClk  (GPIO_Pin_10)    // slave spi clock, GPIO_AF  PC10
#define mSPISDI  (GPIO_Pin_11)    // slave spi output, gpio_af  PC11
#define mSPISDO  (GPIO_Pin_12)    // slave spi input, gpio_af   PC12

void masterSPI3_Init(void)
{
	GPIO_InitTypeDef  GPIO_InitStructure;
  SPI_InitTypeDef  SPI_InitStructure;
	
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);      //使能GPIOA时钟
  RCC_APB1PeriphClockCmd(RCC_APB1Periph_SPI3, ENABLE);       //使能SPI1时钟
	
	GPIO_InitStructure.GPIO_Pin = mSPIClk | mSPISDI | mSPISDO; //PC10/11/12复用功能输出	
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;               //复用功能
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;             //推挽输出
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;          //100MHz
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;               //上拉
  GPIO_Init(GPIOC, &GPIO_InitStructure);                     //初始化
	
	GPIO_InitStructure.GPIO_Pin = mSPICs;                     //PA15 复用功能输出	
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;              //复用功能
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;            //推挽输出
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;         //100MHz
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;              //上拉
  GPIO_Init(GPIOA, &GPIO_InitStructure);                    //初始化	
	
	GPIO_PinAFConfig(GPIOC,GPIO_PinSource10,GPIO_AF_SPI3);    //PC10复用为 SPI3
	GPIO_PinAFConfig(GPIOC,GPIO_PinSource11,GPIO_AF_SPI3);    //PC11复用为 SPI3
	GPIO_PinAFConfig(GPIOC,GPIO_PinSource12,GPIO_AF_SPI3);    //PC12复用为 SPI3
	
	RCC_APB1PeriphResetCmd(RCC_APB1Periph_SPI3,ENABLE);       //复位SPI3
	RCC_APB1PeriphResetCmd(RCC_APB1Periph_SPI3,DISABLE);      //停止复位SPI3
	
	SPI_InitStructure.SPI_Direction = SPI_Direction_2Lines_FullDuplex;  //设置SPI单向或者双向的数据模式:SPI设置为双线双向全双工
	SPI_InitStructure.SPI_Mode = SPI_Mode_Master;		                    //设置SPI工作模式:设置为主SPI
	SPI_InitStructure.SPI_DataSize = SPI_DataSize_8b;		                //设置SPI的数据大小:SPI发送接收8位帧结构
	SPI_InitStructure.SPI_CPOL = SPI_CPOL_Low;		                      //串行同步时钟的空闲状态为(低电平)
	SPI_InitStructure.SPI_CPHA = SPI_CPHA_1Edge;	                      //串行同步时钟的第1个跳变沿（上升或下降）数据被采样
	SPI_InitStructure.SPI_NSS = SPI_NSS_Soft;		                        //NSS信号由硬件（NSS管脚）还是软件（使用SSI位）管理:内部NSS信号有SSI位控制
	SPI_InitStructure.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_128; //定义波特率预分频的值:波特率预分频值为256
	SPI_InitStructure.SPI_FirstBit = SPI_FirstBit_MSB;	//指定数据传输从MSB位还是LSB位开始:数据传输从MSB位开始
	SPI_InitStructure.SPI_CRCPolynomial = 7;	          //CRC值计算的多项式
	SPI_Init(SPI3, &SPI_InitStructure);                 //根据SPI_InitStruct中指定的参数初始化外设SPIx寄存器
  
	SPI_Cmd(SPI3, ENABLE);                              //使能SPI外设
	GPIO_SetBits(GPIOA,mSPICs);
	
}
/****************************************************************
*
*
*****************************************************************/
//SPI3 写一个字节
//TxData:要写入的字节
//返回值:读取到的字节
//---------------------------------------------------------------------------------------
void SPI3_WriteByte(unsigned char TxData)
{		 			 
  while (SPI_I2S_GetFlagStatus(SPI3, SPI_I2S_FLAG_TXE) == RESET){}//等待发送区空  
	SPI_I2S_SendData(SPI3, TxData); //通过外设SPIx发送一个byte  数据
}
/****************************************************************
*
*
*****************************************************************/
//SPI3 读一个字节
//TxData:要写入的字节
//返回值:读取到的字节
//---------------------------------------------------------------------------------------
unsigned char SPI3_ReadByte(void)
{		
  unsigned char i;	
  while (SPI_I2S_GetFlagStatus(SPI3, SPI_I2S_FLAG_RXNE) == RESET){}//等待接收区非空
	i = SPI_I2S_ReceiveData(SPI3);
	return (i);                              //读取一个数据返回
}

/*********************************************************************************/
void Spi_En(void)
{
GPIO_ResetBits(GPIOA,mSPICs);
}
void Spi_Disable(void)
{
 GPIO_SetBits(GPIOA,mSPICs);
}
/*********************************************************************/
void writeFPGAReg(unsigned short addr,unsigned char data)
{
	unsigned char temp;

	
	GPIO_SetBits(GPIOA,mSPICs);
	delay_us(10);
	GPIO_ResetBits(GPIOA,mSPICs);
	temp = (addr >> 8)&0xff;
	SPI3_WriteByte(temp);
	SPI3_ReadByte();
	temp = addr & 0xff;
	SPI3_WriteByte(temp);
	SPI3_ReadByte();
	SPI3_WriteByte(data);
	SPI3_ReadByte();
	delay_us(80);
	GPIO_SetBits(GPIOA,mSPICs);
	delay_us(10);

}
/********************************************************************/
int readFPGAReg(unsigned short addr,unsigned char *data)
{
	unsigned char temp;

  if(data == 0) return -1;
	GPIO_SetBits(GPIOA,mSPICs);
	delay_us(10);
	GPIO_ResetBits(GPIOA,mSPICs);
	temp = (addr >> 8) & 0xff;
	temp |= 0x80;
	SPI3_WriteByte(temp);
	SPI3_ReadByte();
	temp = addr & 0xff;
	SPI3_WriteByte(temp);
	SPI3_ReadByte();
	temp = 0x00;
	SPI3_WriteByte(temp);
	*data = SPI3_ReadByte();
	delay_us(80);
	GPIO_SetBits(GPIOA,mSPICs);
	delay_us(10);
	return 0;
}

/****************************************************************/
void FPGA_Init(void)
{
		masterSPI3_Init();
	 
}












