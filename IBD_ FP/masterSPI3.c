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
	
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);      //ʹ��GPIOAʱ��
  RCC_APB1PeriphClockCmd(RCC_APB1Periph_SPI3, ENABLE);       //ʹ��SPI1ʱ��
	
	GPIO_InitStructure.GPIO_Pin = mSPIClk | mSPISDI | mSPISDO; //PC10/11/12���ù������	
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;               //���ù���
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;             //�������
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;          //100MHz
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;               //����
  GPIO_Init(GPIOC, &GPIO_InitStructure);                     //��ʼ��
	
	GPIO_InitStructure.GPIO_Pin = mSPICs;                     //PA15 ���ù������	
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;              //���ù���
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;            //�������
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;         //100MHz
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;              //����
  GPIO_Init(GPIOA, &GPIO_InitStructure);                    //��ʼ��	
	
	GPIO_PinAFConfig(GPIOC,GPIO_PinSource10,GPIO_AF_SPI3);    //PC10����Ϊ SPI3
	GPIO_PinAFConfig(GPIOC,GPIO_PinSource11,GPIO_AF_SPI3);    //PC11����Ϊ SPI3
	GPIO_PinAFConfig(GPIOC,GPIO_PinSource12,GPIO_AF_SPI3);    //PC12����Ϊ SPI3
	
	RCC_APB1PeriphResetCmd(RCC_APB1Periph_SPI3,ENABLE);       //��λSPI3
	RCC_APB1PeriphResetCmd(RCC_APB1Periph_SPI3,DISABLE);      //ֹͣ��λSPI3
	
	SPI_InitStructure.SPI_Direction = SPI_Direction_2Lines_FullDuplex;  //����SPI�������˫�������ģʽ:SPI����Ϊ˫��˫��ȫ˫��
	SPI_InitStructure.SPI_Mode = SPI_Mode_Master;		                    //����SPI����ģʽ:����Ϊ��SPI
	SPI_InitStructure.SPI_DataSize = SPI_DataSize_8b;		                //����SPI�����ݴ�С:SPI���ͽ���8λ֡�ṹ
	SPI_InitStructure.SPI_CPOL = SPI_CPOL_Low;		                      //����ͬ��ʱ�ӵĿ���״̬Ϊ(�͵�ƽ)
	SPI_InitStructure.SPI_CPHA = SPI_CPHA_1Edge;	                      //����ͬ��ʱ�ӵĵ�1�������أ��������½������ݱ�����
	SPI_InitStructure.SPI_NSS = SPI_NSS_Soft;		                        //NSS�ź���Ӳ����NSS�ܽţ����������ʹ��SSIλ������:�ڲ�NSS�ź���SSIλ����
	SPI_InitStructure.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_128; //���岨����Ԥ��Ƶ��ֵ:������Ԥ��ƵֵΪ256
	SPI_InitStructure.SPI_FirstBit = SPI_FirstBit_MSB;	//ָ�����ݴ����MSBλ����LSBλ��ʼ:���ݴ����MSBλ��ʼ
	SPI_InitStructure.SPI_CRCPolynomial = 7;	          //CRCֵ����Ķ���ʽ
	SPI_Init(SPI3, &SPI_InitStructure);                 //����SPI_InitStruct��ָ���Ĳ�����ʼ������SPIx�Ĵ���
  
	SPI_Cmd(SPI3, ENABLE);                              //ʹ��SPI����
	GPIO_SetBits(GPIOA,mSPICs);
	
}
/****************************************************************
*
*
*****************************************************************/
//SPI3 дһ���ֽ�
//TxData:Ҫд����ֽ�
//����ֵ:��ȡ�����ֽ�
//---------------------------------------------------------------------------------------
void SPI3_WriteByte(unsigned char TxData)
{		 			 
  while (SPI_I2S_GetFlagStatus(SPI3, SPI_I2S_FLAG_TXE) == RESET){}//�ȴ���������  
	SPI_I2S_SendData(SPI3, TxData); //ͨ������SPIx����һ��byte  ����
}
/****************************************************************
*
*
*****************************************************************/
//SPI3 ��һ���ֽ�
//TxData:Ҫд����ֽ�
//����ֵ:��ȡ�����ֽ�
//---------------------------------------------------------------------------------------
unsigned char SPI3_ReadByte(void)
{		
  unsigned char i;	
  while (SPI_I2S_GetFlagStatus(SPI3, SPI_I2S_FLAG_RXNE) == RESET){}//�ȴ��������ǿ�
	i = SPI_I2S_ReceiveData(SPI3);
	return (i);                              //��ȡһ�����ݷ���
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












