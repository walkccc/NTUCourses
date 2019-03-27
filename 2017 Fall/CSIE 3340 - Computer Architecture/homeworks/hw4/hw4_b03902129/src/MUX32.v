module MUX32(
	data1_i,	// Registers.RTdata_o
	data2_i,	// Sign_Extend.data_o
	select_i,	// Control.ALUSrc_o
	data_o		// ALU.data2_i
);

input	[31:0]	data1_i;
input	[31:0]	data2_i;
input		select_i;
output	[31:0]	data_o;

reg 	[31:0] 	tmpData_O;
assign	data_o = tmpData_O;

always@(*) begin
	if (~select_i) begin
		tmpData_O = data1_i;
	end
	else begin
		tmpData_O = data2_i;
	end
end

endmodule
