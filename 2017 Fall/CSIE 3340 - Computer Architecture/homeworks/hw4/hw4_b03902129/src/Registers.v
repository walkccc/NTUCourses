module Registers(
    clk_i,      // clk_i,
    RSaddr_i,   // inst[25:21],
    RTaddr_i,   // inst[20:16],
    RDaddr_i,   // MUX_RegDst.data_o,
    RDdata_i,   // ALU.data_o,
    RegWrite_i, // Control.RegWrite_o,
    RSdata_o,   // ALU.data1_i,
    RTdata_o,   // MUX_ALUSrc.data1_i
);

// Ports
input           clk_i;
input   [4:0]   RSaddr_i;
input   [4:0]   RTaddr_i;
input   [4:0]   RDaddr_i;
input   [31:0]  RDdata_i;
input           RegWrite_i;
output  [31:0]  RSdata_o; 
output  [31:0]  RTdata_o;

// Register File
reg     [31:0]  register[0:31];

// Read Data      
assign  RSdata_o = register[RSaddr_i];
assign  RTdata_o = register[RTaddr_i];

// Write Data   
always@(posedge clk_i) begin
    if (RegWrite_i)
        register[RDaddr_i] <= RDdata_i;
end
   
endmodule 
