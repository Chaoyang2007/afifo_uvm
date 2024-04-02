`ifndef AFIFO_BASIC_VEC_VSEQ__SV
`define AFIFO_BASIC_VEC_VSEQ__SV

class afifo_basic_vec_vseq extends afifo_base_vseq; // uvm_sequence #(afifo_transaction);//
    `uvm_object_utils(afifo_basic_vec_vseq)

    function new(string name="afifo_basic_vec_vseq");
        super.new(name);
    endfunction

    virtual task body();
        afifo_read_cycle_seq  read_seq;
        afifo_write_cycle_seq write_seq;
        afifo_idle_cycle_seq  nop_seq;
        afifo_read_rstn_seq   rrstn_seq;
        afifo_write_rstn_seq  wrstn_seq;
        assert(starting_phase != null);
        if(starting_phase != null)
            starting_phase.raise_objection(this);

        $display($time, " sequence \"afifo_basic_vec_vseq\" start (with same clk)");
        #100
        // 1. read empty, check rempty
        $display($time, " 1. read empty, check rempty");
        `uvm_do_on_with(read_seq, p_sequencer.rd_sqr, {burst_len==6;})
        #100
        // 2. write DEPTH times, check wfull
        $display($time, " 2. write DEPTH times, check wfull");
        `uvm_do_on_with(write_seq, p_sequencer.wr_sqr, {burst_len==`DEPTH;})
        #100
        // 3. read DEPTH times, check rempty
        $display($time, " 3. read DEPTH times, check rempty");
        `uvm_do_on_with(read_seq, p_sequencer.rd_sqr, {burst_len==`DEPTH;})
        #100
        // 4. write over-full and read over-empty
        $display($time, " 4. write over-full and read over-empty");
        `uvm_do_on_with(write_seq, p_sequencer.wr_sqr, {burst_len==`DEPTH+12;})
        `uvm_do_on_with(read_seq, p_sequencer.rd_sqr, {burst_len==`DEPTH+12;})
        #100
        // 5. write and read simutaneously
        $display($time, " 5. write and read simutaneously");
        `uvm_do_on_with(write_seq, p_sequencer.wr_sqr, {burst_len==1;})
        `uvm_do_on_with(nop_seq, p_sequencer.rd_sqr, {burst_len==2;})
        fork
            `uvm_do_on_with(write_seq, p_sequencer.wr_sqr, {burst_len==`DEPTH*2-1;})
            `uvm_do_on_with(read_seq, p_sequencer.rd_sqr, {burst_len==`DEPTH*2;})
        join
        #100
        // 6. write and read reset
        $display($time, " 6. write and read reset");
        fork
            `uvm_do_on(wrstn_seq, p_sequencer.wr_sqr)
            `uvm_do_on(rrstn_seq, p_sequencer.rd_sqr)
        join
        #100
        // 7. reset while writing
        $display($time, " 7. reset while writing");
        fork
            `uvm_do_on_with(write_seq, p_sequencer.wr_sqr, {burst_len==`DEPTH*2;})
            begin
                #(`WCTP*`DEPTH/3)
                `uvm_do_on_with(wrstn_seq, p_sequencer.wr_sqr, {deassert==0; auto_deassert==0;})
                #(`WCTP*`DEPTH/3)
                `uvm_do_on_with(wrstn_seq, p_sequencer.wr_sqr, {deassert==1; auto_deassert==0;})
            end
        join
        `uvm_do_on(nop_seq  , p_sequencer.wr_sqr)
        `uvm_do_on(wrstn_seq, p_sequencer.wr_sqr)
        #100
        // 8. write full then read empty
        $display($time, " 8. write full then read empty");
        `uvm_do_on_with(write_seq, p_sequencer.wr_sqr, {burst_len==`DEPTH;})
        `uvm_do_on_with(read_seq, p_sequencer.rd_sqr, {burst_len==`DEPTH;})
        #100

        $display($time, " sequence \"afifo_basic_vec_vseq\" end (with same clk)");
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask:body
endclass:afifo_basic_vec_vseq

`endif // AFIFO_BASIC_VEC_VSEQ__SV