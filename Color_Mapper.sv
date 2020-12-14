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


module  color_mapper ( input logic frame_clk, Reset, start_on, game_1_on, game_2_on, game_3_on, win_on,lose_on, transition_on,
                       input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       input  logic [1:0] Direction,
                       output logic [7:0] Red, Green, Blue,
                       output logic [1:0] ai_test,
                       output logic die, 
                       output logic [4:0] ghostx, ghosty,
                       output [7:0] score);

    parameter [9:0] ghost_s =  16;
    /*vga drawing variables*/
    logic ball_on, maze_on, dot_on, dot_on_temp, font_on_1, font_on_2, font_on_start, font_on_win, ghost_on_1, font_on_lose, ghost_on_2, ghost_on_3, ghost_on_4;	 
    logic die1, die2, die3, die4;
    logic [9:0] ghost_x_1, ghost_y_1, ghost_x_2, ghost_y_2, ghost_x_3, ghost_y_3, ghost_x_4, ghost_y_4;
    // int DistX, DistY, Size;
	// assign DistX = DrawX - BallX;
    // assign DistY = DrawY - BallY;
    // assign Size = Ball_size;
    /*pacman sprite variables*/
    logic [31:0]  pacman_data;   //pacman sprite data
    logic [7:0]   pacman_addr;   //pacman sprite address
    logic [31:0]  ghost_data_1;   //ghost1 sprite data
    logic [7:0]   ghost_addr_1;   //ghost1 sprite address
    logic [31:0]  ghost_data_2;   //ghost2 sprite data
    logic [7:0]   ghost_addr_2;   //ghost2 sprite address
    logic [31:0]  ghost_data_3;   //ghost3 sprite data
    logic [7:0]   ghost_addr_3;   //ghost3 sprite address
    logic [31:0]  ghost_data_4;   //ghost4 sprite data
    logic [7:0]   ghost_addr_4;   //ghost4 sprite address
    logic [1:0]   level;
    logic [415:0] maze_data;     //maze sprite data
    logic [9:0]   maze_addr;     //maze sprite data
    logic [7:0]   font_data_1;     //score boards font data
    logic [10:0]  font_addr_1;     //score boards address
    logic [7:0]   font_data_2;     //score boards font data
    logic [10:0]  font_addr_2;     //score boards address
    logic [7:0]   font_data_start;     //score boards font data
    logic [10:0]  font_addr_start;     //score boards address
    logic [7:0]   font_data_win;     //score boards font data
    logic [10:0]  font_addr_win;     //score boards address
    logic [7:0]   font_data_lose;     //score boards font data
    logic [10:0]  font_addr_lose;     //score boards address

    pacman_sprites pac (.addr(pacman_addr),.data(pacman_data));
    maze_sprites   maze(.addr(maze_addr),   .data(maze_data));
    dot_map        dot(.Reset(Reset), .frame_clk(frame_clk),.dx(DrawX), .dy(DrawY), .px(BallX), .py(BallY), .dot_on(dot_on_temp), .score(score), .game_reset(start_on || transition_on));
    font_sprites   font1(.addr(font_addr_1), .data(font_data_1));
    font_sprites   font2(.addr(font_addr_2), .data(font_data_2));
    font_sprites   font_start(.addr(font_addr_start), .data(font_data_start));
    font_sprites   font_win(.addr(font_addr_win), .data(font_data_win));
    pacman_sprites ghost1(.addr(ghost_addr_1), .data(ghost_data_1));
    pacman_sprites ghost2(.addr(ghost_addr_2), .data(ghost_data_2));
    pacman_sprites ghost3(.addr(ghost_addr_3), .data(ghost_data_3));
    pacman_sprites ghost4(.addr(ghost_addr_4), .data(ghost_data_4));
    ghost   ghost_motion_1(.Reset(Reset), .frame_clk(frame_clk), .game_reset(start_on || transition_on), .GhostX(ghost_x_1), .GhostY(ghost_y_1), .BallX(BallX), .BallY(BallY), .ai_test(ai_test), .game_on(game_1_on || game_2_on || game_3_on), .die1(die1));
    ghost2  ghost_motion_2(.Reset(Reset), .frame_clk(frame_clk), .game_reset(start_on || transition_on), .GhostX(ghost_x_2), .GhostY(ghost_y_2), .BallX(BallX), .BallY(BallY), .game_on(game_1_on || game_2_on || game_3_on), .die2(die2));
    ghost3  ghost_motion_3(.Reset(Reset), .frame_clk(frame_clk), .game_reset(start_on || transition_on), .GhostX(ghost_x_3), .GhostY(ghost_y_3), .BallX(BallX), .BallY(BallY), .game_on(game_2_on || game_3_on), .die3(die3), .option(1'b0));
    ghost3  ghost_motion_4(.Reset(Reset), .frame_clk(frame_clk), .game_reset(start_on || transition_on), .GhostX(ghost_x_4), .GhostY(ghost_y_4), .BallX(BallX), .BallY(BallY), .game_on(game_3_on), .die3(die4), .option(1'b1));
    font_sprites   font_lose(.addr(font_addr_lose), .data(font_data_lose));
    assign die = die1 || die2 || die3 || die4; 
    always_comb
    begin
        level = 2'b00;
        if(game_1_on == 1'b1)
            level = 2'b01;
        else if(game_2_on == 1'b1)
            level = 2'b10;
        else if(game_3_on == 1'b1)
            level = 2'b11;
    end
    always_comb
    begin:Ball_on_proc 
        pacman_addr = 8'h00;       
        maze_addr   = 10'h0;        
        font_addr_1 = 11'h0;     
        font_addr_2 = 11'h0; 
        font_addr_start = 11'h0;
        font_addr_win = 11'h0;
        font_addr_lose = 11'h0;
        ghost_addr_1 = 8'h00;
        ghost_addr_2 = 8'h00;
        ghost_addr_3 = 8'h00;
        ghost_addr_4 = 8'h00;
        ball_on = 1'b0;
        maze_on = 1'b0;
        font_on_1 = 1'b0;
        font_on_2 = 1'b0;
        font_on_start = 1'b0;
        font_on_win = 1'b0;
        ghost_on_1 = 1'b0;
        ghost_on_2 = 1'b0;
        ghost_on_3 = 1'b0;
        ghost_on_4 = 1'b0;
        dot_on = 1'b0;
        font_on_lose = 1'b0;
        if(game_1_on == 1'b1 || game_2_on == 1'b1 || game_3_on == 1'b1)
        begin
             //pacman
			dot_on = dot_on_temp;
            if (((DrawX >= BallX - Ball_size) && (DrawX <= BallX + Ball_size) && (DrawY >= BallY - Ball_size) && (DrawY <= BallY + Ball_size)))
            begin
                pacman_addr = (DrawY - BallY + Ball_size + 8'd32*Direction);
                ball_on = 1'b1;
            end
            //maze wall
            if(DrawX < 416 && DrawY < 401 && DrawX >= 0 && DrawY >= 0)
            begin
                maze_addr = DrawY + 220;
                maze_on = 1'b1;
            end
            //score board first digit
            if(DrawX < 508 && DrawX >= 500 && DrawY >= 160 && DrawY < 176)
            begin
                font_addr_1 =  (score[7:4]+11'h30)*16+DrawY-160;
                font_on_1 = 1'b1;
            end
            //score board second digit 
            if(DrawX < 516 && DrawX >= 508 && DrawY >= 160 && DrawY < 176)
            begin
                font_addr_2 =  (score[3:0]+11'h30)*16+DrawY-160;
                font_on_2 = 1'b1;
            end
            //ghost1 
            if (((DrawX >= ghost_x_1 - ghost_s) && (DrawX <= ghost_x_1 + ghost_s) && (DrawY >= ghost_y_1 - ghost_s) && (DrawY <= ghost_y_1 + ghost_s)))
            begin
                ghost_addr_1 = (DrawY - ghost_y_1 + ghost_s + 8'd32*4);
                ghost_on_1 = 1'b1;
            end
            //ghost2
            if ((DrawX >= ghost_x_2 - ghost_s) && (DrawX <= ghost_x_2 + ghost_s) && (DrawY >= ghost_y_2 - ghost_s) && (DrawY <= ghost_y_2 + ghost_s))
            begin
                ghost_addr_2 = (DrawY - ghost_y_2 + ghost_s + 8'd32*4);
                ghost_on_2 = 1'b1;
            end
            //ghost3
            if ((game_2_on == 1'b1 || game_3_on == 1'b1) && (DrawX >= ghost_x_3 - ghost_s) && (DrawX <= ghost_x_3 + ghost_s) && (DrawY >= ghost_y_3 - ghost_s) && (DrawY <= ghost_y_3 + ghost_s))
            begin
                ghost_addr_3 = (DrawY - ghost_y_3 + ghost_s + 8'd32*4);
                ghost_on_3 = 1'b1;
            end
            //ghost4
            if ((game_3_on == 1'b1 ) && (DrawX >= ghost_x_4 - ghost_s) && (DrawX <= ghost_x_4 + ghost_s) && (DrawY >= ghost_y_4 - ghost_s) && (DrawY <= ghost_y_4 + ghost_s))
            begin
                ghost_addr_4 = (DrawY - ghost_y_4 + ghost_s + 8'd32*4);
                ghost_on_4 = 1'b1;
            end
        end
        else if (start_on == 1'b1 && DrawX < 328 && DrawX >= 320 && DrawY >= 160 && DrawY < 176)
        begin
            font_addr_start = 8'h58 * 16 + DrawY-160;
            font_on_start = 1'b1;
        end
        else if (win_on == 1'b1 && DrawX < 328 && DrawX >= 320 && DrawY >= 160 && DrawY < 176)
        begin
            font_addr_win = 8'h02* 16 + DrawY-160;
            font_on_win = 1'b1;
        end
        else if (lose_on == 1'b1 && DrawX < 328 && DrawX >= 320 && DrawY >= 160 && DrawY < 176)
         begin
            font_addr_lose = 8'h01* 16 + DrawY-160;
            font_on_lose = 1'b1;
        end
     end 
       
    always_comb
    begin:RGB_Display
        if((game_1_on || game_2_on || game_3_on) == 1'b1)
        begin
            if ((ball_on == 1'b1) && pacman_data[DrawX - BallX + Ball_size] == 1'b1)
            begin
                Red    =   8'hff;
                Green  =   8'hff;
                Blue   =   8'h00;
            end   
            else if ((ghost_on_1 == 1'b1) && ghost_data_1[DrawX - ghost_x_1 + ghost_s] == 1'b1)
            begin
                Red    =   8'h00;
                Green  =   8'hff;
                Blue   =   8'hff;
            end  
            else if ((ghost_on_2 == 1'b1) && ghost_data_2[DrawX - ghost_x_2 + ghost_s] == 1'b1)
            begin
                Red    =   8'd255;
                Green  =   8'd192;
                Blue   =   8'd203;
            end
            else if ((ghost_on_3 == 1'b1) && ghost_data_3[DrawX - ghost_x_3 + ghost_s] == 1'b1)
            begin
                Red    =   8'd220;
                Green  =   8'd20;
                Blue   =   8'd20;
            end
            else if ((ghost_on_4 == 1'b1) && ghost_data_4[DrawX - ghost_x_4 + ghost_s] == 1'b1)
            begin
                Red    =   8'd255;
                Green  =   8'd211;
                Blue   =   8'd0;
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
            else if(font_on_1 == 1'b1 && font_data_1[507-DrawX])
            begin 
                Red    =   8'hff;
                Green  =   8'h00;
                Blue   =   8'hff;
            end
            else if(font_on_2 == 1'b1 && font_data_2[515-DrawX])
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
		else if(start_on == 1'b1)
        begin
            if(font_on_start == 1'b1 && font_data_start[327-DrawX])
            begin
                Red    =   8'hff;
                Green  =   8'hff;
                Blue   =   8'hff;
            end
            else
		    begin
            Red    =   8'h00;
            Green  =   8'h00;
            Blue   =   8'h00;
		    end    
        end
        else if(win_on == 1'b1)
        begin
            if(font_on_win == 1'b1 && font_data_win[327-DrawX])
            begin
                Red    =   8'hff;
                Green  =   8'hff;
                Blue   =   8'hff;
            end
            else
		    begin
                Red    =   8'h00;
                Green  =   8'h00;
                Blue   =   8'h00;
		    end    
        end
        else if(lose_on == 1'b1)
        begin
            if(font_on_lose == 1'b1 && font_data_lose[327-DrawX])
            begin
                Red    =   8'hff;
                Green  =   8'hff;
                Blue   =   8'hff;
            end
            else
		    begin
                Red    =   8'h00;
                Green  =   8'h00;
                Blue   =   8'h00;
		    end    
        end
        else
		begin
            Red    =   8'h00;
            Green  =   8'h00;
            Blue   =   8'h00;
		end    
    end 
    assign ghostx = ghost_x_1[9:5];
    assign ghosty = ghost_y_1[9:5];
endmodule
