#!/bin/sh
Vid: *.v id.cpp
	verilator -Wno-fatal -trace --cc id.v --exe id.cpp
	make -j -C obj_dir -f Vid.mk Vid
	cp obj_dir/Vid .
Vif_and_id: *.v if_and_id.cpp
	verilator -Wno-fatal -trace --cc if_and_id.v --exe if_and_id.cpp
	make -j -C obj_dir -f Vif_and_id.mk Vif_and_id
	cp obj_dir/Vif_and_id .
