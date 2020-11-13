`timescale 1ns/1ns

module system_tb();
	reg clk;
	wire done;
	wire [159:0] result;
	
	system uut(
		.clk (clk),
		.done (done),
		.result (result)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 0;
		#10;
		while (~done)
			#10;
		#10 $stop;
	end 
endmodule 