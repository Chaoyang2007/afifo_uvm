`ifndef AFIFO_AGENT_PROP__SV
`define AFIFO_AGENT_PROP__SV

// class define, agent properties
class afifo_agent_prop extends uvm_object;

    virtual afifo_if vif;
    bit              rnw; // read not write

    function new(string name="afifo_agent_prop");
        super.new(name);
    endfunction

    `uvm_object_utils(afifo_agent_prop)
endclass:afifo_agent_prop

`endif // AFIFO_AGENT_PROP__SV