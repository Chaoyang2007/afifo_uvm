`ifndef AFIFO_RD_FAST_TEST__SV
`define AFIFO_RD_FAST_TEST__SV

class afifo_rd_fast_test extends afifo_base_test;

    function new(string name="afifo_rd_fast_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    `uvm_component_utils(afifo_rd_fast_test)
endclass:afifo_rd_fast_test

// start directlly
function void afifo_rd_fast_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this,
                                            "vsqr.main_phase",
                                            "default_sequence",
                                            afifo_rd_fast_vseq::type_id::get());
endfunction:build_phase

// instantiated and start
/* function void afifo_rd_fast_test::build_phase(uvm_phase phase);
    afifo_rd_fast_vseq cvseq;
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this,
                                            "vsqr.main_phase",
                                            "default_sequence",
                                            cvseq);
endfunction:build_phase */

`endif // AFIFO_RD_FAST_TEST__SV
