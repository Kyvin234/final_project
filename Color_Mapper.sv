//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input logic frame_clk, Reset,
                        input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       input  logic [1:0] Direction,
                       output logic [7:0] Red, Green, Blue,
                       output logic [7:0] xtest,
                       output [7:0] score);
    /*vga drawing variables*/
    logic ball_on, maze_on, dot_on, font_on;	 
    // int DistX, DistY, Size;
	// assign DistX = DrawX - BallX;
    // assign DistY = DrawY - BallY;
    // assign Size = Ball_size;
    /*pacman sprite variables*/
    logic [31:0]  pacman_data;   //pacman sprite data
    logic [7:0]   pacman_addr;   //pacman sprite address
    logic [415:0] maze_data;     //maze sprite data
    logic [9:0]   maze_addr;     //maze sprite data
    logic [7:0]   font_data;     //score boards font data
    logic [10:0]  font_addr;     //score boards address

    pacman_sprites pac (.addr(pacman_addr),.data(pacman_data));
    maze_sprites   maze(.addr(maze_addr),   .data(maze_data));
    dot_map        dot(.Reset(Reset), .frame_clk(frame_clk),.dx(DrawX), .dy(DrawY), .px(BallX), .py(BallY), .dot_on(dot_on), .score(score));
    font_sprites   font(.addr(font_addr), .data(font_data));
    always_comb
    begin:Ball_on_proc
        //pacman
        if (((DrawX >= BallX - Ball_size) && (DrawX <= BallX + Ball_size) && (DrawY >= BallY - Ball_size) && (DrawY <= BallY + Ball_size)))
		    begin
          pacman_addr = (DrawY - BallY + Ball_size + 8'd32*Direction);
          ball_on = 1'b1;
		    end
        else
			begin
			pacman_addr = 7'b0000000;
            ball_on = 1'b0;
		    end
        
        //maze wall
        if(DrawX < 416 && DrawY < 401 && DrawX >= 0 && DrawY >= 0)
            begin
            maze_addr = DrawY + 220;
            maze_on = 1'b1;
            end
        else
            begin
            maze_addr = 10'b0000000000;
            maze_on = 1'b0;
            end

        //score board
         if(DrawX < 508 && DrawX >= 500 && DrawY >= 160 && DrawY < 176)
             begin
             font_addr =  (score[3:0])*16+DrawY-160;
             font_on = 1'b1;
             end
         else
             begin
             font_addr = 11'd2;
             font_on = 1'b0;
             end
//        if(DrawX>11'd183&&DrawX<11'd192&&DrawY>11'd47&&DrawY<11'd64) begin font_on=1'b1; font_addr = (11'd48+0)*16+DrawY-11'd48; end
//		else begin font_on=1'b0; font_addr = 0; end
     end 
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1) && pacman_data[DrawX - BallX + Ball_size] == 1'b1)
            begin
            Red    =   8'hff;
            Green  =   8'hff;
            Blue   =   8'h00;
            end   
        else if((maze_on == 1'b1) && maze_data[DrawX] == 1'b1)
            begin
            Red    =   8'h00;
            Green  =   8'h00;
            Blue   =   8'hff;
            end
        else if(dot_on == 1'b1)
        begin
            Red    =   8'hff;
            Green  =   8'hff;
            Blue   =   8'h00;
        end
        else if(font_on == 1'b1 && font_data[500-DrawX])
        begin 
            Red    =   8'hff;
            Green  =   8'h00;
            Blue   =   8'hff;
        end
		  else
				begin
            Red    =   8'h00;
            Green  =   8'h00;
            Blue   =   8'h00;
				end    
    end 
    assign xtest = font_data;
endmodule
