`ifndef AFIFO_VSQR__SV
`define AFIFO_VSQR__SV

class afifo_vsqr extends uvm_sequencer;

    afifo_sequencer wr_sqr;
    afifo_sequencer rd_sqr;

    function new(string name="afifo_vsqr", uvm_component parent);
        super.new(name, parent);
    endfunction 

    `uvm_component_utils(afifo_vsqr)
endclass:afifo_vsqr

`endif // AFIFO_VSQR__SV