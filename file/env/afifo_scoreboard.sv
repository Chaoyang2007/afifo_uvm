`ifndef AFIFO_SCOREBOARD__SV
`define AFIFO_SCOREBOARD__SV

class afifo_scoreboard extends uvm_component;

    busdata_t        expect_queue[$];
    int              wr_cnt;//=0;
    int              rd_cnt;//=0;
    afifo_env_prop   env_prop;
    uvm_blocking_get_port #(busdata_t) exp_port;
    uvm_blocking_get_port #(busdata_t) act_port;

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
    extern task monitor_wr();
    extern task monitor_rd();
    extern task monitor_wrst();

    `uvm_component_utils(afifo_scoreboard)
endclass:afifo_scoreboard

// build phase
function void afifo_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_prop = afifo_env_prop::type_id::create("env_prop", this);

    if(!uvm_config_db#(afifo_env_prop)::get(this, "", "env_property", env_prop))
        `uvm_fatal(get_full_name(), "scoreboard gets env_property error!")

    exp_port = new("exp_port", this);
    act_port = new("act_port", this);
endfunction:build_phase

// main phase, behavior of scoreboard
task afifo_scoreboard::main_phase(uvm_phase phase);
    super.main_phase(phase);
    fork
        monitor_wr();
        monitor_rd();
        monitor_wrst();
    join
endtask:main_phase

// monitor write
task afifo_scoreboard::monitor_wr();
    busdata_t get_expect;
    forever begin
        exp_port.get(get_expect);
        wr_cnt++;
        expect_queue.push_back(get_expect);
        `uvm_info(get_full_name(), $sformatf("%d-th scb_wr data=%h", wr_cnt, get_expect), UVM_MEDIUM);
    end
endtask:monitor_wr

// monitor read
task afifo_scoreboard::monitor_rd();
    busdata_t get_actual;
    busdata_t temp_data;
    forever begin
        act_port.get(get_actual);
        rd_cnt++;
        if(expect_queue.size()) begin
            temp_data = expect_queue.pop_front();
            if(temp_data == get_actual) begin
                `uvm_info(get_full_name(), $sformatf("%d-th chk_rd data=%h", rd_cnt, get_actual), UVM_MEDIUM);
            end else begin
                `uvm_error(get_full_name(), $sformatf("%d-th chk_rd data=%h, scb data=%h, unmatched!", rd_cnt, get_actual, temp_data));
            end
        end else begin
            `uvm_error(get_full_name(), $sformatf("%d-th chk_rd data=%h, scb is empty!", rd_cnt, get_actual));
        end
    end
endtask:monitor_rd

// monitor wrst
task afifo_scoreboard::monitor_wrst();
    int scb_rst_cnt=0;
    forever begin
        @(negedge env_prop.wagt_prop.vif.wreset_b);
            expect_queue.delete();
            scb_rst_cnt++;
            `uvm_info(get_full_name(), $sformatf("%d-th scoreboard reset, queue is deleted", scb_rst_cnt), UVM_MEDIUM);
    end
endtask:monitor_wrst

`endif // AFIFO_SCOREBOARD__SV
