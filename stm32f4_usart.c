/*=====================================================================================================*/
/*=====================================================================================================*/
#include "stm32f4_system.h"
#include "stm32f4_usart.h"
/*=====================================================================================================*/
/*=====================================================================================================*
**函數 : USART_SendByte
**功能 : 發送 1Byte 資料
**輸入 : USARTx, *SendData
**輸出 : None
**使用 : USART_SendByte(USART1, 'A');
**=====================================================================================================*/
/*=====================================================================================================*/
void USART_SendByte(USART_TypeDef *USARTx, uc8 *SendData)
{
	USART_SendData(USARTx, *SendData);

	while (USART_GetFlagStatus(USARTx, USART_FLAG_TXE) == RESET);
}
/*=====================================================================================================*/
/*=====================================================================================================*
**函數 : USART_RecvByte
**功能 : 接收 1Byte 資料
**輸入 : USARTx
**輸出 : RecvData
**使用 : RecvData = USART_RecvByte(USART1);
**=====================================================================================================*/
/*=====================================================================================================*/
u16 USART_RecvByte(USART_TypeDef *USARTx)
{
	while (USART_GetFlagStatus(USARTx, USART_FLAG_RXNE) == RESET);

	return USART_ReceiveData(USARTx);
}
/*=====================================================================================================*/
/*=====================================================================================================*/
