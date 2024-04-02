VCS = vcs	-full64 -sverilog $$UVM_HOME/src/dpi/uvm_dpi.cc +v2k \
		-l elab.log \
		-debug_acc+all \
		-kdb -lca \
		+lint=TFIPC-L \
      		-timescale=1ns/1ps \
		-work work_dut \
		+error+99	

SIM = ./simv 	+fsdb+functions \
		-ucli -i dump.tcl \
		-l irun.log 

VERDI = verdi	-full64 -dbdir ./simv.daidir

comp:
	$(VCS)	-f filelist.f

sim:
	$(SIM)
#	$(SIM)	-gui=verdi

run:	comp sim

verdi:
	$(VERDI)
#	$(VERDI) -ssf twave.fsdb

clean:
	rm -rf csrc simv* *.lib *.lib++ nLint* novas*
	rm -rf *.log *.key *.fsdb
	rm -rf verdiLog

