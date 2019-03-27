module ShiftJump(
	data_i,
	data_o
);
	input	[25:0]	data_i;
	output	[27:0]	data_o;

	assign	data_o =	{ data_i, 2'b00 };
endmodule
