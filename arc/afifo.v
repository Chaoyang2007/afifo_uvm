module afifo #(
	DEPTH = 64,
	WIDTH = 64,
)( 
	input  wire wclk, 
	input  wire rclk, 
	input  wire wreset_b, 
	input  wire rreset_b, 
	input  wire write,
	input  wire read, 
	input  wire [WIDTH-1:0] wdata, 

	output wire [WIDTH-1:0] rdata, 
	output wire wfull, 
	output wire rempty
);
	
endmodule 