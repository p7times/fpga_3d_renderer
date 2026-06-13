################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/timer_ps/timer_ps.c 

OBJS += \
./src/timer_ps/timer_ps.o 

C_DEPS += \
./src/timer_ps/timer_ps.d 


# Each subdirectory must supply rules for building sources it contributes
src/timer_ps/%.o: ../src/timer_ps/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -DDEBUG -Wall -O0 -g3 -ID:/Zybo-Z7-SW/src/Zybo-Z7-10-HDMI/src -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I/home/user/Desktop/Personal_Stuff/Homework/an4/LICENTA/licenta_repo/vivado/hdmi_demo/demo/design_1_wrapper/export/design_1_wrapper/sw/design_1_wrapper/domain_ps7_cortexa9_0/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


