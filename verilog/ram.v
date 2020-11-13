module ram(
   input	clk,
   input [31:0] din,
	input [6:0] raddr,
   input [6:0] waddr,
   input we,
   output reg [31:0] dout
);
   reg [31:0] M [0:79];
   initial $readmemh("sha_data.mem", M);
	initial dout = 32'h0;
   
   always @(posedge clk) begin
      if (we)
         M[waddr] <= din;
      dout <= M[raddr];
   end
   
endmodule 