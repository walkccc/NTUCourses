/******************************************************************/
/*** Computer Architecture 2017 Fall ******************************/
/*** National Taiwan University ***********************************/
/*** Department of Computer Science and Information Engineering ***/
/*** Final project2 : pipeline CPU with L1 cache implementation ***/
/******************************************************************/

module CPU(
    clk_i,
	rst_i,
    start_i,

	mem_data_i, 
	mem_ack_i, 	
	mem_data_o, 
	mem_addr_o, 	
	mem_enable_o, 
	mem_write_o
);

	input				clk_i;
	input				start_i;
    input               rst_i;

    /*************** cache ***************/
    input   [255:0]     mem_data_i;
    input               mem_ack_i;
    output  [255:0]     mem_data_o;
    output  [31:0]      mem_addr_o;
    output              mem_enable_o;
    output              mem_write_o;

	wire    			zero, isEqual;
	wire				stall, cache_stall;
	wire 	[1:0]		flush;							/*** 00: stall, 01: flush, 10: read new address */
	wire	[4:0]		RegisterRd;
	wire	[31:0]  	instAddr, inst, instAddrAdded, JumpAddr;
	wire	[31:0]		newPC, RegWriteData, tmpCtrlUnit, CtrlUnit;
	wire	[31:0]		tmpALUdata2, RSdata, RTdata, RS_data, RT_data;
	wire	[31:0]  	SignExtend,	ALUResult, MemResult;
	
	/********** IF/ID registers **********/
	reg		[31:0]		IFID_pc;
	reg		[31:0]		IFID_inst;

	/**********	ID/EX registers **********/
	reg					IDEX_RegWrite;				
	reg					IDEX_MemtoReg;	
	reg					IDEX_Branch;
	reg					IDEX_MemRead;			
	reg					IDEX_MemWrite;	
	reg					IDEX_RegDst;				
	reg		[1:0]		IDEX_ALUOp;					
	reg					IDEX_ALUSrc;

	reg		[31:0]		IDEX_pc;
	reg		[31:0]		IDEX_RSdata;
	reg		[31:0]		IDEX_RTdata;
	reg		[31:0]		IDEX_SignExtend;
	reg		[31:0]		IDEX_inst;
  
	/**********	EX/MEM registers **********/
	reg					EXMEM_RegWrite;				
	reg					EXMEM_MemtoReg;				
	reg					EXMEM_Branch;
	reg					EXMEM_MemRead;
	reg					EXMEM_MemWrite;				

	reg		[31:0]		EXMEM_ALUResult;			
	reg		[31:0]		EXMEM_WriteData;
	reg		[4:0]		EXMEM_RegisterRd;

	/**********	MEM/WB registers **********/
	reg					MEMWB_RegWrite;				
	reg					MEMWB_MemtoReg;

	reg		[31:0]		MEMWB_ReadData;
	reg		[31:0]		MEMWB_ALUResult;
	reg		[4:0]		MEMWB_RegisterRd;

	/**************************************/
	/**************	IF stage **************/
	/**************************************/
	Instruction_Memory Instruction_Memory(
		.addr_i     	(instAddr), 
		.instr_o    	(inst)  
	);

	PC PC(
		.clk_i      	(clk_i),
		.rst_i			(rst_i),
		.start_i    	(start_i),
		.hazard_i		(HD.pc_hazard_o),
		.cache_stall_i	(cache_stall),
		.pc_i       	(MUX_Jump.data_o),
		.pc_o       	(instAddr)
	);

	Adder Add_PC(
		.data1_i		(instAddr),
		.data2_i		(32'd4),
		.data_o     	(instAddrAdded)
	);

	MUX32 MUX_Branch(
		.data1_i    	(instAddrAdded),
		.data2_i    	(ADD.data_o),
		.select_i   	(CtrlUnit[8] & isEqual),
		.data_o     	(newPC)
	);

	MUX32 MUX_Jump(
		.data1_i    	(newPC),
		.data2_i    	({newPC[31:28], JumpAddr[27:0]}), 
		.select_i   	(CtrlUnit[9]),
		.data_o     	(PC.pc_i)
	);

	/**************************************/
	/**************	ID stage **************/
	/**************************************/
	Registers Registers(
		.clk_i      	(clk_i),
		.RSaddr_i   	(IFID_inst[25:21]),
		.RTaddr_i   	(IFID_inst[20:16]),
		.RDaddr_i   	(MEMWB_RegisterRd), 
		.RDdata_i   	(RegWriteData),
		.RegWrite_i 	(MEMWB_RegWrite), 
		.RSdata_o   	(RS_data), 
		.RTdata_o   	(RT_data) 
	);
	
	Adder ADD(
		.data1_i		(ShiftLeft2.data_o),
		.data2_i		(IFID_pc),
		.data_o			(MUX_Branch.data2_i)
	);

	ShiftJump ShiftJump( 				
		.data_i			(IFID_inst[25:0]),
		.data_o			(JumpAddr[27:0])
	);

	ShiftLeft2 ShiftLeft2(
		.data_i			(SignExtend),
		.data_o			(ADD.data1_i)
	);

	Sign_Extend Sign_Extend(
		.data_i     	(IFID_inst[15:0]),
		.data_o     	(SignExtend)
	);

	Equal Equal(		 					
		.data1_i		(RSdata),
		.data2_i		(RTdata),
		.data_o			(isEqual)
	);

	Control Control(						
		.op_i       	(IFID_inst[31:26]),
		.control_o		(tmpCtrlUnit)
	);

	MUX32 MUX_CtrlUnit( 							
		.data1_i		(tmpCtrlUnit),
		.data2_i		(32'd0),
		.select_i		(stall),
		.data_o			(CtrlUnit)
	);

	MUX32 MUX_RS(
		.data1_i		(RS_data),
		.data2_i		(RegWriteData),
		.select_i		(FW.RSselect_o),
		.data_o			(RSdata)
	);

	MUX32 MUX_RT(
		.data1_i		(RT_data),
		.data2_i		(RegWriteData),
		.select_i		(FW.RTselect_o),
		.data_o			(RTdata)
	);

	HD HD( 									
		.IFID_Rs_i		(IFID_inst[25:21]),
		.IFID_Rt_i		(IFID_inst[20:16]),
		.IDEX_Rt_i		(RegisterRd),
		.RegWrite_i		(IDEX_RegWrite),
		.MemRead_i		(IDEX_MemRead),
		.Jump_i			(CtrlUnit[9]),
		.Branch_i		(CtrlUnit[8] & isEqual),
		.Equal_i		(CtrlUnit[8]),
		.stall_o		(stall),
		.flush_o		(flush),
		.pc_hazard_o	(PC.hazard_i)
	);

	/**************************************/
	/**************	EX stage **************/
	/**************************************/
	ALU ALU( 							
		.data1_i    	(MUX_ForwardA.data_o),
		.data2_i    	(MUX_ALUSrc2.data_o),
		.ALUCtrl_i  	(ALU_Control.ALUCtrl_o),	
		.data_o     	(ALUResult),
		.zero_o     	(zero)
	);

	ALU_Control ALU_Control(
		.funct_i    	(IDEX_inst[5:0]),
		.ALUOp_i    	(IDEX_ALUOp),
		.ALUCtrl_o  	(ALU.ALUCtrl_i)	
	);

	MUX5 MUX_RegisterRd(
		.data1_i		(IDEX_inst[20:16]),
		.data2_i		(IDEX_inst[15:11]),
		.select_i		(IDEX_RegDst),
		.data_o			(RegisterRd)
	);
	
	MUX32 MUX_ALUSrc2(
		.data1_i		(tmpALUdata2),
		.data2_i		(IDEX_SignExtend),
		.select_i		(IDEX_ALUSrc),
		.data_o			(ALU.data2_i)
	);
	
	MUX_Forward MUX_ForwardA( 						
		.data1_i		(IDEX_RSdata),
		.data2_i		(RegWriteData),
		.data3_i		(EXMEM_ALUResult),
		.select_i		(FW.ForwardA_o),
		.data_o			(ALU.data1_i)
	);

	MUX_Forward MUX_ForwardB(
		.data1_i		(IDEX_RTdata),
		.data2_i		(RegWriteData),
		.data3_i		(EXMEM_ALUResult),
		.select_i		(FW.ForwardB_o),
		.data_o			(tmpALUdata2)
	);

	FW FW( 								
		.EXMEM_Rd_i		(EXMEM_RegisterRd),
		.EXMEM_RegWr_i	(EXMEM_RegWrite),
		.MEMWB_Rd_i		(MEMWB_RegisterRd),
		.MEMWB_RegWr_i	(MEMWB_RegWrite),
		.IDEX_Rs_i		(IDEX_inst[25:21]),
		.IDEX_Rt_i		(IDEX_inst[20:16]),
		.IFID_Rs_i		(IFID_inst[25:21]),
		.IFID_Rt_i		(IFID_inst[20:16]),
		.ForwardA_o		(MUX_ForwardA.select_i),
		.ForwardB_o		(MUX_ForwardB.select_i),
		.RSselect_o		(MUX_RS.select_i),
		.RTselect_o		(MUX_RT.select_i)
	);

	/**************************************/
	/************* MEM stage **************/
	/**************************************/
    dcache_top dcache(
        .clk_i			(clk_i), 
        .rst_i          (rst_i),
	
	    /************ Data Memory ************/
        .mem_data_i     (mem_data_i), 
        .mem_ack_i      (mem_ack_i), 	
        .mem_data_o     (mem_data_o), 
        .mem_addr_o     (mem_addr_o), 	
        .mem_enable_o   (mem_enable_o), 
        .mem_write_o    (mem_write_o), 
        
        /**************** CPU ****************/
        .p1_data_i      (EXMEM_WriteData), 
        .p1_addr_i      (EXMEM_ALUResult), 	
        .p1_MemRead_i   (EXMEM_MemRead), 
        .p1_MemWrite_i  (EXMEM_MemWrite), 
        .p1_data_o      (MemResult),
        .p1_stall_o     (cache_stall)
    );

	/**************************************/
	/**************	WB stage **************/
	/**************************************/
	MUX32 MUX_RegWriteData(
		.data1_i		(MEMWB_ALUResult),
		.data2_i		(MEMWB_ReadData),
		.select_i		(MEMWB_MemtoReg),
		.data_o			(RegWriteData)
	);

	always @(posedge clk_i) begin
		if (cache_stall == 1'b1) begin
			MEMWB_RegWrite		<= 1'b0;
			MEMWB_MemtoReg		<= 1'b0;
			MEMWB_ReadData		<= 32'b0;
			MEMWB_ALUResult		<= 32'b0;
			MEMWB_RegisterRd	<= 5'b0;	
	end else begin
            /********** IF/ID registers **********/
            if (flush == 2'b01) begin 					/*** flush ******/
                IFID_inst 	    <= 32'd0;	
            end else if (flush == 2'b10) begin			/*** read new ***/
                IFID_pc	   	 	<= instAddrAdded;
                IFID_inst	    <= inst;
            end

            /********** ID/EX registers **********/
			IDEX_RegWrite		<= CtrlUnit[0];
			IDEX_MemtoReg		<= CtrlUnit[1];
			IDEX_Branch			<= CtrlUnit[8];
			IDEX_MemWrite		<= CtrlUnit[2];
			IDEX_MemRead		<= CtrlUnit[3];
			IDEX_RegDst			<= CtrlUnit[4];
			IDEX_ALUOp			<= CtrlUnit[6:5];
			IDEX_ALUSrc			<= CtrlUnit[7];
			IDEX_pc				<= IFID_pc;
			IDEX_RSdata			<= RSdata;
			IDEX_RTdata			<= RTdata;
			IDEX_SignExtend		<= SignExtend;

			if (stall == 1'b0) begin
				IDEX_inst		<= IFID_inst;
			end else begin
				IDEX_inst		<= 32'h00000000;
			end
		
            /********** EX/MEM registers **********/
            EXMEM_RegWrite	    <= IDEX_RegWrite;
            EXMEM_MemtoReg	    <= IDEX_MemtoReg;
            EXMEM_Branch		<= IDEX_Branch;
            EXMEM_MemRead	    <= IDEX_MemRead;
            EXMEM_MemWrite	    <= IDEX_MemWrite;
            EXMEM_ALUResult	    <= ALUResult;
            EXMEM_WriteData	    <= tmpALUdata2;
            EXMEM_RegisterRd    <= RegisterRd;

            /********** MEM/WB registers **********/
            MEMWB_RegWrite	    <= EXMEM_RegWrite;
            MEMWB_MemtoReg	    <= EXMEM_MemtoReg;
            MEMWB_ReadData	    <= MemResult;
            MEMWB_ALUResult	    <= EXMEM_ALUResult;
            MEMWB_RegisterRd    <= EXMEM_RegisterRd;		
		end
	end

endmodule

