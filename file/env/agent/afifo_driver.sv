`ifndef AFIFO_DRIVER__SV
`define AFIFO_DRIVER__SV

// class define
class afifo_driver extends uvm_driver #(afifo_transaction);

    virtual afifo_if vif;
    bit              rnw; // read not write
    int       driven_cnt;
    int      wrst_assert;
    int      rrst_assert;

    function new(string name="afifo_driver", uvm_component parent);
        super.new(name, parent);
    endfunction
    extern virtual function void build_phase(uvm_phase phase);
    // extern virtual function void connect_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    extern task write_cycle(afifo_transaction tr);
    extern task read_cycle(afifo_transaction tr);

    `uvm_component_utils(afifo_driver)
endclass:afifo_driver

// build phase
function void afifo_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual afifo_if)::get(this,"","vif",vif))
        `uvm_fatal(get_full_name(), "vif connect error!")
    if(!uvm_config_db#(bit)::get(this,"","rnw",rnw))
        `uvm_fatal(get_full_name(), "rnw bit get error!")
endfunction:build_phase

// reset phase
task afifo_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    if(rnw) begin
        wait(vif.wreset_b == 'b0);
            `uvm_info(get_full_name(), "write reset phase start", UVM_MEDIUM);
            vif.write <= 'b0;
            vif.wdata <= 'b0;
        wait(vif.wreset_b == 'b1); // stuck in reset phase, untill deassert
            @(vif.wr_drv_cb);
            `uvm_info(get_full_name(), "write reset phase end", UVM_MEDIUM);
    end else begin
        wait(vif.rreset_b == 'b0);
            `uvm_info(get_full_name(), "read reset phase start", UVM_MEDIUM);
            vif.read <= 'b0;
        wait(vif.rreset_b == 'b1); // stuck in reset phase, untill deassert
            @(vif.rd_drv_cb);
            `uvm_info(get_full_name(), "read reset phase end", UVM_MEDIUM);
    end
    phase.drop_objection(this);
endtask:reset_phase

// main phase, behavior of driver
task afifo_driver::main_phase(uvm_phase phase);
    //super.main_phase(phase);
    //int driven_cnt;
    if(!rnw) fork
        forever begin
            seq_item_port.get_next_item(req);
            write_cycle(req);
            seq_item_port.item_done();
        end
        begin
            @(negedge vif.wreset_b);
            // phase.jump(uvm_reset_phase::get());
            wrst_assert = 1;
            `uvm_info(get_full_name(), "write reset asserted", UVM_MEDIUM);
        end
        forever begin
            @(posedge vif.wreset_b)
            wrst_assert = 0;
            `uvm_info(get_full_name(), "write reset deasserted", UVM_MEDIUM);
        end
    join
    else fork
        forever begin
            seq_item_port.get_next_item(req);
            read_cycle(req);
            seq_item_port.item_done();
        end
        begin
            @(negedge vif.rreset_b);
            // phase.jump(uvm_reset_phase::get());
            rrst_assert = 1;
            `uvm_info(get_full_name(), "read reset asserted", UVM_MEDIUM);
        end
        forever begin
            @(posedge vif.rreset_b)
            rrst_assert = 0;
            `uvm_info(get_full_name(), "read reset deasserted", UVM_MEDIUM);
        end
    join
endtask:main_phase

// write cycle(s)
task afifo_driver::write_cycle(afifo_transaction tr);
    int cycles;
    cycles = tr.cycle_num;
    if(wrst_assert || tr.idle) begin
        for ( int i = 0; i < cycles; i++ ) begin
            @(vif.wr_drv_cb);
            vif.wr_drv_cb.write <= 'b0;
        end
    end else if(!tr.rnw) begin
        assert(tr.data_q.size==tr.cycle_num);
        for ( int i = 0; i < cycles; i++ ) begin
            @(vif.wr_drv_cb);
            vif.wr_drv_cb.write <= 'b1;
            vif.wr_drv_cb.wdata <= tr.data_q[i];
            driven_cnt++;
            `uvm_info(get_full_name(), $sformatf("%d-th write_transaction [%h] is driven", driven_cnt, tr.data_q[i]), UVM_MEDIUM);
        end
        @(vif.wr_drv_cb);
        vif.wr_drv_cb.write <= 'b0;
    end else begin
        `uvm_info(get_full_name(), "get read_transaction in write_agent, check your sequence!", UVM_LOW);
    end
endtask:write_cycle

// read cycle(s)
task afifo_driver::read_cycle(afifo_transaction tr);
    int cycles;
    assert(tr.data_q.size==0);
    cycles = tr.cycle_num;
    if(rrst_assert || tr.idle) begin
        for ( int i = 0; i < cycles; i++ ) begin
            @(vif.rd_drv_cb);
            vif.rd_drv_cb.read <= 'b0;
        end
    end else if(tr.rnw) begin
        for ( int i = 0; i < cycles; i++ ) begin
            @(vif.rd_drv_cb);
            vif.rd_drv_cb.read <= 'b1;
            driven_cnt++;
            `uvm_info(get_full_name(), $sformatf("%d-th read_transaction is driven", driven_cnt), UVM_MEDIUM);
        end
        @(vif.rd_drv_cb);
        vif.rd_drv_cb.read <= 'b0;
    end else begin
        `uvm_info(get_full_name(), "get write_transaction in read_agent, check your sequence!", UVM_LOW);
    end
    //@(vif.rd_drv_cb iff !vif.rd_drv_cb.empty) // utill can be read
endtask:read_cycle

`endif // AFIFO_DRIVER__SV
