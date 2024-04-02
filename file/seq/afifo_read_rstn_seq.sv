`ifndef AFIFO_READ_RSTN_SEQ__SV
`define AFIFO_READ_RSTN_SEQ__SV

class afifo_read_rstn_seq extends uvm_sequence#(afifo_transaction);
    `uvm_object_utils(afifo_read_rstn_seq)
    rand bit deassert;
    rand bit auto_deassert;
    rand int wait_cycles;
    constraint reset_c{
        soft deassert == 0;
        soft auto_deassert == 1;
        soft wait_cycles == 5;
    }
    
    function new(string name="afifo_read_rstn_seq");
        super.new(name);
    endfunction 

    virtual task body();
        afifo_idle_cycle_seq ridle_seq;
        uvm_config_db#(bit)::set(null, "uvm_test_top", "rreset_b", deassert);
        if(!deassert) begin
            `uvm_info(get_full_name(), "assert read reset!", UVM_LOW);
        end else begin
            `uvm_info(get_full_name(), "deassert read reset!", UVM_LOW);
        end
        if(!deassert && auto_deassert) begin
            `uvm_do_with(ridle_seq, {burst_len==wait_cycles+1;});
            uvm_config_db#(bit)::set(null, "uvm_test_top", "rreset_b", 1);
            `uvm_info(get_full_name(), "auto-deassert read reset!", UVM_LOW);
            `uvm_do(ridle_seq);
        end
    endtask
endclass:afifo_read_rstn_seq

`endif // AFIFO_READ_RSTN_SEQ__SV
