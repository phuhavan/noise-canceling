################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
noiseCancer.elf.size \

ELFCHECK += \
noiseCancer.elf.elfcheck \


# All Target
all: noiseCancer.elf secondary-outputs

# Tool invocations
noiseCancer.elf: $(OBJS) ../lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: MicroBlaze gcc linker'
	mb-gcc -Wl,-T -Wl,../lscript.ld -L../../noiseCancer_bsp/microblaze_0/lib -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.50.c -mno-xl-soft-mul -mhard-float -Wl,--no-relax -Wl,--gc-sections -o "noiseCancer.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

noiseCancer.elf.size: noiseCancer.elf
	@echo 'Invoking: MicroBlaze Print Size'
	mb-size noiseCancer.elf  |tee "noiseCancer.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

noiseCancer.elf.elfcheck: noiseCancer.elf
	@echo 'Invoking: Xilinx ELF Check'
	elfcheck noiseCancer.elf -hw ../../project_hw_platform/system.xml -pe microblaze_0  |tee "noiseCancer.elf.elfcheck"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) noiseCancer.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
