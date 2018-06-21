#!/bin/sh
Vour: our.v sim_main.cpp
	verilator -Wall --cc our.v --exe sim_main.cpp
	make -j -C obj_dir -f Vour.mk Vour
	cp obj_dir/Vour .
