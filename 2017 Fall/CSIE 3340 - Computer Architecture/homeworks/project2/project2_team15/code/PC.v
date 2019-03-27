module PC(
    clk_i,
	rst_i,
    start_i,
	hazard_i,
	cache_stall_i,
    pc_i,
    pc_o
);

	input               clk_i;
	input				rst_i;
	input               start_i;
	input				hazard_i;	
	input				cache_stall_i;
	input   [31:0]      pc_i;
	output  [31:0]      pc_o;

	reg     [31:0]      pc_o;

	always@(posedge clk_i or negedge rst_i) begin
		if (~rst_i) begin
			pc_o <= 32'b0;
		end else begin
			if (cache_stall_i) begin
			end
			else if (start_i) begin
				if (!hazard_i)
					pc_o <= pc_i;
			end
			else
				pc_o <= 32'b0;
		end
	end

endmodule
