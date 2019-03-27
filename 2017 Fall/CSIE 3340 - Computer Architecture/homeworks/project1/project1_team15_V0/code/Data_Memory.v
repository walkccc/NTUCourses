module Data_Memory(
	clk_i,
	address_i,
	writeData_i,
	MemWrite_i,
	MemRead_i,
	ReadData_o
);

	input			clk_i;
	input	[31:0]	address_i;
	input	[31:0]	writeData_i;
	input			MemWrite_i, MemRead_i;
	output	[31:0]	ReadData_o;

	reg		[7:0]	memory	[0:31];

	always@(posedge clk_i)
	begin
		if (MemWrite_i) begin
			memory[address_i]		<= writeData_i[7:0];
			memory[address_i + 1]	<= writeData_i[15:8];
			memory[address_i + 2]	<= writeData_i[23:16];
			memory[address_i + 3]	<= writeData_i[31:24];
		end
	end

	assign	ReadData_o	= (MemRead_i == 1'b1)?	{ memory[address_i + 3], memory[address_i + 2], memory[address_i + 1], memory[address_i] } : 32'b0;

endmodule
