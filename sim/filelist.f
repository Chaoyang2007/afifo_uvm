+incdir+$UVM_HOME/src
$UVM_HOME/src/uvm_pkg.sv
./uvm_import.sv

../arc/afifo.v

../file/cfg/defines.sv
../file/cfg/afifo_transaction.sv
../file/cfg/afifo_if.sv

../file/seq/afifo_idle_cycle_seq.sv
../file/seq/afifo_write_cycle_seq.sv
../file/seq/afifo_write_freq_seq.sv
../file/seq/afifo_write_rstn_seq.sv
../file/seq/afifo_read_cycle_seq.sv
../file/seq/afifo_read_freq_seq.sv
../file/seq/afifo_read_rstn_seq.sv

../file/env/agent/afifo_agent_prop.sv
../file/env/agent/afifo_sequencer.sv
../file/env/agent/afifo_monitor.sv
../file/env/agent/afifo_driver.sv
../file/env/agent/afifo_agent.sv
../file/env/afifo_env_prop.sv
../file/env/afifo_scoreboard.sv
../file/env/afifo_env.sv

../file/vsqr/afifo_vsqr.sv
../file/vec/afifo_base_vseq.sv
../file/vec/afifo_basic_vec_vseq.sv
../file/vec/afifo_wr_rd_vseq.sv
../file/vec/afifo_wr_fast_vseq.sv
../file/vec/afifo_rd_fast_vseq.sv

../file/test/afifo_base_test.sv
../file/test/afifo_wr_rd_test.sv
../file/test/afifo_wr_fast_test.sv
../file/test/afifo_rd_fast_test.sv
../file/top/top.sv
