`timescale 1ns/1ns
module ram_tb();
	reg clk;
	reg [31:0] din;
	reg [6:0] raddr;
	reg [6:0] waddr;
	reg we;
	wire [31:0] dout;

	ram uut(
		.clk (clk),
		.din (din),
		.raddr (raddr),
		.waddr (waddr),
		.we (we),
		.dout (dout)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 0; we = 0; din = 0; waddr = 0; raddr = 7'b0;
		#10
		raddr = 1;
		#10
		raddr = 2;
		#10
		raddr = 3;
		#10
		raddr = 4;
		#10
		raddr = 5;
		#10
		raddr = 6;
		#10
		raddr = 7;
		#10
		raddr = 8;
		#10
		raddr = 9;
		#10
		raddr = 10;
		#10
		raddr = 11;		
		#10 $stop;
	end
	
endmodule 