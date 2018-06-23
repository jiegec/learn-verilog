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
	cat rom.bin | perl -lpe '$$_=join "\n", unpack"(H8)*"' > rom.hex
.PHONY: clean disasm
clean:
	rm Vmips Vid rom.o rom.bin rom.hex
disasm: rom.o
	mipsel-elf-objdump -D -j .text rom.o
