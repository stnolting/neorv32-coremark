# NEORV32 Coremark

# CPU ISA / extensions
MARCH = rv32imcb_zicsr_zifencei_zicond

# Ooptimization
EFFORT = -O3

# IMEM/DMEM layout
USER_FLAGS += \
-Wl,--defsym,__neorv32_rom_size=64k \
-Wl,--defsym,__neorv32_rom_base=0x00000000 \
-Wl,--defsym,__neorv32_ram_size=64k \
-Wl,--defsym,__neorv32_ram_base=0x80000000 \
-Wl,--defsym,__neorv32_heap_size=32k

# Single-core (MULTITHREAD=1) / dual-core (MULTITHREAD=2) configuration
USER_FLAGS += -DMULTITHREAD=1

# Sources
APP_SRC += $(wildcard coremark/*.c) core_portme.c
APP_INC += -I coremark -I .

# Include main NEORV32 makefile
NEORV32_HOME ?= neorv32
include $(NEORV32_HOME)/sw/common/common.mk
