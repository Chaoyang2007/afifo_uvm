`ifndef AFIFO_TRANSACTION__SV
`define AFIFO_TRANSACTION__SV

class afifo_transaction extends uvm_sequence_item;

    rand bit              rnw; // read not write
    rand bit              idle;
    rand busdata_t        data_q[]; // [$];
    rand int              cycle_num; // idle, read , or write cycles


    constraint idlenum_c{
        cycle_num >= 1;
        cycle_num <= `DEPTH*4;
    }
    constraint qsize_c{
        (!rnw) -> data_q.size == cycle_num;
        (idle || rnw) -> data_q.size == 0;
    }

    `uvm_object_utils_begin(afifo_transaction)
        `uvm_field_int(rnw,    UVM_ALL_ON)
        `uvm_field_int(idle,   UVM_ALL_ON)
        `uvm_field_array_int(data_q, UVM_ALL_ON) //queue
        `uvm_field_int(cycle_num,     UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="afifo_transaction");
        super.new();
    endfunction

endclass:afifo_transaction

`endif // AFIFO_TRANSACTION__SV