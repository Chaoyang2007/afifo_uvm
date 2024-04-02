`ifndef AFIFO_BASE_TEST__SV
`define AFIFO_BASE_TEST__SV

class afifo_base_test extends uvm_test;

    afifo_env  env;

    afifo_vsqr vsqr;
    afifo_agent_prop wagt_prop;
    afifo_agent_prop ragt_prop;
    afifo_env_prop   env_prop;

    function new(string name="afifo_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);

    `uvm_component_utils(afifo_base_test)
endclass:afifo_base_test

// build phase
function void afifo_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);

    env  = afifo_env::type_id::create("env", this);

    vsqr = afifo_vsqr::type_id::create("vsqr", this);
    wagt_prop = afifo_agent_prop::type_id::create("wagt_prop", this);
    ragt_prop = afifo_agent_prop::type_id::create("ragt_prop", this);
    env_prop  = afifo_env_prop::type_id::create("env_prop", this);
    wagt_prop.rnw = 'b0;
    ragt_prop.rnw = 'b1;

    if(!uvm_config_db#(virtual afifo_if)::get(this, "", "wr_agent_vif", wagt_prop.vif))
        `uvm_fatal(get_full_name(), "wr_agent_vif connect error!")
    if(!uvm_config_db#(virtual afifo_if)::get(this, "", "rd_agent_vif", ragt_prop.vif))
        `uvm_fatal(get_full_name(), "rd_agent_vif connect error!")
    env_prop.wagt_prop = wagt_prop; //
    env_prop.ragt_prop = ragt_prop; //
    uvm_config_db#(afifo_env_prop)::set(this, "env*", "env_property", env_prop);

    uvm_top.set_timeout(100000ns,0);
endfunction:build_phase

// connect phase
function void afifo_base_test::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    vsqr.wr_sqr = env.wr_agt.sqr;
    vsqr.rd_sqr = env.rd_agt.sqr;

endfunction:connect_phase

// report phase
function void afifo_base_test::report_phase(uvm_phase phase);
    uvm_report_server server;
    int               err_num;
    super.report_phase(phase); //after server declare
    server  = get_report_server();
    err_num = server.get_severity_count(UVM_ERROR);
    if (err_num != 0) begin
        $display($time, "TEST CASE FAILED");
    end
    else begin
        $display($time, "TEST CASE PASSED");
    end
endfunction:report_phase

`endif // AFIFO_BASE_TEST__SV
