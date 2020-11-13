`timescale 1ns/1ns

module datapath_tb();
	reg clk;
	reg en_update_hash;
	reg s_update_hash;
	reg en_j;
	reg s_j;
	reg en_l;
	reg s_l;
	reg en_read_l;
	reg en_reassign;
	reg s_reassign;
	reg en_temp;
	reg s_temp;
	reg en_done;
	reg s_done;
	reg en_fk;
	reg [2:0] s_fk;
	reg en_fill_chunks;
	reg en_read_1;
	reg en_read_2;
	reg en_read_3;
	reg en_read_4;
	reg en_fill_1;
	reg en_fill_2;
	reg en_fill_3;
	reg en_fill_4;
	reg [31:0] dout;
	wire j_lt_chunks;
	wire l_lt_choose;
	wire l_lt_parity_one;
	wire l_lt_major;
	wire l_lt_parity_two;
	wire [6:0] raddr;
	wire [6:0] waddr;
	wire we;
	wire [31:0] din;
	wire done;
	wire [159:0] result;

	datapath uut(
		.clk (clk),
		.en_update_hash (en_update_hash),
		.s_update_hash (s_update_hash),
		.en_j (en_j),
		.s_j (s_j),
		.en_l (en_l),
		.s_l (s_l),
		.en_read_l (en_read_l),
		.en_reassign (en_reassign),
		.s_reassign (s_reassign),
		.en_temp (en_temp),
		.s_temp (s_temp),
		.en_done (en_done),
		.s_done (s_done),
		.en_fk (en_fk),
		.s_fk (s_fk),
		.en_fill_chunks (en_fill_chunks),
		.en_read_1 (en_read_1),
		.en_read_2 (en_read_2),
		.en_read_3 (en_read_3),
		.en_read_4 (en_read_4),
		.en_fill_1 (en_fill_1),
		.en_fill_2 (en_fill_2),
		.en_fill_3 (en_fill_3),
		.en_fill_4 (en_fill_4),
		.dout (dout),
		.j_lt_chunks (j_lt_chunks),
		.l_lt_choose (l_lt_choose),
		.l_lt_parity_one (l_lt_parity_one),
		.l_lt_major (l_lt_major),
		.l_lt_parity_two (l_lt_parity_two),
		.raddr (raddr),
		.waddr (waddr),
		.we (we),
		.din (din),
		.done (done),
		.result (result)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 0;
		en_update_hash = 0;
		s_update_hash = 0;
		en_j = 0;
		s_j = 0;
		en_l = 0;
		s_l = 0;
		en_read_l = 0;
		en_reassign = 0;
		s_reassign = 0;
		en_temp = 0;
		s_temp = 0;
		en_done = 0;
		s_done = 0;
		en_fk = 0;
		s_fk = 0;
		en_fill_chunks = 0;
		en_read_1 = 0;
		en_read_2 = 0;
		en_read_3 = 0;
		en_read_4 = 0;
		en_fill_1 = 0;
		en_fill_2 = 0;
		en_fill_3 = 0;
		en_fill_4 = 0;
		dout = 0;
		
		#10 en_j = 1;
		#10 s_j = 1;
		#10 en_j = 0; s_j = 0; en_l = 1;
		#10 s_l = 1;
		#10 en_l = 0; s_l = 0; en_read_1 = 1;
		#10 en_read_2 = 0; en_read_2 = 1;
		#10 en_read_3 = 0; en_read_3 = 1;
		#10 en_read_4 = 0; en_read_4 = 1;
		#10 en_l = 0; s_l = 0; en_fill_1 = 1; dout = 1;
		#10 en_fill_1 = 0; en_fill_2 = 1; dout = 2;
		#10 en_fill_2 = 0; en_fill_3 = 1; dout = 3;
		#10 en_fill_3 = 0; en_fill_4 = 1; dout = 4;
		#10 en_fill_4 = 0; en_fill_chunks = 1;
		#10 en_fill_chunks = 0; en_fk = 1;
		#10 s_fk = 1;
		#10 s_fk = 2;
		#10 s_fk = 3;
		#10 s_fk = 4;
		#10 en_fk = 0; s_fk = 0; en_temp = 1; dout = 5;
		#10 s_temp = 1;
		#10 en_temp = 0; s_temp = 0; en_reassign = 1;
		#10 s_reassign = 1;
		#10 en_reassign = 0; s_reassign = 0; en_update_hash = 1;
		#10 s_update_hash = 1;
		#10 en_update_hash = 0; s_update_hash = 0;
		#10 en_done = 1;
		#10 s_done = 1;
		#10 en_done = 0; s_done = 0;
		#10 $stop;
		
	end
	
endmodule 