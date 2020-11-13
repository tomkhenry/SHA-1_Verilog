module system(
	input clk,
	output done,
	output [159:0]	result
);

	// Wires for reading/writing to RAM
	wire [31:0] din;
	wire [6:0] 	raddr;
	wire [6:0] 	waddr;
	wire we;
	wire [31:0] dout;
	
	
	// Enable/select bits for HLSM
	wire en_update_hash;
	wire s_update_hash;
	wire en_j;
	wire s_j;
	wire en_l;
	wire s_l;
	wire en_read_l;
	wire en_reassign;
	wire s_reassign;
	wire en_temp;
	wire s_temp;
	wire en_done;
	wire s_done;
	wire en_fk;
	wire [2:0] s_fk;
	wire en_fill_chunks;
	wire en_read_1;
	wire en_read_2;
	wire en_read_3;
	wire en_read_4;
	wire en_fill_1;
	wire en_fill_2;
	wire en_fill_3;
	wire en_fill_4;
	
	// Wires for conditions
	wire i_gt_addr;
	wire j_lt_chunks;
	wire l_lt_choose;
	wire l_lt_parity_one;
	wire l_lt_major;
	wire l_lt_parity_two;
	wire start_en;
	
	assign start_en = 1'b1;
	

	datapath SHA1_datapath(
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
	
	controller SHA1_controller(
		.clk (clk),
		.reset (1'b0),
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
	

	ram sha_data(
		.clk (clk),
		.din (din),
		.raddr (raddr),
		.waddr (waddr),
		.we (we),
		.dout (dout)
	);


endmodule 