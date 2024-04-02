`ifndef AFIFO_WR_RD_TEST__SV
`define AFIFO_WR_RD_TEST__SV

class afifo_wr_rd_test extends afifo_base_test;

    function new(string name="afifo_wr_rd_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    // extern virtual function void build_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    `uvm_component_utils(afifo_wr_rd_test)
endclass:afifo_wr_rd_test

task afifo_wr_rd_test::main_phase(uvm_phase phase);
    // super.main_phase(phase);
    afifo_wr_rd_vseq case0_vseq;
    case0_vseq = afifo_wr_rd_vseq::type_id::create("case0_vseq");
    phase.raise_objection(this);
    case0_vseq.starting_phase = phase;
    case0_vseq.start(this.vsqr);
    phase.drop_objection(this);
endtask:main_phase

// start directlly
/* function void afifo_wr_rd_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this,
                                            "vsqr.main_phase",
                                            "default_sequence",
                                            afifo_wr_rd_vseq::type_id::get());
endfunction:build_phase */

// instantiated and start
/* function void afifo_wr_rd_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    afifo_wr_rd_vseq case0_vseq;
    case0_vseq = new("case0_vseq");
    uvm_config_db#(uvm_object_wrapper)::set(this,
                                            "vsqr.main_phase",
                                            "default_sequence",
                                            case0_vseq);
endfunction:build_phase */
`endif // AFIFO_WR_RD_TEST__SV
