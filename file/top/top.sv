//`timescale 1ns/1ps
`include "uvm_macros.svh"

import uvm_pkg::*;

module top;


int wclk_period = `WCTP;
int rclk_period = `RCTP;

reg   wclk     = 0 ;
reg   rclk     = 0 ;
reg   wreset_b = 0 ;
reg   rreset_b = 0 ;

afifo_if top_if(wclk, rclk, wreset_b, rreset_b);

afifo #(
    .DEPTH ( `DEPTH ),
    .WIDTH ( `WIDTH ),
    .ADDR  ( `ADDR  )
) u_afifo (
    .write                   ( top_if.write     ),
    .wreset_b                ( top_if.wreset_b  ),
    .wclk                    ( top_if.wclk      ),
    .read                    ( top_if.read      ),
    .rreset_b                ( top_if.rreset_b  ),
    .rclk                    ( top_if.rclk      ),
    .wdata                   ( top_if.wdata     ),

    .rdata                   ( top_if.rdata     ),
    .rempty                  ( top_if.rempty    ),
    .wfull                   ( top_if.wfull     )
);

initial fork
    $display("WCTP=%d, RCTP=%d, wclk_period=%d, rclk_period=%d", `WCTP, `RCTP, wclk_period, rclk_period);
    begin
        `uvm_info("uvm_top", $sformatf("initial read clk period = %0d", rclk_period), UVM_LOW);
        forever #(rclk_period/2)  rclk=~rclk;
    end
    begin
        `uvm_info("uvm_top", $sformatf("initial write clk period = %0d", wclk_period), UVM_LOW);
        forever #(wclk_period/2)  wclk=~wclk;
    end
join_none

initial begin
    #10;
    fork
        wreset_b = 1 ;
        rreset_b = 1 ;
    join
    `uvm_info("uvm_top", $sformatf("deassert restn"), UVM_LOW);
end

initial begin
    run_test();
end

initial fork
    forever begin
        //uvm_config_db#(bit)::wait_modified(null, "", "wclk_period"); // int but not bit!
        uvm_config_db#(int)::wait_modified(null, "uvm_test_top", "wclk_period");
        if(!uvm_config_db#(int)::get(null, "uvm_test_top", "wclk_period", wclk_period))
            `uvm_fatal("uvm_top", "get wclk_period from sequence error!")
        `uvm_info("uvm_top", $sformatf("configure write clk period = %0d", wclk_period), UVM_LOW);
    end
    forever begin
        uvm_config_db#(int)::wait_modified(null, "uvm_test_top", "rclk_period");
        if(!uvm_config_db#(int)::get(null, "uvm_test_top", "rclk_period", rclk_period))
            `uvm_fatal("uvm_top", "get rclk_period from sequence error!")
        `uvm_info("uvm_top", $sformatf("configure read clk period = %0d", rclk_period), UVM_LOW);
    end
join_none

initial fork
    forever begin
        uvm_config_db#(bit)::wait_modified(null, "uvm_test_top", "wreset_b");
        if(!uvm_config_db#(bit)::get(null, "uvm_test_top", "wreset_b", wreset_b))
            `uvm_fatal("uvm_top", "get wreset_b from sequence error!")
    end
    forever begin
        uvm_config_db#(bit)::wait_modified(null, "uvm_test_top", "rreset_b");
        if(!uvm_config_db#(bit)::get(null, "uvm_test_top", "rreset_b", rreset_b))
            `uvm_fatal("uvm_top", "get rreset_b from sequence error!")
    end
join_none

initial begin
    uvm_config_db#(virtual afifo_if)::set(null, "uvm_test_top", "wr_agent_vif", top_if);
    uvm_config_db#(virtual afifo_if)::set(null, "uvm_test_top", "rd_agent_vif", top_if);
end



endmodule
