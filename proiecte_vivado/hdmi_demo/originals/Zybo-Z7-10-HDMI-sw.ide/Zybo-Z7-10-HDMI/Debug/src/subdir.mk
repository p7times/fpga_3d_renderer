################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
D:/Zybo-Z7-SW/src/Zybo-Z7-10-HDMI/src/lscript.ld 

C_SRCS += \
D:/Zybo-Z7-SW/src/Zybo-Z7-10-HDMI/src/video_demo.c 

OBJS += \
./src/video_demo.o 

C_DEPS += \
./src/video_demo.d 


# Each subdirectory must supply rules for building sources it contributes
src/video_demo.o: D:/Zybo-Z7-SW/src/Zybo-Z7-10-HDMI/src/video_demo.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -DDEBUG -Wall -O0 -g3 -ID:/Zybo-Z7-SW/src/Zybo-Z7-10-HDMI/src -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -ID:/Zybo-Z7-SW/ws/design_1_wrapper/export/design_1_wrapper/sw/design_1_wrapper/domain_ps7_cortexa9_0/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


