# afifo_uvm

uvm study

0. interface, transaction, defines
../file/cfg/defines.sv
../file/cfg/afifo_transaction.sv
../file/cfg/afifo_if.sv

1. components
../file/env/agent/afifo_sequencer.sv
../file/env/agent/afifo_monitor.sv
../file/env/agent/afifo_driver.sv
../file/env/agent/afifo_agent.sv
../file/env/afifo_scoreboard.sv
../file/env/afifo_env.sv

2. atom sequences, used to write/read/reset/config clock
../file/seq/afifo_idle_cycle_seq.sv
../file/seq/afifo_write_cycle_seq.sv
../file/seq/afifo_write_freq_seq.sv
../file/seq/afifo_write_rstn_seq.sv
../file/seq/afifo_read_cycle_seq.sv
../file/seq/afifo_read_freq_seq.sv
../file/seq/afifo_read_rstn_seq.sv

3. virtual sequences, containing differnt w/rclk combinations, w/rclk can be configured by seting +define+*=* while simulation
../file/vec/afifo_basic_vec_vseq.sv
../file/vec/afifo_wr_rd_vseq.sv
../file/vec/afifo_wr_fast_vseq.sv
../file/vec/afifo_rd_fast_vseq.sv

4. test cases, specify one of them when running a simulation
../file/test/afifo_wr_rd_test.sv
../file/test/afifo_wr_fast_test.sv
../file/test/afifo_rd_fast_test.sv
