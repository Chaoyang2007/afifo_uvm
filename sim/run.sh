#!/usr/bin/bash

vcs -full64 -sverilog /usr/uvm/uvm-1.1d/src/dpi/uvm_dpi.cc +v2k -l elab.log -debug_acc+all -kdb -lca +lint=TFIPC-L -timescale=1ns/1ps -work work_dut +error+99 -f filelist.f

./simv +fsdb+functions -ucli -i dump.tcl -l irun.log +UVM_TESTNAME=afifo_wr_rd_test 
#+UVM_CONFIG_DB_TRACE
