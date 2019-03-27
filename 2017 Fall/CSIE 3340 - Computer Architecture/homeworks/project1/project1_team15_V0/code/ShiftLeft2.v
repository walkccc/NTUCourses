module ShiftLeft2(
	data_i,
	data_o
);

	input	[31:0]	data_i;
	output	[31:0]	data_o;

	assign	data_o = data_i << 2;

endmodule
