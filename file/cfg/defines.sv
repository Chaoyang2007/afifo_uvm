
`define D #0.2ns // unblocking delay
`define DEPTH 32 // fifo depth
`define WIDTH 32 // data width
`define ADDR $clog2(`DEPTH) // addr width
`define WCTP 10 // write clk time parameter, clock period
`define RCTP 10 // read clk time parameter, clock period
`define CFACTOR 1 // times difference

typedef int unsigned    uint;
typedef bit[`WIDTH-1:0] busdata_t;
