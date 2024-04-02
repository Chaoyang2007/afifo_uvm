`ifndef AFIFO_BASE_VSEQ__SV
`define AFIFO_BASE_VSEQ__SV

class afifo_base_vseq extends uvm_sequence #(afifo_transaction);
    `uvm_object_utils(afifo_base_vseq)
    `uvm_declare_p_sequencer(afifo_vsqr)//(afifo_sequencer)

    function new(string name="afifo_base_vseq");
        super.new(name);
    endfunction

endclass:afifo_base_vseq
`endif // AFIFO_BASE_VSEQ__SV
