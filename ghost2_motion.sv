module ghost2(
    input logic  Reset, frame_clk,game_reset, game_on,
    input logic [9:0] BallX, BallY,
    output [9:0] GhostX, GhostY,
	output logic die2
);
    parameter [9:0] Ghost_X_Center=160;  // Center position on the X axis
    parameter [9:0] Ghost_Y_Center=160;  // Center position on the Y axis
    parameter [9:0] Ghost_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ghost_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ghost_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ghost_Y_Max=479;     // Bottommost point on the Y axis
	parameter [2:0] up   = 2'b00;
	parameter [2:0] down = 2'b01;
	parameter [2:0] left = 2'b11;
	parameter [2:0] right = 2'b10;
    parameter [9:0] Ghost_X_Step = 1;      // Step size on the X axis
    parameter [9:0] Ghost_Y_Step = 1;      // Step size on the Y axis



    logic [9:0] Ghost_X_Pos, Ghost_X_Motion, Ghost_Y_Pos, Ghost_Y_Motion;
    logic [9:0] uc, dc, lc, rc;
	logic [3:0] ut, dt, lt, rt;
    logic [3:0] Direction;
    logic [1:0] rand_motion;
    assign uc = Ghost_Y_Pos + 32'd28;
	assign dc = Ghost_Y_Pos;
	assign lc = Ghost_X_Pos + 32'd28;
	assign rc = Ghost_X_Pos;
    logic motion_check;
    check_wall wall_checker_u(.x(Ghost_X_Pos[9:5]), .y(uc[9:5]), .turnable(ut));
	check_wall wall_checker_d(.x(Ghost_X_Pos[9:5]), .y(dc[9:5]), .turnable(dt));
	check_wall wall_checker_l(.x(lc[9:5]), .y(Ghost_Y_Pos[9:5]), .turnable(lt));
	check_wall wall_checker_r(.x(rc[9:5]), .y(Ghost_Y_Pos[9:5]), .turnable(rt));
    motion_predict random_motion(.Clk(frame_clk), .Reset(Reset), .motion_check(motion_check), .data(rand_motion), .ut(ut), .dt(dt), .lt(lt), .rt(rt));
    always_comb
    begin
        if((Ghost_Y_Motion == 0 && Ghost_X_Motion == 0) || (Ghost_X_Pos %32 == 0 && Ghost_Y_Pos % 32 == 0))
            motion_check = 1'b1;
        else
            motion_check = 1'b0;
    end
    always_ff @ (posedge Reset or posedge frame_clk or posedge game_reset )
    begin: Move_Ghost
		  
        if (Reset || game_reset)  // Asynchronous Reset
        begin 
            	Ghost_X_Motion <= 10'd0; //Ghost_Y_Step;
				Ghost_Y_Motion <= 10'd0; //Ghost_X_Step;
				Ghost_Y_Pos <= Ghost_Y_Center;
				Ghost_X_Pos <= Ghost_X_Center;
                Direction  <= 2'b00;
				die2 <= 1'b0;
        end
        else if(game_on == 1'b1)
        begin 
			case (rand_motion)
				//up
				2'b00 : 
						if((ut & 4'b1000) == 4'b1000)
						begin
							Ghost_Y_Motion <= -1;   
							Ghost_X_Motion <= 0;
                            Direction     <= 2'b00;
						end
				//down
				2'b01 : 
						if ((dt & 4'b0100) == 4'b0100)
						begin
							Ghost_Y_Motion <= 1;     
							Ghost_X_Motion <= 0;
                            Direction     <= 2'b01;
						end
				//left
				2'b11 : 	
						if ((lt & 4'b0010) == 4'b0010)
						begin
							Ghost_X_Motion <=  -1; 
							Ghost_Y_Motion <=  0;
                            Direction     <=  2'b11;
						end
				//right
				2'b10 :
						if ((rt & 4'b0001) == 4'b0001)
						begin
							Ghost_X_Motion <= 1;     
							Ghost_Y_Motion <= 0;
                            Direction     <= 2'b10;
						end
				default: ;
			endcase 

			if((Direction == 2'b00) && ((ut & 4'b1000) == 4'b1000))
			begin
				Ghost_Y_Motion <= (~ (Ghost_Y_Step) + 1'b1); //up
				Ghost_X_Motion <= 0;
			end
			else if ((Direction == 2'b01) && ((dt & 4'b0100) == 4'b0100))
			begin
				Ghost_X_Motion <= 0; //down
				Ghost_Y_Motion <= Ghost_Y_Step;
			end
			else if ((Direction == 2'b10) && ((rt & 4'b0001) == 4'b0001))
			begin
				Ghost_X_Motion <= Ghost_X_Step; //right
				Ghost_Y_Motion <= 0;

			end
			else if ((Direction == 2'b11) && ((lt & 4'b00010) == 4'b0010))
			begin
				Ghost_X_Motion <= (~ (Ghost_X_Step) + 1'b1); //left
				Ghost_Y_Motion <= 0;
			end
			else
			begin
				Ghost_X_Motion <= 0; 
				Ghost_Y_Motion <= 0;
			end
			Ghost_Y_Pos <= (Ghost_Y_Pos + Ghost_Y_Motion);
			Ghost_X_Pos <= (Ghost_X_Pos + Ghost_X_Motion);

			if(BallX[9:5] == Ghost_X_Pos[9:5] && BallY[9:5] == Ghost_Y_Pos[9:5])
				die2 <= 1'b1;
		end  
    end

    assign GhostX = Ghost_X_Pos;
    assign GhostY = Ghost_Y_Pos;

endmodule