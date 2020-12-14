module bot_motion(
    input logic Clk, Reset, motion_check,
    input [9:0] BallX, BallY, GhostX, GhostY,
    input logic [3:0] ut, dt, lt, rt,
    output logic [1:0] ai_motion
);
    parameter [2:0] up   = 2'b00;
	parameter [2:0] down = 2'b01;
	parameter [2:0] left = 2'b11;
	parameter [2:0] right = 2'b10;
    always_ff @(posedge Clk or posedge Reset)
    begin
        if(Reset)
        begin
            ai_motion <= down;
        end
        else if(motion_check == 1'b1)
        begin 
            // pacman is at the top/right of the ghost
            if(BallX > GhostX && BallY < GhostY)
            begin
                if (((rt & 4'b0001) == 4'b0001) && (BallX - GhostX >= GhostY - BallY)) //can go right
                begin
                    ai_motion <= right;
                end
                else if((ut & 4'b1000) == 4'b1000) //can go up
                begin
                    ai_motion <= up;
                end
                else if ((lt & 4'b0010) == 4'b0010) // can go left
                begin
                    ai_motion <= left;
                end
                else if ((dt & 4'b0100) == 4'b0100) // can go down
                begin
                    ai_motion <= down;
                end                
            end
            // pacman is at the top/left of the ghost
             else if(BallX < GhostX && BallY < GhostY)
            begin              
                if ((lt & 4'b0010) == 4'b0010  && (GhostX - BallX >= GhostY - BallY)) // can go left
                begin
                    ai_motion <= left;
                end
                else if((ut & 4'b1000) == 4'b1000) //can go up
                begin
                    ai_motion <= up;
                end
                if ((rt & 4'b0001) == 4'b0001) //can go right
                begin
                    ai_motion <= right;
                end
                else if ((dt & 4'b0100) == 4'b0100) // can go down
                begin
                    ai_motion <= down;
                end  
            end
            // pacman is at the bottom/right of the ghost
            else if(BallX > GhostX && BallY > GhostY)
            begin
                if ((rt & 4'b0001) == 4'b0001 && (BallX - GhostX >= BallY - GhostY)) //can go right
                begin
                    ai_motion <= right;
                end
                else if ((dt & 4'b0100) == 4'b0100) // can go down
                begin
                    ai_motion <= down;
                end                
                else if ((lt & 4'b0010) == 4'b0010) // can go left
                begin
                    ai_motion <= left;
                end
                else if((ut & 4'b1000) == 4'b1000) //can go up
                begin
                    ai_motion <= up;
                end
            end
            // pacman is at the bottom/left of the ghost
            else if(BallX < GhostX && BallY > GhostY)
            begin              
                if ((lt & 4'b0010) == 4'b0010  && (GhostX - BallX >= BallY - GhostY)) // can go left
                begin
                    ai_motion <= left;
                end
                else if ((dt & 4'b0100) == 4'b0100) // can go down
                begin
                    ai_motion <= down;
                end  
                else if ((rt & 4'b0001) == 4'b0001) //can go right
                begin
                    ai_motion <= right;
                end
                else if((ut & 4'b1000) == 4'b1000) //can go up
                begin
                    ai_motion <= up;
                end
            end
            else if(BallX == GhostX)
            begin
                if((dt & 4'b0100) == 4'b0100 && GhostY < BallY)
                    ai_motion <= down;
                else if((ut & 4'b1000) == 4'b1000  && GhostY > BallY )
                    ai_motion <= up;
                else if ((rt & 4'b0001) == 4'b0001) //can go right
                begin
                    ai_motion <= right;
                end
                else if ((lt & 4'b0010) == 4'b0010) // can go left
                begin
                    ai_motion <= left;
                end
            end
            else if(BallY == GhostY)
            begin
                if ((rt & 4'b0001) == 4'b0001 && GhostX < BallX) //can go right
                begin
                    ai_motion <= right;
                end
                else if ((lt & 4'b0010) == 4'b0010  && GhostX > BallX) // can go left
                begin
                    ai_motion <= left;
                end
                else if((dt & 4'b0100) == 4'b0100)
                    ai_motion <= down;
                else if((ut & 4'b1000) == 4'b1000)
                    ai_motion <= up;
            end


        end
    end
endmodule