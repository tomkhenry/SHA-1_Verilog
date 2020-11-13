module controller(
	input clk,
	input reset,
	input start_en,
	input j_lt_chunks,
	input l_lt_choose,
	input l_lt_parity_one,
	input l_lt_major,
	input l_lt_parity_two,
	output reg en_update_hash,
	output reg en_j,
	output reg en_l,
	output reg en_read_l,
	output reg en_reassign,
	output reg en_temp,
	output reg en_done,
	output reg en_fk,
	output reg en_fill_chunks,
	output reg en_fill_1,
	output reg en_fill_2,
	output reg en_fill_3,
	output reg en_fill_4,
	output reg en_read_1,
	output reg en_read_2,
	output reg en_read_3,
	output reg en_read_4,
	output reg s_update_hash,
	output reg s_j,
	output reg s_l,
	output reg s_reassign,
	output reg s_temp,
	output reg s_done,
	output reg [2:0] s_fk
	);
	
	parameter INIT = 5'd0;
	parameter READ_REG_1 = 5'd1;
	parameter WAIT_1 = 5'd2;
	parameter FILL_REG_1 = 5'd3;
	parameter READ_REG_2 = 5'd4;
	parameter WAIT_2 = 5'd5;
	parameter FILL_REG_2 = 5'd6;
	parameter READ_REG_3 = 5'd7;
	parameter WAIT_3 = 5'd8;
	parameter FILL_REG_3 = 5'd9;
	parameter READ_REG_4 = 5'd10;
	parameter WAIT_4 = 5'd11;
	parameter FILL_REG_4 = 5'd12;
	parameter FILL_CHUNKS_MAIN = 5'd13;
	parameter CHUNK_ITERATOR = 5'd14;
	parameter READ_L_ADDR = 5'd15;
	parameter WAIT_L = 5'd16;
	parameter FUNC_SELECTOR = 5'd17;
	parameter CHOOSE = 5'd18;
	parameter PARITY_1 = 5'd19;
	parameter MAJOR = 5'd20;
	parameter PARITY_2 = 5'd21;
	parameter UPDATE_TEMP = 5'd22;
	parameter REASSIGN_FIRST = 5'd23;
	parameter FUNC_ITERATOR = 5'd24;
	parameter UPDATE_HASH = 5'd25;
	parameter DONE = 5'd26;
	
	reg [4:0] state, next_state;
	initial state = INIT;
	initial next_state = INIT;
	
	always @(posedge clk)
		if (reset)
			state <= INIT;
		else
			state <= next_state;
	
	always @(*) begin
		// Initially set all enables/selects to 0
		en_update_hash = 0;
		en_j = 0;
		en_l = 0;
		en_read_l = 0;
		en_reassign = 0;
		en_temp = 0;
		en_done = 0;
		en_fk = 0;
		en_fill_chunks = 0;
		en_fill_1 = 0;
		en_fill_2 = 0;
		en_fill_3 = 0;
		en_fill_4 = 0;
		en_read_1 = 0;
		en_read_2 = 0;
		en_read_3 = 0;
		en_read_4 = 0;
		s_update_hash = 0;
		s_j = 0;
		s_l = 0;
		s_reassign = 0;
		s_temp = 0;
		s_done = 0;
		s_fk = 3'd0;
		case (state)
			INIT: begin
				en_update_hash = 1;
				en_j = 1;
				en_l = 1;
				en_reassign = 1;
				en_temp = 1;
				en_done = 1;
				en_fk = 1;
				s_update_hash = 1;
				s_j = 1;
				s_l = 1;
				s_reassign = 1;
				s_temp = 1;
				s_done = 1;
				// Check if process should be started
				if (start_en)
					next_state = READ_REG_1;
				else
					next_state = INIT;
			end
			
			// States for grabbing from memory the words needed to create chunks
			// WAIT states give time to read from memory
			READ_REG_1: begin
				en_read_1 = 1;
				next_state = WAIT_1;
			end

			WAIT_1: begin
				next_state = FILL_REG_1;
			end
			FILL_REG_1: begin
				en_fill_1 = 1;
				next_state = READ_REG_2;
			end
			READ_REG_2: begin
				en_read_2 = 1;
				next_state = WAIT_2;
			end
			WAIT_2: begin
				next_state = FILL_REG_2;
			end
			FILL_REG_2: begin
				en_fill_2 = 1;
				next_state = READ_REG_3;
			end
			READ_REG_3: begin
				en_read_3 = 1;
				next_state = WAIT_3;
			end
			WAIT_3: begin
				next_state = FILL_REG_3;
			end
			FILL_REG_3: begin
				en_fill_3 = 1;
				next_state = READ_REG_4;
			end
			READ_REG_4: begin
				en_read_4 = 1;
				next_state = WAIT_4;
			end
			WAIT_4: begin
				next_state = FILL_REG_4;
			end
			FILL_REG_4: begin
				en_fill_4 = 1;
				next_state = FILL_CHUNKS_MAIN;
			end
			
			// State to write into memory
			FILL_CHUNKS_MAIN: begin
				en_fill_chunks = 1;
				if (j_lt_chunks)
					next_state = CHUNK_ITERATOR;
				else
					next_state = READ_L_ADDR;
			end

			// State to iterate address to continue through the memory
			CHUNK_ITERATOR: begin
				en_j = 1;
				next_state = READ_REG_1;
			end
			
			// State for reading through memory again to process chunks 
			READ_L_ADDR: begin
				en_read_l = 1;
				next_state = WAIT_L;
			end
			// Allows time to read value from memory
			WAIT_L: begin
				next_state = FUNC_SELECTOR;	
			end
			
			// Decide which of the four computations to do
			FUNC_SELECTOR: begin
				if (l_lt_choose)
					next_state = CHOOSE;
				else if (l_lt_parity_one)
					next_state = PARITY_1;
				else if (l_lt_major)
					next_state = MAJOR;
				else if (l_lt_parity_two)
					next_state = PARITY_2;
				else
					next_state = UPDATE_HASH;
			end
			
			// States for four different computations depending on the address value
			CHOOSE: begin
				en_fk = 1;
				s_fk = 3'd1;
				next_state = UPDATE_TEMP;
			end
			PARITY_1: begin
				en_fk = 1;
				s_fk = 3'd2;
				next_state = UPDATE_TEMP;
			end
			MAJOR: begin
				en_fk = 1;
				s_fk = 3'd4;
				next_state = UPDATE_TEMP;
			end
			PARITY_2: begin
				en_fk = 1;
				s_fk = 3'd3;
				next_state = UPDATE_TEMP;
			end
			// Create temp register each loop and reassign to A-E registers
			UPDATE_TEMP: begin
				en_temp = 1;
				next_state = REASSIGN_FIRST;
			end
			REASSIGN_FIRST: begin
				en_reassign = 1;
				next_state = FUNC_ITERATOR;
			end
			
			// Iterate the memory address
			FUNC_ITERATOR: begin
				en_l = 1;
				next_state = READ_L_ADDR;
			end
			
			// Update hash values that will create the result
			UPDATE_HASH: begin
				en_update_hash = 1;
				next_state = DONE;
			end
			
			// Finish hasing process
			DONE: begin
				en_done = 1;
				next_state = DONE;
			end
			default: ;
		endcase
	end
	
endmodule
