################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/New_Algo.c \
../src/ac97.c \
../src/ac97_demo.c \
../src/ac97_irq.c \
../src/mul_complex.c \
../src/platform.c 

LD_SRCS += \
../src/lscript.ld 

OBJS += \
./src/New_Algo.o \
./src/ac97.o \
./src/ac97_demo.o \
./src/ac97_irq.o \
./src/mul_complex.o \
./src/platform.o 

C_DEPS += \
./src/New_Algo.d \
./src/ac97.d \
./src/ac97_demo.d \
./src/ac97_irq.d \
./src/mul_complex.d \
./src/platform.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../noiseCancer_bsp/microblaze_0/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.50.c -mno-xl-soft-mul -mhard-float -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


