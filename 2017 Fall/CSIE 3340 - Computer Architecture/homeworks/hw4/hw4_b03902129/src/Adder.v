module Adder(
	data1_i,	// inst_addr
	data2_i,	// 32'd4
	data_o		// PC.pc_i
);

input	[31:0]	data1_i, data2_i;
output	[31:0]	data_o;

assign data_o = data1_i + data2_i;

endmodule
