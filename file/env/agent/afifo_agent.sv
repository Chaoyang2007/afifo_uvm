`ifndef AFIFO_AGENT__SV
`define AFIFO_AGENT__SV

// class define
class afifo_agent extends uvm_agent;

    afifo_sequencer  sqr;
    afifo_driver     drv;
    afifo_monitor    mon;
    afifo_agent_prop agt_prop;
    uvm_analysis_port #(busdata_t) ap;

    function new(string name="afifo_agent", uvm_component parent);
        super.new(name, parent);
    endfunction
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    `uvm_component_utils(afifo_agent)
endclass:afifo_agent

// build phase
function void afifo_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(is_active==UVM_ACTIVE) begin
        sqr = afifo_sequencer::type_id::create("sqr", this);
        drv = afifo_driver::type_id::create("drv", this);
    end
    mon = afifo_monitor::type_id::create("mon", this);
    agt_prop = afifo_agent_prop::type_id::create("agt_prop", this);

    if(!uvm_config_db#(afifo_agent_prop)::get(this, "", "agent_property", agt_prop))
        `uvm_fatal(get_full_name(), "agent gets agent_property error!")

    uvm_config_db#(virtual afifo_if)::set(this, "*", "vif", agt_prop.vif);
    uvm_config_db#(bit)::set(this, "*", "rnw", agt_prop.rnw); // drv, mon
endfunction:build_phase

// connect phase
function void afifo_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(is_active==UVM_ACTIVE) begin
        drv.seq_item_port.connect(sqr.seq_item_export);
    end
    ap = mon.ap;
endfunction:connect_phase

`endif // AFIFO_AGENT__SV
