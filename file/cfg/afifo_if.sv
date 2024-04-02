`ifndef AFIFO_IF__SV
`define AFIFO_IF__SV

interface afifo_if(input wclk, rclk, wreset_b, rreset_b);

   logic              write;
   //logic              wreset_b;
   //logic              wclk;
   logic [`WIDTH-1:0] wdata;

   logic              read;
   //logic              rreset_b;
   //logic              rclk;
   logic [`WIDTH-1:0] rdata;

   logic              rempty;
   logic              wfull;

   clocking wr_drv_cb @(posedge wclk);
      default input `D output `D;
      output  write;
      output  wdata;
      input   wfull;
   endclocking

   clocking wr_mon_cb @(posedge wclk);
      default input `D output `D;
      input   write;
      input   wdata;
      input   wfull;
   endclocking

   clocking rd_drv_cb @(posedge rclk);
      default input `D output `D;
      output  read;
      output  rdata;
      input   rempty;
   endclocking

   clocking rd_mon_cb @(posedge rclk);
      default input `D output `D;
      input   read;
      input   rdata;
      input   rempty;
   endclocking

endinterface:afifo_if

`endif // AFIFO_IF__SV
