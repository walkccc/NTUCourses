module MUX5(
	data1_i,	// inst[20:16]
	data2_i,	// inst[15:11]
	select_i,	// Control.RegDst_o
	data_o		// Registers.RDaddr_i
);

input	[4:0]	data1_i;
input	[4:0]	data2_i;
input		select_i;
output	[4:0]	data_o;

reg 	[4:0]	tmpData_O;
assign	data_o = tmpData_O;

always@(*) begin
	if (select_i) begin
		tmpData_O = data1_i;
	end
	else begin
		tmpData_O = data2_i;
	end
end

endmodule
