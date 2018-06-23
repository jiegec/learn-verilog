#!/bin/sh
Vid: *.v id.cpp
	verilator -Wno-fatal -trace --cc id.v --exe id.cpp
	make -j -C obj_dir -f Vid.mk Vid
	cp obj_dir/Vid .
Vmips: *.v mips.cpp rom.hex
	verilator -Wno-fatal -trace --cc mips.v --exe mips.cpp
	make -j -C obj_dir -f Vmips.mk Vmips
	cp obj_dir/Vmips .
rom.o: rom.S
	mipsel-elf-as -EB rom.S -o rom.o
rom.bin: rom.o
	mipsel-elf-objcopy -O binary rom.o -j .text rom.bin
rom.hex: rom.bin
	xxd -ps rom.bin | sed -e 's/\([0-9a-eA-E]\{8\}\)/\1\n/g' > rom.hex
.PHONY: clean
clean:
	rm Vmips Vid rom.o rom.bin rom.hex
