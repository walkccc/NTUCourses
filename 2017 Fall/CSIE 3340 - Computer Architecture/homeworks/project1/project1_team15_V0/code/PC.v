module PC(
    clk_i,
    start_i,
	hazard_i,
    pc_i,
    pc_o
);

	input               clk_i;
	input               start_i;
	input				hazard_i;	
	input   	[31:0]  pc_i;
	output reg	[31:0]	pc_o;

	always@(posedge clk_i) begin
		if (start_i && !hazard_i) begin
			pc_o <= pc_i;
		end else if (!start_i) begin
			pc_o <= 32'b0;
		end
	end

endmodule
