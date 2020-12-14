module control_unit(
	input logic Clk, 
	input logic Reset,
	input logic [7:0] score,
	input logic [7:0] keycode,
	input logic die,
	output logic start_on,
	output logic game_1_on,
	output logic transition_on,
	output logic game_2_on,
	output logic game_3_on,
	output logic win_on,
	output logic lose_on
);
	enum logic [3:0] {  
					start,
					game_1,
					game_2,
					game_3,
					transition,
					win,
					lose
						}   state, next_state;   // Internal state logic
	logic [1:0] level;
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
		begin
			state <= start;
			level = 2'b00;
		end
		else  
			state <= next_state;
		
		if(state == game_1)
			level = 2'b01;
		else if (state == game_2)
			level = 2'b10;
		else 
			level = 2'b00;
	end
	
	always_comb
	begin
		next_state = state;
		start_on = 1'b0;
	   	game_1_on  = 1'b0;
	   	game_2_on  = 1'b0;
		game_3_on = 1'b0;
	   	win_on   = 1'b0;
	   	lose_on  = 1'b0;
		transition_on = 1'b0;
		unique case(state)
			start:
			begin
				if(keycode == 8'h2c)
					next_state = game_1;
			end
			game_1:
			begin
				if(die == 1'b1)
					next_state  = lose;
				else if (score == 32'd10)
					next_state = transition;
			end
			transition:
			begin
				if(level == 2'b01)
					next_state = game_2;
				else if (level == 2'b10)
					next_state = game_3;
			end
			game_2:
			begin
				if(die == 1'b1)
					next_state  = lose;
				else if (score == 32'd10)
					next_state = transition;
			end
			game_3:
			begin
				if(die == 1'b1)
					next_state  = lose;
				else if (score == 32'd10)
					next_state = win;
			end
			win,lose:
			begin
				if(keycode == 8'h29)
					next_state = start;
			end
		endcase
		
		case(state)
			start:
				start_on = 1'b1;
			game_1:
				game_1_on = 1'b1;
			transition:
				transition_on = 1'b1;
			game_2:
				game_2_on = 1'b1;
			game_3:
				game_3_on = 1'b1;
			win:
				win_on = 1'b1;
			lose:
				lose_on = 1'b1;
		endcase
	end

endmodule