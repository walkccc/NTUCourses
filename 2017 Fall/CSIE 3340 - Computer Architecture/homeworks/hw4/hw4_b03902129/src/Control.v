module Control(
	Op_i,		// inst[31:26]
	RegDst_o,	// MUX_RegDst.select_i
	ALUOp_o,	// ALU_Control.ALUOp_i
	ALUSrc_o,	// MUX_ALUSrc.select_i
	RegWrite_o	// Registers.RegWrite_i
);

input	[5:0]	Op_i;
output			RegDst_o;
output	[1:0]	ALUOp_o;
output			ALUSrc_o;
output			RegWrite_o;

reg			tmpRegDst_o;
reg	[1:0]	tmpALUOp_o;
reg			tmpALUSrc_o;

assign	RegDst_o = tmpRegDst_o;
assign	ALUOp_o = tmpALUOp_o;
assign	ALUSrc_o = tmpALUSrc_o;
assign	RegWrite_o = 1'd1;

always@(*) begin
	if (Op_i[3]) begin
		tmpRegDst_o = 1'd1;
		tmpALUOp_o = 2'd0;
		tmpALUSrc_o = 1'd1;
	end
	else begin
		tmpRegDst_o = 1'd0;
		tmpALUOp_o = 2'd3;
		tmpALUSrc_o = 1'd0;
	end
end

endmodule
