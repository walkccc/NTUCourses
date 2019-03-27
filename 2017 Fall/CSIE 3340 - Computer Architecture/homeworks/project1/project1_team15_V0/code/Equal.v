module Equal(
	data1_i,
	data2_i,
	data_o	
);
	
	input	[31:0]	data1_i, data2_i;
	output			data_o;

	assign 	data_o	= (data1_i == data2_i)? 1'b1 : 1'b0;

endmodule
