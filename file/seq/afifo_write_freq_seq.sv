`ifndef AFIFO_WRITE_FREQ_SEQ__SV
`define AFIFO_WRITE_FREQ_SEQ__SV

class afifo_write_freq_seq extends uvm_sequence#(afifo_transaction);
    `uvm_object_utils(afifo_write_freq_seq)
    rand int clk_period;
    constraint clkp_c{
        clk_period >= 1;
        clk_period <= 128;
    }
    function new(string name="afifo_write_freq_seq");
        super.new(name);
    endfunction 

    virtual task body();
        afifo_idle_cycle_seq ridle_seq;
        `uvm_do(ridle_seq);
        // uvm_config_db#(int)::set(uvm_root::get(), "", "wclk_period", clk_period); //uvm_top
        uvm_config_db#(int)::set(null, "uvm_test_top", "wclk_period", clk_period);
        `uvm_info(get_full_name(), $sformatf("write clk period is set to %0d", clk_period), UVM_LOW);
        // $display($time, "write clk period is set to %0d", clk_period);
        `uvm_do(ridle_seq);
    endtask
endclass:afifo_write_freq_seq

`endif // AFIFO_WRITE_FREQ_SEQ__SV
