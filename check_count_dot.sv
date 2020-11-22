module check_count_dot(
    input logic dot,
    output logic[7:0] eaten);

    always_comb
    begin
        if(dot == 1'b1)
            eaten = 8'b00000000;
        else
            eaten = 8'b00000001;
    end
endmodule