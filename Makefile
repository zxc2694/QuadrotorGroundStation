#Output files
EXECUTABLE=QuadrotorFlightControl.elf
BIN_IMAGE=QuadrotorFlightControl.bin

#======================================================================#
#Cross Compiler
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
ST_LIB = ./Libraries/STM32F4xx_StdPeriph_Driver

TOOLCHAIN_PATH ?= /usr/local/csl/arm-2012.03/arm-none-eabi
C_LIB= $(TOOLCHAIN_PATH)/lib/thumb2

CFLAGS=-g -mlittle-endian -mthumb
CFLAGS+=-mcpu=cortex-m4
CFLAGS+=-mfpu=fpv4-sp-d16 -mfloat-abi=softfp
CFLAGS+=-ffreestanding -nostdlib -Wall

#Flash
CFLAGS+=-Wl,-T,stm32_flash.ld

CFLAGS+=-I./

#STM32 CMSIS
CFLAGS+= \
	-D STM32F40XX \
	-D USE_STDPERIPH_DRIVER \
	-D __FPU_PRESENT=1 \
	-D ARM_MATH_CM4
	# __FPU_USED=1
	#__CC_ARM
CFLAGS+=-I./Libraries/CMSIS
#STM32F4xx Peripherys including
CFLAGS+=-I./Libraries/STM32F4xx_StdPeriph_Driver/inc

LDFLAGS += -lm -lc -lgcc

#STM32 CMSIS
SRC=$(wildcard ./Libraries/CMSIS/*.c)
#STM32F4xx Peripherys source code
#SRC+=$(wildcard ./Libraries/STM32F4xx_StdPeriph_Driver/src/*.c)
SRC+= ./Libraries/CMSIS/system_stm32f4xx.c \
	$(ST_LIB)/src/stm32f4xx_rcc.c \
	$(ST_LIB)/src/stm32f4xx_gpio.c \
	$(ST_LIB)/src/stm32f4xx_usart.c \
	$(ST_LIB)/src/stm32f4xx_spi.c\


#Major programs source code
SRC += module_nrf24l01.c module_rs232.c stm32f4_spi.c stm32f4_delay.c\
		main.c \
		stm32f4_usart.c \
		led.c\
		algorithm_string.c \
		Libraries/CMSIS/FastMathFunctions/arm_cos_f32.c \
		Libraries/CMSIS/FastMathFunctions/arm_sin_f32.c


#STM32 startup file
STARTUP=./Libraries/CMSIS/startup_stm32f4xx.s
#======================================================================#

#Make all
all:$(BIN_IMAGE)

$(BIN_IMAGE):$(EXECUTABLE)
	$(OBJCOPY) -O binary $^ $@

STARTUP_OBJ = startup_stm32f4xx.o

$(STARTUP_OBJ): $(STARTUP)
	$(CC) $(CFLAGS) $^ -c $(STARTUP)

$(EXECUTABLE):$(SRC) $(STARTUP_OBJ)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

#Make clean
clean:
	rm -rf $(EXECUTABLE)
	rm -rf $(BIN_IMAGE)

#Make flash
flash:
	st-flash write $(BIN_IMAGE) 0x8000000
#======================================================================#
openocd: flash
	openocd -s /opt/openocd/share/openocd/scripts/
gdbauto:
	arm-none-eabi-gdb -x openocd_gdb.gdb

.PHONY:all clean flash openocd gdbauto
