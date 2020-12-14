module dot_map(
		input  logic frame_clk,Reset,game_reset,
		input  [9:0] dx,
		input  [9:0] dy,
		input  [9:0] px,
		input  [9:0] py,
		output [7:0] score,
		output dot_on,
		output dot_test
);

	reg [11:0] dot_map[11:0];
	logic [11:0] row;
	logic temp_dot;
	logic [4:0] x_index, y_index, px_index, py_index, temp_y;
	logic [7:0]c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11;
	// logic [11:0] temp_row, temp_col;
	assign x_index = dx[9:5];
	assign y_index = dy[9:5];
	assign px_index = px[9:5];
	assign py_index = py[9:5];
	initial 
	begin
		for(int i=0; i<12; i++) 
		begin
			if(i == 4 || i == 7)
				dot_map[i] = 12'h1f8;
			// else if (i == 1)
			// 	dot_map[i] = 12'h56a;
			else if (i == 5)
				dot_map[i] = 12'h79e;
			else if (i == 6)
				dot_map[i] = 12'h198;
			else	
				dot_map[i] = 12'h3fe;
		end
	end

	check_count_row d0(.row(dot_map[11]), .count(c11));
	check_count_row d1(.row(dot_map[10]), .count(c10));
	check_count_row d2(.row(dot_map[9]), .count(c9));
	check_count_row d3(.row(dot_map[8]), .count(c8));
	check_count_row d4(.row(dot_map[7]), .count(c7));
	check_count_row d5(.row(dot_map[6]), .count(c6));
	check_count_row d6(.row(dot_map[5]), .count(c5));
	check_count_row d7(.row(dot_map[4]), .count(c4));
	check_count_row d8(.row(dot_map[3]), .count(c3));
	check_count_row d9(.row(dot_map[2]), .count(c2));
	check_count_row d10(.row(dot_map[1]), .count(c1));
	check_count_row d11(.row(dot_map[0]), .count(c0));
	assign score = c0+c1+c2+c3+c4+c5+c6+c7+c8+c9+c10+c11-8'd40;
	always_comb
	begin
		// dot_temp = 1'b0
		row = 12'h000;
		dot_on = 1'b0;
		if(dx < 416 && dy <= 400 && dx % 32 == 0 && dy % 32 == 0 && dx > 16 && dy > 16)
		begin
			row = dot_map[y_index-1];
			case(x_index)
				5'h1:
					dot_on = row[11];
				5'h2:
					dot_on = row[10];
				5'h3:
					dot_on = row[9];
				5'h4:
					dot_on = row[8];
				5'h5:
					dot_on = row[7];
				5'h6:
					dot_on = row[6];
				5'h7:
					dot_on = row[5];
				5'h8:
					dot_on = row[4];
				5'h9:
					dot_on = row[3];
				5'ha:
					dot_on = row[2];
				5'hb:
					dot_on = row[1];
				5'hc:
					dot_on = row[0];
				default: ;
			endcase
		end
		else
		begin
			dot_on = 1'b0;
		end
		end



		always_ff @ (posedge Reset or posedge frame_clk or posedge game_reset)
		begin
			if(Reset || game_reset)
			begin
				// score <= 8'h00;
				for(int i=0; i<12; i++) 
				begin
					if(i == 4 || i == 7)
						dot_map[i] = 12'h1f8;
					else if (i == 5)
						dot_map[i] = 12'h79e;
					else if (i == 6)
						dot_map[i] = 12'h198;
					else	
						dot_map[i] = 12'h7fe;
				end
			end
			else
			begin
				dot_test = 1'b1;
				
				case(py_index-1)
					5'h0:
					begin
						dot_map[0] <= dot_map[0] & ~(12'b100000000000 >> (px_index-1));
					end
					5'h1:
					begin
						dot_map[1] <= dot_map[1] & ~(12'b100000000000 >> (px_index-1));
					end
					5'h2:
					begin
						dot_map[2] <= dot_map[2] & ~(12'b100000000000 >> (px_index-1));
					end
					5'h3:
					begin
						dot_map[3] <= dot_map[3] & ~(12'b100000000000 >> (px_index-1));
					end
					5'h4:
					begin
						dot_map[4] <= dot_map[4] & ~(12'b100000000000 >> (px_index-1));
					end
					5'h5:
					begin
						dot_map[5] <= dot_map[5] & ~(12'b100000000000 >> (px_index-1));
					end
					5'h6:
					begin
						dot_map[6] <= dot_map[6] & ~(12'b100000000000 >> (px_index-1));
					end
					5'h7:
					begin
						dot_map[7] <= dot_map[7] & ~(12'b100000000000 >> (px_index-1));
					end
					5'h8:
					begin
						dot_map[8] <= dot_map[8] & ~(12'b100000000000 >> (px_index-1));	
					end
					5'h9:
					begin
						dot_map[9] <= dot_map[9] & ~(12'b100000000000 >> (px_index-1));
					end
					5'ha:
					begin
						dot_map[10] <= dot_map[10] & ~(12'b100000000000 >> (px_index-1));
					end
					5'hb:
					begin
						dot_map[11] <= dot_map[11] & ~(12'b100000000000 >> (px_index-1));	
					end
					default:;
				endcase

			end
	end


endmodule