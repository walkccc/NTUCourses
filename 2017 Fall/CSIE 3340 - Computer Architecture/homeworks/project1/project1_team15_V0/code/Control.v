module Control(
    op_i,
    control_o
);

    input   	[5:0]   op_i;
    output reg	[31:0]	control_o;
	
	/*** [0]: RegWrite ***/ 
	/*** [1]: MemtoReg ***/
	/*** [2]: Branch *****/
	/*** [3]: MemRead ****/
	/*** [4]: MemWrite ***/
	/*** [5]: RegDst *****/
	/*** [7:6]: ALUOp ****/
	/*** [8]: ALUSrc *****/
	/*** [9]: Jump *******/	

	always @(op_i) begin
		case(op_i)
			6'b000000: begin control_o <= { 22'b0, 1'b0, 1'b0, 2'b10, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1 };	end		/*** R-type ***/ 
			6'b100011: begin control_o <= { 22'b0, 1'b0, 1'b1, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1 };	end		/*** lw *******/ 
			6'b101011: begin control_o <= { 22'b0, 1'b0, 1'b1, 2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0 }; end		/*** sw *******/ 
			6'b000100: begin control_o <= { 22'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0 };	end		/*** beq ******/ 
			6'b000010: begin control_o <= { 22'b0, 1'b1, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };	end		/*** j ********/
			6'b001000: begin control_o <= { 22'b0, 1'b0, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1 };	end		/*** addi *****/
			  default: begin control_o <= 32'b0; end
		endcase
	end

endmodule
