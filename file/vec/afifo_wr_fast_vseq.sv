`ifndef AFIFO_WR_FAST_VSEQ__SV
`define AFIFO_WR_FAST_VSEQ__SV

class afifo_wr_fast_vseq extends afifo_base_vseq;
    `uvm_object_utils(afifo_wr_fast_vseq)

    function new(string name="afifo_wr_fast_vseq");
        super.new(name);
    endfunction

    virtual task body();
        afifo_read_rstn_seq   rrstn_seq;
        afifo_write_rstn_seq  wrstn_seq;
        afifo_read_freq_seq   rclk_seq;
        afifo_write_freq_seq  wclk_seq;
        afifo_basic_vec_vseq  basic_vec;
        if(starting_phase != null) //start
            starting_phase.raise_objection(this);

        $display($time, " sequence \"afifo_wr_fast_vseq\" start");
        #100
        // 0. set clock period, wr/rd reset
        $display($time, " 0. set clock period, wr/rd reset");
        fork
            `uvm_do_on_with(wclk_seq, p_sequencer.wr_sqr, {clk_period==`WCTP;})
            `uvm_do_on_with(rclk_seq, p_sequencer.rd_sqr, {clk_period==`WCTP*`CFACTOR;})
            `uvm_do_on(wrstn_seq, p_sequencer.wr_sqr)
            `uvm_do_on(rrstn_seq, p_sequencer.rd_sqr)
        join
        #100
        `uvm_do(basic_vec)
        #100

        $display($time, " sequence \"afifo_wr_fast_vseq\" end");
        if(starting_phase != null) //end
            starting_phase.drop_objection(this);
    endtask:body
endclass:afifo_wr_fast_vseq

`endif // AFIFO_WR_FAST_VSEQ__SV