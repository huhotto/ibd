#include "key.h"
#include "stm32f10x_usart.h"
#include "RS232.h"
#include "main.h"
#define DEBUG_USARTx 									 USART1
#define DEBUG_USART_CLK 							 RCC_APB2Periph_USART1
#define DEBUG_USART_APBxClkCmd 				 RCC_APB2PeriphClockCmd
#define DEBUG_USART_BAUDRATE				   115200

#define DEBUG_USART_GPIO_CLK 				   (RCC_APB2Periph_GPIOA)
#define DEBUG_USART_GPIO_APBxClkCmd     RCC_APB2PeriphClockCmd
#define DEBUG_USART_TX_GPIO_PORT 			  GPIOA
#define DEBUG_USART_TX_GPIO_PIN 			  GPIO_Pin_9
#define DEBUG_USART_RX_GPIO_PORT			  GPIOA
#define DEBUG_USART_RX_GPIO_PIN 				GPIO_Pin_10

#define DEBUG_USART_IRQ 						     USART1_IRQn
#define DEBUG_USART_IRQHandler 			     USART1_IRQHandler

#define  bufflen			4

uint8_t   rsflag;
uint8_t   rsindex;
uint8_t   rsbuff[bufflen];
static void NVIC_Configuration(void)
{
   NVIC_InitTypeDef NVIC_InitStructure;
	 NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);
	 NVIC_InitStructure.NVIC_IRQChannel = DEBUG_USART_IRQ;
	 NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;
	 NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
	 NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	 NVIC_Init(&NVIC_InitStructure);
}

void USART_Config(void)
{
 GPIO_InitTypeDef GPIO_InitStructure;
 USART_InitTypeDef USART_InitStructure;
	
 DEBUG_USART_GPIO_APBxClkCmd(DEBUG_USART_GPIO_CLK, ENABLE);// 打开串口GPIO 的时钟
 DEBUG_USART_APBxClkCmd(DEBUG_USART_CLK, ENABLE);// 打开串口外设的时钟 第二功能
	
 GPIO_InitStructure.GPIO_Pin = DEBUG_USART_TX_GPIO_PIN;
 GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
 GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
 GPIO_Init(DEBUG_USART_TX_GPIO_PORT, &GPIO_InitStructure);
 
 GPIO_InitStructure.GPIO_Pin = DEBUG_USART_RX_GPIO_PIN;// 将USART Rx 的GPIO 配置为浮空输入模式
 GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
 GPIO_Init(DEBUG_USART_RX_GPIO_PORT, &GPIO_InitStructure);
 
 USART_InitStructure.USART_BaudRate = DEBUG_USART_BAUDRATE; // 配置串口的工作参数 配置波特率
 USART_InitStructure.USART_WordLength = USART_WordLength_8b;// 配置 针数据字长
 USART_InitStructure.USART_StopBits = USART_StopBits_1;// 配置停止位
 USART_InitStructure.USART_Parity = USART_Parity_No ; // 配置校验位
 USART_InitStructure.USART_HardwareFlowControl =USART_HardwareFlowControl_None;// 配置硬件流控制
 USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;// 配置工作模式，收发一起
 USART_Init(DEBUG_USARTx, &USART_InitStructure);// 完成串口的初始化配置
 NVIC_Configuration();// 串口中断优先级配置
 USART_ITConfig(DEBUG_USARTx, USART_IT_RXNE, ENABLE);// 使能串口接收中断
 USART_Cmd(DEBUG_USARTx, ENABLE);// 使能串口
 
 }
 #if 0
 void Usart_SendByte( USART_TypeDef * pUSARTx, uint8_t ch)
 {
	 /* 发送一个字节数据到USART */
	 USART_SendData(pUSARTx,ch);
	 while (USART_GetFlagStatus(pUSARTx, USART_FLAG_TXE) == RESET);/* 等待发送数据寄存器为空 */
	 
	 
 }
 #endif
 void Usart_Sendkey(void)
 {
	 USART_SendData(DEBUG_USARTx,0xaa);
	  while (USART_GetFlagStatus(DEBUG_USARTx, USART_FLAG_TXE) == RESET);/* 等待发送数据寄存器为空 */
	 USART_SendData(DEBUG_USARTx,Ibd800.currkey);
	  while (USART_GetFlagStatus(DEBUG_USARTx, USART_FLAG_TXE) == RESET);/* 等待发送数据寄存器为空 */
	 USART_SendData(DEBUG_USARTx,0xf7);
	 while (USART_GetFlagStatus(DEBUG_USARTx, USART_FLAG_TXE) == RESET);/* 等待发送数据寄存器为空 */
	 Ibd800.currkey =0;
 }
 /* void Usart_SendString( USART_TypeDef * pUSARTx, char *str)
 
 {
	 unsigned int k=0;
	 do {
	   Usart_SendByte( pUSARTx, *(str + k) );
	   k++;
		} while (*(str + k)!='\0');
	 while (USART_GetFlagStatus(pUSARTx,USART_FLAG_TC)==RESET)
			{}
 }*/
 
void RS_fun(void)
{
	uint16_t temp;
	
	Ibd800.mode			 =rsbuff[0];
	Ibd800.dumptime  =rsbuff[1];
	temp 						=(rsbuff[2]*100+rsbuff[3]);
	Ibd800.time 		=temp /100.0;
	Ibd800.segtime[3] = temp % 10;  
	temp = temp / 10; 
	Ibd800.segtime[2] = temp % 10; 
	temp = temp / 10; 	
	Ibd800.segtime[1] = temp % 10;  
	temp = temp / 10; 
	Ibd800.segtime[0] = temp ;  
}
 void DEBUG_USART_IRQHandler(void)
 {
	 uint8_t ucTemp;
	 if (USART_GetITStatus(DEBUG_USARTx,USART_IT_RXNE)!=RESET) 
		{
	       ucTemp = USART_ReceiveData( DEBUG_USARTx );
				 //USART_SendData(DEBUG_USARTx,ucTemp);
	  }
	
		if(ucTemp ==0xf7)
						{
							rsflag =0;
						  RS_fun();
						}
		
		if((rsindex < bufflen) && rsflag)
						rsbuff[rsindex++]=ucTemp;
		
		if(ucTemp ==0xaa)
		{
						rsflag =1;
						rsindex =0;
		}
 }

 