`ifndef AFIFO_ENV__SV
`define AFIFO_ENV__SV

// class define
class afifo_env extends uvm_env;

    afifo_agent      wr_agt;
    afifo_agent      rd_agt;
    afifo_scoreboard scb;
    afifo_env_prop   env_prop;
    uvm_tlm_analysis_fifo #(busdata_t) wagt_scb_fifo;
    uvm_tlm_analysis_fifo #(busdata_t) ragt_scb_fifo;

    function new(string name="afifo_env", uvm_component parent);
        super.new(name, parent);
    endfunction
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    `uvm_component_utils(afifo_env)
endclass:afifo_env

// build phase
function void afifo_env::build_phase(uvm_phase phase);
    super.build_phase(phase);

    wr_agt = afifo_agent::type_id::create("wr_agt", this);
    rd_agt = afifo_agent::type_id::create("rd_agt", this);
    scb    = afifo_scoreboard::type_id::create("scb", this);
    wr_agt.is_active = UVM_ACTIVE;
    rd_agt.is_active = UVM_ACTIVE;
    wagt_scb_fifo    = new("wagt_scb_fifo", this);
    ragt_scb_fifo    = new("ragt_scb_fifo", this);
    env_prop = afifo_env_prop::type_id::create("env_prop", this);

    if(!uvm_config_db#(afifo_env_prop)::get(this, "", "env_property", env_prop))
        `uvm_fatal(get_full_name(), "env gets env_property error!")

    uvm_config_db#(afifo_agent_prop)::set(this, "wr_agt", "agent_property", env_prop.wagt_prop);
    uvm_config_db#(afifo_agent_prop)::set(this, "rd_agt", "agent_property", env_prop.ragt_prop);
endfunction:build_phase

// connect phase
function void afifo_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    wr_agt.ap.connect(wagt_scb_fifo.analysis_export);
    scb.exp_port.connect(wagt_scb_fifo.blocking_get_export);
    rd_agt.ap.connect(ragt_scb_fifo.analysis_export);
    scb.act_port.connect(ragt_scb_fifo.blocking_get_export);
endfunction:connect_phase

`endif // AFIFO_ENV__SV
