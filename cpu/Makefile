#!/bin/sh
Vinst_fetch: *.v inst_fetch.cpp
	verilator -trace --cc inst_fetch.v --exe inst_fetch.cpp
	make -j -C obj_dir -f Vinst_fetch.mk Vinst_fetch
	cp obj_dir/Vinst_fetch .
