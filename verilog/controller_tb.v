`timescale 1ns/1ns

module controller_tb();
	reg clk;
	reg reset;
	reg start_en;
	reg j_lt_chunks;
	reg l_lt_choose;
	reg l_lt_parity_one;
	reg l_lt_major;
	reg l_lt_parity_two;
	wire en_update_hash;
	wire en_j;
	wire en_l;
	wire en_read_l;
	wire en_reassign;
	wire en_temp;
	wire en_done;
	wire en_fk;
	wire en_fill_chunks;
	wire en_fill_1;
	wire en_fill_2;
	wire en_fill_3;
	wire en_fill_4;
	wire en_read_1;
	wire en_read_2;
	wire en_read_3;
	wire en_read_4;
	wire s_update_hash;
	wire s_j;
	wire s_l;
	wire s_reassign;
	wire s_temp;
	wire s_done;
	wire [2:0] s_fk;

	controller uut(
		.clk (clk),
		.reset (reset),
		.start_en (start_en),
		.j_lt_chunks (j_lt_chunks),
		.l_lt_choose (l_lt_choose),
		.l_lt_parity_one (l_lt_parity_one),
		.l_lt_major (l_lt_major),
		.l_lt_parity_two (l_lt_parity_two),
		.en_update_hash (en_update_hash),
		.en_j (en_j),
		.en_l (en_l),
		.en_read_l (en_read_l),
		.en_reassign (en_reassign),
		.en_temp (en_temp),
		.en_done (en_done),
		.en_fk (en_fk),
		.en_fill_chunks (en_fill_chunks),
		.en_fill_1 (en_fill_1),
		.en_fill_2 (en_fill_2),
		.en_fill_3 (en_fill_3),
		.en_fill_4 (en_fill_4),
		.en_read_1 (en_read_1),
		.en_read_2 (en_read_2),
		.en_read_3 (en_read_3),
		.en_read_4 (en_read_4),
		.s_update_hash (s_update_hash),
		.s_j (s_j),
		.s_l (s_l),
		.s_reassign (s_reassign),
		.s_temp (s_temp),
		.s_done (s_done),
		.s_fk (s_fk)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 0; reset = 1; start_en = 0;
		l_lt_choose = 0; l_lt_parity_one = 0; l_lt_major = 0; l_lt_parity_two = 0;
		#10
		reset = 0; start_en = 1;
		while (!en_j)
			#10
		j_lt_chunks = 1;
		#100
		j_lt_chunks = 0;
		l_lt_choose = 1;
		#40
		l_lt_choose = 0;
		l_lt_parity_one = 1;
		#40
		l_lt_parity_one = 0;
		l_lt_major = 1;
		#40
		l_lt_major = 0;
		l_lt_parity_two = 1;
		#40
		l_lt_parity_two = 0;
		#40
		while (!en_done)
			#10
		#10 $stop;
	end
	
endmodule
	