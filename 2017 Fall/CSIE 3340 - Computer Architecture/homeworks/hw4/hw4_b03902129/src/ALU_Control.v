module ALU_Control(
	funct_i,	// inst[5:0]
	ALUOp_i,	// Control.ALUOp_o
	ALUCtrl_o	// ALU.ALUCtrl_i
);

input	[5:0]	funct_i;
input	[1:0]	ALUOp_i;
output	[2:0]	ALUCtrl_o;

reg	[2:0]	tmpALUCtrl_o;
assign	ALUCtrl_o = tmpALUCtrl_o;

always@(*) begin
	if (ALUOp_i == 2'b00) begin		// add
		tmpALUCtrl_o = 3'b010;
	end
	if (ALUOp_i == 2'b01) begin		// sub
		tmpALUCtrl_o = 3'b110;
	end
	if (ALUOp_i == 2'b10) begin		// or
		tmpALUCtrl_o = 3'b001;
	end
	else begin
		case (funct_i)
			6'b100000:	tmpALUCtrl_o = 3'b010;	// add
			6'b100010:	tmpALUCtrl_o = 3'b110;	// sub
			6'b100100:	tmpALUCtrl_o = 3'b000;	// and
			6'b100101:	tmpALUCtrl_o = 3'b001;	// or
			6'b011000:	tmpALUCtrl_o = 3'b111;	// slt
		endcase
	end
end

endmodule
