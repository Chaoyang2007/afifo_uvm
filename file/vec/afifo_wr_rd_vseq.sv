`ifndef AFIFO_WR_RD_VSEQ__SV
`define AFIFO_WR_RD_VSEQ__SV

class afifo_wr_rd_vseq extends afifo_base_vseq; // uvm_sequence #(afifo_transaction);//
    `uvm_object_utils(afifo_wr_rd_vseq)

    function new(string name="afifo_wr_rd_vseq");
        super.new(name);
    endfunction

    virtual task body();
        afifo_basic_vec_vseq basic_vec;
        assert(starting_phase != null);
        if(starting_phase != null)
            starting_phase.raise_objection(this);

        $display($time, " sequence \"afifo_wr_rd_vseq\" start (with same clk)");
        #100
        `uvm_do(basic_vec)
        #100
        $display($time, " sequence \"afifo_wr_rd_vseq\" end (with same clk)");

        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask:body
endclass:afifo_wr_rd_vseq

`endif // AFIFO_WR_RD_VSEQ__SV