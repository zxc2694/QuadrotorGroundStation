#include "stm32f4_system.h"
#include "main.h"
#include "stm32f4_delay.h"
#include "led.h"
#include "module_nrf24l01.h"
#include "module_rs232.h"


void System_Init(void)
{
	SystemInit();
	RS232_Config();
}


int main(void)
{

	System_Init();
	char String[50] ;
	char x;
	printf("Test Xbee .....\n\r");
    	while(1){
    		x=USART_RecvByte(USART3); 
    		printf("%c\n\r",x);
    	}
}
