Vid: *.sv id.cpp
	verilator -Wall -Wno-fatal -trace --cc id.sv --exe id.cpp
	make -j -C obj_dir -f Vid.mk Vid
	cp obj_dir/Vid .
Vmips: *.sv mips.cpp rom.hex
	verilator -Wall -Wno-fatal -trace --cc mips.sv --exe mips.cpp
	make -j -C obj_dir -f Vmips.mk Vmips
	cp obj_dir/Vmips .
rom.o: rom.S
	mipsel-elf-as -mips32 -EB rom.S -o rom.o
rom.bin: rom.o
	mipsel-elf-objcopy -O binary rom.o -j .text rom.bin
rom.hex: rom.bin
	xxd -p rom.bin | tr -d '\n' | sed -e 's/\(.\{8\}\)/\1\n/g' > rom.hex

.PHONY: clean disasm all
clean:
	rm -f Vmips Vid rom.o rom.bin rom.hex
	rm -rf obj_dir
disasm: rom.o
	mipsel-elf-objdump -D -j .text rom.o
all: Vid Vmips
