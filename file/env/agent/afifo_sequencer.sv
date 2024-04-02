`ifndef AFIFO_SEQUENCER
`define AFIFO_SEQUENCER

// class define
class afifo_sequencer extends uvm_sequencer #(afifo_transaction);

    function new(string name="afifo_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction
    //extern task main_phase(uvm_phase phase);

    `uvm_component_utils(afifo_sequencer)
endclass:afifo_sequencer

// main phase
/* function afifo_sequencer::main_phase(uvm_phase phase);
    afifo_sequence seq;
    phase.raise_objection(this);
    seq = afifo_sequence::type_id::create("seq");
    seq.start(this);
    seq.drop_objection(this);
endfunction:main_phase */

`endif // AFIFO_SEQUENCER
