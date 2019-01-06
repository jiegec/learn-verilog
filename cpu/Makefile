TARGET ?= mipsel-elf
CFLAGS ?= --std=c++14
VERILATOR ?= verilator
VERILATOR_FLAGS ?= -Wall -Wno-fatal -trace -CFLAGS $(CFLAGS)

Vid: *.sv id.cpp
	$(VERILATOR) $(VERILATOR_FLAGS) --cc id.sv --exe id.cpp
	make -j -C obj_dir -f Vid.mk Vid
	cp obj_dir/Vid .
Vmips: *.sv mips.cpp rom.hex
	$(VERILATOR) $(VERILATOR_FLAGS) --cc mips.sv --exe mips.cpp
	make -j -C obj_dir -f Vmips.mk Vmips
	cp obj_dir/Vmips .
rom.o: rom.S
	$(TARGET)-as -mips32 -EB rom.S -o rom.o
rom.bin: rom.o
	$(TARGET)-objcopy -O binary rom.o -j .text rom.bin
rom.hex: rom.bin
	xxd -p rom.bin | tr -d '\n' | fold -w8 > rom.hex

.PHONY: clean disasm all
clean:
	rm -f Vmips Vid rom.o rom.bin rom.hex
	rm -rf obj_dir
disasm: rom.o
	$(TARGET)-objdump -D -j .text rom.o
all: Vid Vmips
