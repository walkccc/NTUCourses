`define CYCLE_TIME 50            

module TestBench;

reg         Clk;
reg         Start;
integer     i, outfile, counter;
integer     stall, flush;

always #(`CYCLE_TIME / 2) Clk = ~Clk;    

CPU CPU(
    .clk_i      (Clk),
    .start_i    (Start)
);
  
initial begin
    // $dumpfile("project.vcd");
    // $dumpvars;
    
    counter = 0;
    stall = 0;
    flush = 0;
    
    for (i = 0; i < 256; i = i + 1) begin CPU.Instruction_Memory.memory[i] = 32'b0; end
    for (i = 0; i < 32; i = i + 1)  begin CPU.Data_Memory.memory[i] = 8'b0; end    
    for (i = 0; i < 32; i = i + 1)  begin CPU.Registers.register[i] = 32'b0; end
    
    /*************************************/
    /********** IF/ID registers **********/
    /*************************************/
	CPU.IFID_pc			    <= 32'd0;
	CPU.IFID_inst 		    <= 32'd0;

    /**************************************/
    /**********	EX/MEM REGISTERS **********/
    /**************************************/
	CPU.IDEX_RegWrite	    <= 1'b0;			
	CPU.IDEX_MemtoReg	    <= 1'b0;			
	CPU.IDEX_MemWrite	    <= 1'b0;			
	CPU.IDEX_MemRead	    <= 1'b0;			
	CPU.IDEX_RegDst		    <= 1'b0;			
	CPU.IDEX_ALUOp		    <= 2'b00;			
	CPU.IDEX_ALUSrc		    <= 1'b0;			
	CPU.IDEX_pc			    <= 32'd0;
	CPU.IDEX_RSdata		    <= 32'd0;
	CPU.IDEX_RTdata		    <= 32'd0;
	CPU.IDEX_SignExtend		<= 32'd0;
	CPU.IDEX_inst		    <= 32'd0;
  
    /**************************************/
    /**********	EX/MEM REGISTERS **********/
    /**************************************/
	CPU.EXMEM_RegWrite	    <= 1'b0;			
	CPU.EXMEM_MemtoReg	    <= 1'b0;			
	CPU.EXMEM_MemWrite	    <= 1'b0;			
	CPU.EXMEM_MemRead	    <= 1'b0;			
	CPU.EXMEM_ALUResult	    <= 32'd0;
	CPU.EXMEM_WriteData	    <= 32'd0;
	CPU.MEMWB_RegisterRd	<= 5'd0;

    /**************************************/
    /**********	MEM/WB REGISTERS **********/
    /**************************************/
	CPU.MEMWB_RegWrite	    <= 1'b0;			
	CPU.MEMWB_MemtoReg	    <= 1'b0;			
	CPU.MEMWB_ReadData	    <= 32'd0;
	CPU.MEMWB_ALUResult	    <= 32'd0;
	CPU.MEMWB_RegisterRd    <= 5'd0;	

    // $readmemb("instruction.txt", CPU.Instruction_Memory.memory);
    $readmemb("Fibonacci_instruction.txt", CPU.Instruction_Memory.memory);
    outfile = $fopen("output.txt") | 1;
    
    // Set Input n into data memory at 0x00
    CPU.Data_Memory.memory[0] = 8'h7;       // n = 5 for example
    
    Clk = 1;
    Start = 0;
    
    #(`CYCLE_TIME / 4) 
    Start = 1;  
end
  
always@(posedge Clk) begin
    // if (counter == 30)      // stop after 30 cycles ("diff instruction_output.txt" is okay)
    if (counter == 100)      // stop after 64 cycles ("diff Fibonacci_output.txt output.txt" is okay)
        $stop;

    // put in your own signal to count stall and flush
    if (CPU.HazardDetection.stall_o && ~CPU.CtrlUnit[8] && ~CPU.CtrlUnit[9])	
        stall = 0 + 1;
    if (CPU.HazardDetection.flush_o == 2'b01) 
        flush = flush + 1;  
    
    // print cycle, start, stall, flush and PC
    $fdisplay(outfile, "cycle = %d, Start = %d, Stall = %1d, Flush = %1d", counter, Start, stall, flush);
    $fdisplay(outfile, "PC = %d", CPU.PC.pc_o);

    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0(r0) = %d, R8 (t0) = %d, R16(s0) = %d, R24(t8) = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "R1(at) = %d, R9 (t1) = %d, R17(s1) = %d, R25(t9) = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "R2(v0) = %d, R10(t2) = %d, R18(s2) = %d, R26(k0) = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "R3(v1) = %d, R11(t3) = %d, R19(s3) = %d, R27(k1) = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "R4(a0) = %d, R12(t4) = %d, R20(s4) = %d, R28(gp) = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "R5(a1) = %d, R13(t5) = %d, R21(s5) = %d, R29(sp) = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "R6(a2) = %d, R14(t6) = %d, R22(s6) = %d, R30(s8) = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "R7(a3) = %d, R15(t7) = %d, R23(s7) = %d, R31(ra) = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 = %d", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 = %d", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 = %d", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c = %d", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 = %d", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 = %d", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 = %d", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c = %d", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});
    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
end

endmodule