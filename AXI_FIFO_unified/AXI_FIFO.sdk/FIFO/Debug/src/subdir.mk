################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/dma_intr.c \
../src/main.c \
../src/sys_intr.c \
../src/timer_intr.c 

OBJS += \
./src/dma_intr.o \
./src/main.o \
./src/sys_intr.o \
./src/timer_intr.o 

C_DEPS += \
./src/dma_intr.d \
./src/main.d \
./src/sys_intr.d \
./src/timer_intr.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../FIFO_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


