module datapath(
	input clk,
	input en_update_hash,
	input s_update_hash,
	input en_j,
	input s_j,
	input en_l,
	input s_l,
	input en_read_l,
	input en_reassign,
	input s_reassign,
	input en_temp,
	input s_temp,
	input en_done,
	input s_done,
	input en_fk,
	input [2:0] s_fk,
	input en_fill_chunks,
	input en_read_1,
	input en_read_2,
	input en_read_3,
	input en_read_4,
	input en_fill_1,
	input en_fill_2,
	input en_fill_3,
	input en_fill_4,
	input [31:0] dout,

	//Output Flags
	output j_lt_chunks,
	output l_lt_choose,
	output l_lt_parity_one,
	output l_lt_major,
	output l_lt_parity_two,
	
	//RAM Write
	output reg [6:0] raddr,
	output reg [6:0] waddr,
	output reg we,
	output reg [31:0] din,
	
	//Output register values
	output reg done,
	output reg [159:0] result

);
	
	parameter CHOOSE	 = 3'h1;
	parameter PARITY_1 = 3'h2;
	parameter PARITY_2 = 3'h3;
	parameter MAJOR	 = 3'h4;
	
	initial done = 1'b0;
	initial raddr = 32'h0;
	initial waddr = 32'h0;

	// Set initial register values
	// Initial hash values
	reg [31:0] H0 	 = 32'h67DE2A01;
	reg [31:0] H1 	 = 32'hBB03E28C;
	reg [31:0] H2 	 = 32'h011EF1DC;
	reg [31:0] H3 	 = 32'h9293E9E2;
	reg [31:0] H4 	 = 32'hCDEF23A9;

	// Memory address iterators
	reg [6:0] j 	 = 7'h16;
	reg [6:0] l     = 7'h0;
	
	// Store hash values after functions have been run
	reg [31:0] temp = 32'h0;
	reg [31:0] A 	 = 32'h67DE2A01;
	reg [31:0] B 	 = 32'hBB03E28C;
	reg [31:0] C 	 = 32'h011EF1DC;
	reg [31:0] D 	 = 32'h9293E9E2;
	reg [31:0] E 	 = 32'hCDEF23A9;
	reg [31:0] F	 = 32'h0;
	reg [31:0] K	 = 32'h0;
	
	// Registers to store chunks in order calculate more chunks
	reg [31:0] reg1 = 32'h0;
	reg [31:0] reg2 = 32'h0;
	reg [31:0] reg3 = 32'h0;
	reg [31:0] reg4 = 32'h0;


	// Updating the memory address iterators		
	always @(posedge clk)
		if(en_j)
			if(!s_j)
				j <= j + 1;
			else 
				j <= 16;
				
	always @(posedge clk)
		if(en_l)
			if(!s_l)
				l <= l + 1;
			else
				l <= 0;
	
	// Update the write enable
	always @(posedge clk) begin 
		if(en_fill_chunks) begin 
			we <= 1;
		end
		else if(en_read_1 | en_read_2 | en_read_3 | en_read_4) begin
			we <= 0;
		end
	end
	
		// Update the read address
	always @(posedge clk) begin 
		if(en_read_1) begin
			raddr <= j - 3;
		end
		else if(en_read_2) begin
			raddr <= j - 8;
		end
		else if(en_read_3) begin
			raddr <= j - 14;
		end
		else if(en_read_4) begin
			raddr <= j - 16;
		end
		else if (en_read_l) begin
			raddr <= l;
		end
	end
	
	// Update the write address
	always @(posedge clk) begin 
		if(en_fill_chunks) 
			waddr <= j;
	end

	// Update the input to memory
	always @(posedge clk) begin 
		if(en_fill_chunks) 
			din <= (((reg1 ^ reg2 ^ reg3 ^ reg4) << 1) | ((reg1 ^ reg2 ^ reg3 ^ reg4) >> 31));
	end
	  
			
	// Write to the reg vals for fill chunks
	always @(posedge clk)
		if(en_fill_1)
			reg1 <= dout;
	always @(posedge clk)
		if(en_fill_2)
			reg2 <= dout;
	always @(posedge clk)
		if(en_fill_3)
			reg3 <= dout;
	always @(posedge clk)
		if(en_fill_4)
			reg4 <= dout;
	
	// Decide which function to run based on the select fk flag
	always @(posedge clk)
		if(en_fk) begin
			case(s_fk)
				0: begin F <= 0; end
				CHOOSE: begin F <= (B & C) | ((~B) & D); end
				PARITY_1: begin F <= (B ^ C ^ D); end
				PARITY_2: begin F <= (B ^ C ^ D); end
				MAJOR: begin F <= (B & C) | (B & D) | (C & D); end
			endcase
		end
		
	always @(posedge clk)
		if(en_fk) begin
			case(s_fk)
				0: begin K <= 0; end
				CHOOSE: begin K <= 32'h5A827999; end
				PARITY_1: begin K <= 32'h6ED9EBA1; end
				PARITY_2: begin K <= 32'hCA62C1D6; end
				MAJOR: begin K <= 32'h8F1BBCDC; end
			endcase
		end
	
	// Update the temporary register
	always @(posedge clk)
		if(en_temp)
			if(!s_temp)
				temp <= ((A << 5) | (A >> 27)) + F + E + K + dout;
			else
				temp <= 64'h0;
	
	// Reassigning to registers A-E
	always @(posedge clk)
		if(en_reassign)
			if(!s_reassign) 
				A <= temp;
			else
				A <= 32'h67DE2A01;

	always @(posedge clk)
		if(en_reassign)
			if(!s_reassign) 
				B <= A;
			else
				B <= 32'hBB03E28C;

	always @(posedge clk)
		if(en_reassign)
			if(!s_reassign) 
				C <= ((B << 30) | (B >> 2));
			else
				C <= 32'h011EF1DC;

	always @(posedge clk)
		if(en_reassign)
			if(!s_reassign) 
				D <= C;
			else
				D <= 32'h9293E9E2;

	always @(posedge clk)
		if(en_reassign)
			if(!s_reassign) 
				E <= D;
			else
				E <= 32'hCDEF23A9;

				
	// Updating the hash values once the process is finished
	always @(posedge clk)
		if(en_update_hash)
			if(!s_update_hash)
				H0 <= H0 + A;
			else
				H0 <= 32'h67DE2A01;	
		
	always @(posedge clk)
		if(en_update_hash)
			if(!s_update_hash)
				H1 <= H1 + B;
			else
				H1 <= 32'hBB03E28C;
		
	always @(posedge clk)
		if(en_update_hash)
			if(!s_update_hash)
				H2 <= H2 + C;
			else
				H2 <= 32'h011EF1DC;
		
	always @(posedge clk)
		if(en_update_hash)
			if(!s_update_hash)
				H3 <= H3 + D;
			else
				H3 <= 32'h9293E9E2;	
		
	always @(posedge clk)
		if(en_update_hash) 
			if(!s_update_hash)
				H4 <= H4 + E;
			else
				H4 <= 32'hCDEF23A9;	
		
	// Create final result and set done flag to 1
	always @(posedge clk)
		if(en_done)
			if(!s_done)
				result <= (H0 << 128) | (H1 << 96) | (H2 << 64) | (H3 << 32) | H4;
			else
				result <= 160'h0;
			
	always @(posedge clk)
		if(en_done)
			if(!s_done)
				done <= 1;
			else
				done <= 0;	
	
		
	//Assign flag conditional values
	assign j_lt_chunks = (j < 80);
	assign l_lt_choose = (l < 20);
	assign l_lt_parity_one = (l < 40);
	assign l_lt_major = (l < 60);
	assign l_lt_parity_two = (l < 80);
	
	
endmodule 