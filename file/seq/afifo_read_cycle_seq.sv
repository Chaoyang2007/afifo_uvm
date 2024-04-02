`ifndef AFIFO_READ_CYCLE_SEQ__SV
`define AFIFO_READ_CYCLE_SEQ__SV

class afifo_read_cycle_seq extends uvm_sequence#(afifo_transaction);
    `uvm_object_utils(afifo_read_cycle_seq)
    rand int burst_len;
    constraint blen_c{
        soft burst_len == 1; // default 1 cycle
    }
    
    function new(string name="afifo_read_cycle_seq");
        super.new(name);
    endfunction 

    virtual task body();
        afifo_transaction tr;
        `uvm_do_with(tr, {tr.idle==0; tr.rnw==1; tr.cycle_num==burst_len;});
    endtask
endclass:afifo_read_cycle_seq

`endif // AFIFO_READ_CYCLE_SEQ__SV