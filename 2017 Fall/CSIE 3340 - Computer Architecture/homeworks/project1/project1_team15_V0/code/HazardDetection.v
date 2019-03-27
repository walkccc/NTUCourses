module HazardDetection(
	IFID_Rs_i,
	IFID_Rt_i,
	IDEX_Rt_i,
	RegWr_i,
	MemRead_i,
	Jump_i,
	Branch_i,
	Equal_i,
	stall_o,
	flush_o,
	pc_hazard_o
);

	input		[4:0]	IFID_Rs_i, IFID_Rt_i, IDEX_Rt_i;
	input				RegWr_i, MemRead_i;
	input				Jump_i, Branch_i, Equal_i;
	output reg			stall_o;
	output reg	[1:0]	flush_o;			/*** 00: stall, 01 flush, 10: new inst ***/
	output reg			pc_hazard_o;

	always @(IFID_Rs_i or IFID_Rt_i or IDEX_Rt_i or RegWr_i or MemRead_i or Jump_i or Branch_i or Equal_i) begin
		if ((MemRead_i || (Branch_i && RegWr_i)) && ((IDEX_Rt_i == IFID_Rs_i) || (IDEX_Rt_i == IFID_Rt_i))) begin
			stall_o 	<= 1'b1;
			flush_o 	<= 2'b00;
			pc_hazard_o <= 1'b1;
		end else if (Jump_i || (Branch_i && Equal_i)) begin
			stall_o 	<= 1'b1;
			flush_o 	<= 2'b01;
			pc_hazard_o <= 1'b0;
		end else begin
			stall_o		<= 1'b0;
			flush_o 	<= 2'b10;
			pc_hazard_o	<= 1'b0;
		end 
	end

endmodule
