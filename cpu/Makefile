#!/bin/sh
Vid: *.v id.cpp
	verilator -Wno-fatal -trace --cc id.v --exe id.cpp
	make -j -C obj_dir -f Vid.mk Vid
	cp obj_dir/Vid .
Vmips: *.v mips.cpp
	verilator -Wno-fatal -trace --cc mips.v --exe mips.cpp
	make -j -C obj_dir -f Vmips.mk Vmips
	cp obj_dir/Vmips .
