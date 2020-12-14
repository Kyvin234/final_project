//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module ball(input  Reset, frame_clk,game_reset,
			input  [7:0] keycode,
            output [9:0] BallX, BallY, BallS, 
			output [2:0] Direction, 
			output [3:0] test,
			output  [3:0] test2);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	logic [9:0] uc, dc, lc, rc;
	logic [3:0] ut, dt, lt, rt;
	logic [3:0] turnable;
    parameter [9:0] Ball_X_Center=6*32;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=11*32;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	assign Ball_Size = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	assign uc = Ball_Y_Pos + 32'd28;
	assign dc = Ball_Y_Pos;
	assign lc = Ball_X_Pos + 32'd28;
	assign rc = Ball_X_Pos;
	
	// check_wall wall_checker(.x(Ball_X_Pos[9:5]), .y(Ball_Y_Pos[9:5]), .turnable(turnable));
	check_wall wall_checker_u(.x(Ball_X_Pos[9:5]), .y(uc[9:5]), .turnable(ut));
	check_wall wall_checker_d(.x(Ball_X_Pos[9:5]), .y(dc[9:5]), .turnable(dt));
	check_wall wall_checker_l(.x(lc[9:5]), .y(Ball_Y_Pos[9:5]), .turnable(lt));
	check_wall wall_checker_r(.x(rc[9:5]), .y(Ball_Y_Pos[9:5]), .turnable(rt));

    always_ff @ (posedge Reset or posedge frame_clk or posedge game_reset )
    begin: Move_Ball
		  
        if (Reset || game_reset)  // Asynchronous Reset
        begin 
            	Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				Direction  <= 2'b00;
				test2      <= 4'b0000;
        end
        else 
        begin 
			// Ball_X_Motion <= Ball_X_Motion;
			// Ball_Y_Motion <= Ball_Y_Motion;
			case (keycode)
				//up
				8'h1A : 
						if((ut & 4'b1000) == 4'b1000)
							begin
							Ball_Y_Motion <= -1;   
							Ball_X_Motion <= 0;
							Direction     <= 2'b00;
							end
				//down
				8'h16 : 
						if ((dt & 4'b0100) == 4'b0100)
							begin
							Ball_Y_Motion <= 1;     
							Ball_X_Motion <= 0;
							Direction     <= 2'b01;
							end
				//left
				8'h04 : 	
						if ((lt & 4'b0010) == 4'b0010)
							begin
							Ball_X_Motion <=  -1; 
							Ball_Y_Motion <=  0;
							Direction     <=  2'b11;
							end
				//right
				8'h07 :
						if ((rt & 4'b0001) == 4'b0001)
							begin
							Ball_X_Motion <= 1;     
							Ball_Y_Motion <= 0;
							Direction     <= 2'b10;
							end
				default: ;
			endcase 

			if((Direction == 2'b00) && ((ut & 4'b1000) == 4'b1000))
			begin
				Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1); //up
				Ball_X_Motion <= 0;
				test2 <= 4'b0001;
			end
			else if ((Direction == 2'b01) && ((dt & 4'b0100) == 4'b0100))
			begin
				Ball_X_Motion <= 0; //down
				Ball_Y_Motion <= Ball_Y_Step;
				test2 <= 4'b0001;
			end
			else if ((Direction == 2'b10) && ((rt & 4'b0001) == 4'b0001))
			begin
				Ball_X_Motion <= Ball_X_Step; //right
				Ball_Y_Motion <= 0;
				test2 <= 4'b0001;

			end
			else if ((Direction == 2'b11) && ((lt & 4'b00010) == 4'b0010))
			begin
				Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1); //left
				Ball_Y_Motion <= 0;
				test2 <= 4'b0001;
			end
			else
			begin
				Ball_X_Motion <= 0; 
				Ball_Y_Motion <= 0;
				test2 <= 4'b0000;
			end
			Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
			Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);

		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    
	assign test = turnable;

endmodule
