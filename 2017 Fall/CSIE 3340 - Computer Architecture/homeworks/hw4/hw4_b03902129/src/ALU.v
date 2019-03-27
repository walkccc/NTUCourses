module ALU(
	data1_i,	// Registers.RSdata_o
	data2_i,	// MUX_ALUSrc.data_o
	ALUCtrl_i,	// ALU_Control.ALUCtrl_o
	data_o,		// Registers.RDdata_i
	Zero_o
);

input	[31:0]	data1_i;
input	[31:0]	data2_i;
input	[2:0] 	ALUCtrl_i;
output	[31:0] 	data_o;
output	Zero_o;

reg 	[31:0]	tmpData_o;
assign	data_o = tmpData_o;
assign	Zero_o = 1'b0;

always@(*) begin
	case (ALUCtrl_i)
		3'b000:	tmpData_o = data1_i & data2_i;
		3'b001:	tmpData_o = data1_i | data2_i;
		3'b010:	tmpData_o = data1_i + data2_i;
		3'b110:	tmpData_o = data1_i - data2_i;
		3'b111:	tmpData_o = data1_i * data2_i;
	endcase
end

endmodule
