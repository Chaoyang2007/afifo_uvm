`ifndef AFIFO_MONITOR__SV
`define AFIFO_MONITOR__SV

// class define
class afifo_monitor extends uvm_component;

    virtual afifo_if vif;
    bit              rnw; // read not write
    int    collected_cnt;
    uvm_analysis_port #(busdata_t) ap;

    function new(string name="afifo_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction
    extern virtual function void build_phase(uvm_phase phase);
    // extern virtual function void connect_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    extern task collect_once_write(ref busdata_t tr_data);
    extern task collect_once_read(ref busdata_t tr_data);

    `uvm_component_utils(afifo_monitor)
endclass:afifo_monitor

// build phase
function void afifo_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual afifo_if)::get(this,"","vif",vif))
        `uvm_fatal(get_full_name(), "vif connect error!")
    if(!uvm_config_db#(bit)::get(this,"","rnw",rnw))
        `uvm_fatal(get_full_name(), "rnw bit get error!")

    ap = new("ap", this);
endfunction:build_phase

// main phase, behavior of monitor
task afifo_monitor::main_phase(uvm_phase phase);
    //super.main_phase(phase);
    busdata_t tr_data;
    //int collected_cnt;
    if(!rnw) begin
        forever begin
            collect_once_write(tr_data);
            collected_cnt++;
            `uvm_info(get_full_name(), $sformatf("%d-th write_data [%h] is cellected", collected_cnt, tr_data), UVM_MEDIUM);
            // $display($time, "%d-th write_data [%h] is cellected", collected_cnt, tr_data);
            ap.write(tr_data);
        end
    end else begin
        forever begin
            collect_once_read(tr_data);
            collected_cnt++;
            `uvm_info(get_full_name(), $sformatf("%d-th read_data [%h] cellected", collected_cnt, tr_data), UVM_MEDIUM);
            // $display($time, "%d-th read_data [%h] cellected", collected_cnt, tr_data);
            ap.write(tr_data);
        end
    end
endtask:main_phase

// collect once write
task afifo_monitor::collect_once_write(ref busdata_t tr_data);
    /* while ((1)) begin
        @(vif.wr_mon_cb);
        if(vif.wr_mon_cb.write==1 && vif.wr_mon_cb.wfull==0)
        break;
    end
    tr_data = vif.wr_mon_cb.wdata; */

    @(vif.wr_mon_cb iff (vif.wreset_b==1 && vif.wr_mon_cb.write==1 && vif.wr_mon_cb.wfull==0));
        tr_data = vif.wr_mon_cb.wdata;
endtask:collect_once_write

// collect once read
task afifo_monitor::collect_once_read(ref busdata_t tr_data);
    /* while ((1)) begin
        @(vif.rd_mon_cb);
        if(vif.rd_mon_cb.read==1 && vif.rd_mon_cb.rempty==0)
        break;
    end
    tr_data = vif.rd_mon_cb.rdata; */

    @(vif.rd_mon_cb iff (/*vif.wreset_b==1 &&*/ vif.rreset_b==1 && vif.rd_mon_cb.read==1 && vif.rd_mon_cb.rempty==0));
        tr_data = vif.rd_mon_cb.rdata;
endtask:collect_once_read

`endif // AFIFO_MONITOR__SV
