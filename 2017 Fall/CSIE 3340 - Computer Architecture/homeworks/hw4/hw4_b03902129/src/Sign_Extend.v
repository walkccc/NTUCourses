module Sign_Extend(
	data_i,	// IF_ID.inst15_0_o
	data_o	// ID_EX.inst31_0_i
);

input	[15:0]	data_i;
output reg	[31:0]	data_o;

// reg		[31:0]	data_o;

always@(*) begin
	data_o[15:0] = data_i[15:0];
	data_o[31:16] = data_i[15];
end

endmodule
