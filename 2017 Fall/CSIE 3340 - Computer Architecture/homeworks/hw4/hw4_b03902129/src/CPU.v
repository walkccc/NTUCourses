module CPU(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input   clk_i;
input   rst_i;
input   start_i;

wire[31:0]	inst_addr, inst;

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (MUX_RegDst.select_i),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .ALUSrc_o   (MUX_ALUSrc.select_i),
    .RegWrite_o (Registers.RegWrite_i)
);

Adder Add_PC(
    .data1_i    (inst_addr),
    .data2_i    (32'd4),
    .data_o     (PC.pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr),
    .instr_o    (inst)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MUX_RegDst.data_o),
    .RDdata_i   (ALU.data_o),
    .RegWrite_i (Control.RegWrite_o),
    .RSdata_o   (ALU.data1_i),
    .RTdata_o   (MUX_ALUSrc.data1_i)
);

MUX5 MUX_RegDst(
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (Control.RegDst_o),
    .data_o     (Registers.RDaddr_i)
);

MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RTdata_o),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     (ALU.data2_i)
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (MUX_ALUSrc.data2_i)
);
  
ALU ALU(
    .data1_i    (Registers.RSdata_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (Registers.RDdata_i),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

endmodule
