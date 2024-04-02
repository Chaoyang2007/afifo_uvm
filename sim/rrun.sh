#!/usr/bin/bash

vcs -full64 -sverilog /usr/uvm/uvm-1.1d/src/dpi/uvm_dpi.cc +v2k -l elab.log -debug_acc+all -kdb -lca +lint=TFIPC-L -timescale=1ns/1ps -work work_dut +error+99 -f filelist.f +define+DEPTH=32 +define+WCTP=2 +define+CFACTOR=3

./simv +fsdb+functions -ucli -i dump.tcl -l irun.log +UVM_TESTNAME=$1  +UVM_PHASE_TRACE
#+UVM_VERBOSITY=UVM_LOW
#+UVM_PHASE_TRACE
#+UVM_CONFIG_DB_TRACE

mv ./irun.log ./$1.log
mv ./twave.fsdb ./$1.fsdb

gvim ./$1.log
verdi	-full64 -dbdir ./simv.daidir -ssf $1.fsdb -sswr ../signal.rc

