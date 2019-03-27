module FW(
	EXMEM_Rd_i,
	EXMEM_RegWr_i,
	MEMWB_Rd_i,
	MEMWB_RegWr_i,
	IDEX_Rs_i,
	IDEX_Rt_i,
	IFID_Rs_i,
	IFID_Rt_i,
	ForwardA_o,
	ForwardB_o,
	RSselect_o,
	RTselect_o
);

	input				EXMEM_RegWr_i, MEMWB_RegWr_i;
	input		[4:0]	MEMWB_Rd_i,	EXMEM_Rd_i;
	input		[4:0]	IDEX_Rs_i, IDEX_Rt_i;
	input		[4:0]	IFID_Rs_i, IFID_Rt_i;

	output reg	[1:0]	ForwardA_o, ForwardB_o;
	output reg			RSselect_o, RTselect_o;

	always@(IFID_Rs_i or IFID_Rt_i or IDEX_Rs_i or IDEX_Rt_i or EXMEM_Rd_i or MEMWB_Rd_i or EXMEM_RegWr_i or MEMWB_RegWr_i) begin

		/*** Initialize ***/
		begin 
			ForwardA_o <= 2'b00;
			ForwardB_o <= 2'b00;
			RSselect_o <= 1'b0;
			RTselect_o <= 1'b0; 
		end

		/*** ??? **********/
		if (MEMWB_RegWr_i && MEMWB_Rd_i != 5'd0 && MEMWB_Rd_i == IFID_Rs_i) begin RSselect_o <= 1'b1; end
		if (MEMWB_RegWr_i && MEMWB_Rd_i != 5'd0 && MEMWB_Rd_i == IFID_Rt_i) begin RTselect_o <= 1'b1; end

		/*** EX hazard ****/
		if (EXMEM_RegWr_i && EXMEM_Rd_i != 5'd0 && EXMEM_Rd_i == IDEX_Rs_i) begin ForwardA_o <= 2'b10; end
		if (EXMEM_RegWr_i && EXMEM_Rd_i != 5'd0 && EXMEM_Rd_i == IDEX_Rt_i) begin ForwardB_o <= 2'b10; end
		
		/*** MEM hazard ***/
		if (MEMWB_RegWr_i && MEMWB_Rd_i != 5'd0 && EXMEM_Rd_i != IDEX_Rs_i && MEMWB_Rd_i == IDEX_Rs_i) begin ForwardA_o <= 2'b01; end
		if (MEMWB_RegWr_i && MEMWB_Rd_i != 5'd0 && EXMEM_Rd_i != IDEX_Rt_i && MEMWB_Rd_i == IDEX_Rt_i) begin ForwardB_o <= 2'b01; end
	end

endmodule
