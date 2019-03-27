module PC(
    clk_i,      // clk_i,
    rst_i,      // rst_i,
    start_i,    // start_i,
    pc_i,       // Add_PC.data_o,
    pc_o        // inst_addr
);

// Ports
input           clk_i;
input           rst_i;
input           start_i;
input   [31:0]  pc_i;
output  [31:0]  pc_o;

// Wires & Registers
reg     [31:0]  pc_o;

always@(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        pc_o <= 32'b0;
    end
    else begin
        if (start_i)
            pc_o <= pc_i;
        else
            pc_o <= pc_o;
    end
end

endmodule