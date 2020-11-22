module check_count_row(
	input logic [11:0] row, 
	output logic [7:0] count
);

	logic [7:0] c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11;
	assign count = c0+c1+c2+c3+c4+c5+c6+c7+c8+c9+c10+c11;
	check_count_dot d0(.dot(row[0]), .eaten(c0));
	check_count_dot d1(.dot(row[1]), .eaten(c1));
	check_count_dot d2(.dot(row[2]), .eaten(c2));
	check_count_dot d3(.dot(row[3]), .eaten(c3));
	check_count_dot d4(.dot(row[4]), .eaten(c4));
	check_count_dot d5(.dot(row[5]), .eaten(c5));
	check_count_dot d6(.dot(row[6]), .eaten(c6));
	check_count_dot d7(.dot(row[7]), .eaten(c7));
	check_count_dot d8(.dot(row[8]), .eaten(c8));
	check_count_dot d9(.dot(row[9]), .eaten(c9));
	check_count_dot d10(.dot(row[10]), .eaten(c10));
	check_count_dot d11(.dot(row[11]), .eaten(c11));


						 
endmodule