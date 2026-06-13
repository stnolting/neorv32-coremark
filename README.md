# CoreMark® on NEORV32

[![License](https://img.shields.io/github/license/stnolting/neorv32-coremark?longCache=true&style=flat-square&label=License)](https://github.com/stnolting/neorv32-coremark/blob/main/LICENSE)

This repository provides a port of the Embedded Microprocessor Benchmark Consortium
[CoreMark®](https://github.com/eembc/coremark) benchmark for the
[NEORV32](https://github.com/stnolting/neorv32) RISC-V processor.
The target-specific code is outsourced to the `core_portme.[h/c]` files.

## Setup

CoreMark and NEORV32 are included in this repository as submodules.
Make sure to clone the repository _recursively_ to include both submodules.

```bash
$ git clone --recursive https://github.com/stnolting/neorv32-coremark.git
```

Use the [Makefile](makefile) to customize the compilation of coremark for a specific configuration of neorv32:

```makefile
# CPU ISA / extensions
MARCH = rv32imc_zicsr_zifence
```

```makefile
# IMEM/DMEM layout
USER_FLAGS += \
-Wl,--defsym,__neorv32_rom_size=64k \
-Wl,--defsym,__neorv32_rom_base=0x00000000 \
-Wl,--defsym,__neorv32_ram_size=64k \
-Wl,--defsym,__neorv32_ram_base=0x80000000 \
-Wl,--defsym,__neorv32_heap_size=32k
```

The standard configuration requires 64 KB of IMEM and 64 KB of DMEM.
However, depending on the Makefile configuration, the memory requirements may be lower.

By default, the single-core version of NEORV32 is used. To compile code for the SMP dual-core version,
set the `MULTITHREAD=2` in the Makefile:

```makefile
# Single core (MULTITHREAD=1) / dual-core (MULTITHREAD=2) configuration
USER_FLAGS += -DMULTITHREAD=2
```

Compile the executable (`elf` for JTAG upload, `exe` for UART upload; requires RISC-V GCC).
See the NEORV32 [data sheet](https://stnolting.github.io/neorv32) for more information about
the available executable image formats.

```bash
neorv32-coremark$ make clean elf exe
```

## Results

Configuration: NEORV32 v1.13.1.3, `rv32imc_zicsr_zifencei` CPU, fast mul & shift options enabled,
I$ & D$ enabled, bursts enabled, 64kB IMEM, 64kB DMEM.

### Single-Core

```
CoreMark on NEORV32 (v1.13.1.3)

Processor clock = 100000000 Hz
Running coremark (2000 iterations)...

2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 2114519826
Total time (secs): 21.000000
Iterations/Sec   : 95.238095
Iterations       : 2000
Compiler version : GCC15.2.0
Compiler flags   : -march=rv32imc_zicsr_zifencei -mabi=ilp32 -O3 -Wall -Wextra -ffunction-sections -fdata-sections -mno-fdiv -mstrict-align -mbranch-cost=10 -ffp-contract=off -g -Wl,--defsym,__neorv32_rom_size=64k -Wl,--defsym,__neorv32_rom_base=0x00000000 -Wl,--defsym,__neorv32_ram_size=64k -Wl,--defsym,__neorv32_ram_base=0x80000000 -Wl,--defsym,__neorv32_heap_size=32k -DMULTITHREAD=1
Memory location  : STATIC
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[0]crcfinal      : 0x4983
Correct operation validated. See README.md for run and reporting rules.
CoreMark 1.0 : 95.238095 / GCC15.2.0 -march=rv32imc_zicsr_zifencei -mabi=ilp32 -O3 -Wall -Wextra -ffunction-sections -fdata-sections -mno-fdiv -mstrict-align -mbranch-cost=10 -ffp-contract=off -g -Wl,--defsym,__neorv32_rom_size=64k -Wl,--defsym,__neorv32_rom_base=0x00000000 -Wl,--defsym,__neorv32_ram_size=64k -Wl,--defsym,__neorv32_ram_base=0x80000000 -Wl,--defsym,__neorv32_heap_size=32k -DMULTITHREAD=1 / STATIC

Execution completed.
```

### Dual-Core

```
CoreMark on NEORV32 (v1.13.1.3) - SMP dual-core version

Processor clock = 100000000 Hz
Running coremark (2000 iterations)...

2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 2120411516
Total time (secs): 21.000000
Iterations/Sec   : 190.476190
Iterations       : 4000
Compiler version : GCC15.2.0
Compiler flags   : -march=rv32imc_zicsr_zifencei -mabi=ilp32 -O3 -Wall -Wextra -ffunction-sections -fdata-sections -mno-fdiv -mstrict-align -mbranch-cost=10 -ffp-contract=off -g -Wl,--defsym,__neorv32_rom_size=64k -Wl,--defsym,__neorv32_rom_base=0x00000000 -Wl,--defsym,__neorv32_ram_size=64k -Wl,--defsym,__neorv32_ram_base=0x80000000 -Wl,--defsym,__neorv32_heap_size=32k -DMULTITHREAD=2
Parallel Proprietary : 2
Memory location  : STATIC
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[1]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[1]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[1]crcstate      : 0x8e3a
[0]crcfinal      : 0x4983
[1]crcfinal      : 0x4983
Correct operation validated. See README.md for run and reporting rules.
CoreMark 1.0 : 190.476190 / GCC15.2.0 -march=rv32imc_zicsr_zifencei -mabi=ilp32 -O3 -Wall -Wextra -ffunction-sections -fdata-sections -mno-fdiv -mstrict-align -mbranch-cost=10 -ffp-contract=off -g -Wl,--defsym,__neorv32_rom_size=64k -Wl,--defsym,__neorv32_rom_base=0x00000000 -Wl,--defsym,__neorv32_ram_size=64k -Wl,--defsym,__neorv32_ram_base=0x80000000 -Wl,--defsym,__neorv32_heap_size=32k -DMULTITHREAD=2 / STATIC / 2:SMP-dual-core

Execution completed.
```
