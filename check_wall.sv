module check_wall(

    input  [4:0] x,
    input  [4:0] y,
    output [3:0] turnable //up down left right
);
	 logic [48:0] temp;
    parameter [0:11][47:0] maze_direction = 
    {
        48'h053736537360,
        48'h0c0c0cc0c0c0,
        48'h0d3f7bb7f3e0,
        48'h093e965ad3a0,
        48'h000c5bb6c000,
        48'h013fe00df320,
        48'h000cc00cc000,
        48'h000cd33ec000,
        48'h053fb65bf360,
        48'h096d7bb7e5a0,
        48'h05ba965a9b60,
        48'h09333bb333a0
    };
     always_comb
     begin
        temp = maze_direction[y-1];
        case(x)
            5'h1:
                turnable = temp[47:44];
            5'h2:
                turnable = temp[43:40];
            5'h3:
                turnable = temp[39:36];
            5'h4:
                turnable = temp[35:32];
            5'h5:
                turnable = temp[31:28];
            5'h6:
                turnable = temp[27:24];
            5'h7:
                turnable = temp[23:20];
            5'h8:
                turnable = temp[19:16];
            5'h9:
                turnable = temp[15:12];
            5'ha:
                turnable = temp[11:8];
            5'hb:
                turnable = temp[7:4];
            5'hc:
                turnable = temp[3:0];
            default:
				turnable = 4'b1111;
        endcase
     end

endmodule