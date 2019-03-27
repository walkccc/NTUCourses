module dcache_top(
	clk_i, 
	rst_i,
	
	/************ Data Memory ************/	
	mem_data_i, 
	mem_ack_i, 	
	mem_data_o, 
	mem_addr_o, 	
	mem_enable_o, 
	mem_write_o, 
	
	/**************** CPU ****************/
	p1_data_i, 
	p1_addr_i, 	
	p1_MemRead_i, 
	p1_MemWrite_i, 
	p1_data_o, 
	p1_stall_o
);

	input				clk_i; 
	input				rst_i;

	/****** Data Memory interface ********/	
	input	[255:0]		mem_data_i; 
	input				mem_ack_i; 
	output	[255:0]		mem_data_o; 
	output	[31:0]		mem_addr_o; 	
	output				mem_enable_o; 
	output				mem_write_o; 
		
	/*********** Core interface **********/
	input	[31:0]		p1_data_i; 
	input	[31:0]		p1_addr_i; 	
	input				p1_MemRead_i; 
	input				p1_MemWrite_i; 

	output	[31:0]		p1_data_o; 
	output				p1_stall_o; 

	/*********** SRAM interface **********/
	wire	[4:0]		cache_sram_index;
	wire				cache_sram_enable;
	wire	[23:0]		cache_sram_tag;
	wire	[255:0]		cache_sram_data;
	wire				cache_sram_write;
	wire	[23:0]		sram_cache_tag;
	wire	[255:0]		sram_cache_data;

	/*************** Cache ***************/
	wire				sram_valid;
	wire				sram_dirty;

	/************* Controller ************/
	parameter 	STATE_IDLE = 3'h0,
				STATE_READMISS = 3'h1,
				STATE_READMISSOK = 3'h2,
				STATE_WRITEBACK	= 3'h3,
				STATE_MISS = 3'h4;

	reg		[2:0]		state;
	reg				  	mem_enable;
	reg					mem_write;
	reg					cache_we;
	wire				cache_dirty;
	reg					write_back;

	wire	[4:0]		p1_offset;
	wire	[4:0]		p1_index;
	wire	[21:0]		p1_tag;
	wire	[255:0]		r_hit_data;
	wire	[21:0]		sram_tag;
	wire				hit;
	wire				write_hit;
	wire				p1_req;
	reg		[255:0]		w_hit_data;
	reg		[31:0]		p1_data;

	/******** Project1 interface *********/
	assign 	p1_req     = p1_MemRead_i | p1_MemWrite_i;
	assign	p1_offset  = p1_addr_i[4:0];
	assign	p1_index   = p1_addr_i[9:5];
	assign	p1_tag     = p1_addr_i[31:10];
	assign	p1_stall_o = ~hit & p1_req;
	assign	p1_data_o  = p1_data; 

	/********** SRAM interface ***********/
	assign	sram_valid = sram_cache_tag[23];
	assign	sram_dirty = sram_cache_tag[22];
	assign	sram_tag   = sram_cache_tag[21:0];
	assign	cache_sram_index  = p1_index;
	assign	cache_sram_enable = p1_req;
	assign	cache_sram_write  = cache_we | write_hit;
	assign	cache_sram_tag    = {1'b1, cache_dirty, p1_tag};	
	assign	cache_sram_data   = (hit) ? w_hit_data : mem_data_i;

	/********* Memory interface **********/
	assign	mem_enable_o = mem_enable;
	assign	mem_addr_o   = (write_back) ? {sram_tag, p1_index, 5'b0} : {p1_tag, p1_index, 5'b0};
	assign	mem_data_o   = sram_cache_data;
	assign	mem_write_o  = mem_write;

	assign	write_hit    = hit & p1_MemWrite_i;
	assign	cache_dirty  = write_hit;

	/********** Tag comparator ***********/	
	/*** Add your code here! (hit=...?,  r_hit_data=...?) ***/  
	assign	{hit, r_hit_data} = (p1_req && sram_valid && (p1_tag == sram_cache_tag[21:0])) ? {1'b1, sram_cache_data} : {1'b0, 256'b0};
		
	/** read data :  256-bit to 32-bit ***/
	always@(p1_offset or r_hit_data) begin
		case (p1_offset)
			5'h00: p1_data <= r_hit_data[31:0];
			5'h04: p1_data <= r_hit_data[63:32];
			5'h08: p1_data <= r_hit_data[95:64];
			5'h0c: p1_data <= r_hit_data[127:96];
			5'h10: p1_data <= r_hit_data[159:128];
			5'h14: p1_data <= r_hit_data[191:160];
			5'h18: p1_data <= r_hit_data[223:192];
			5'h1c: p1_data <= r_hit_data[255:224];
			default p1_data <= 32'd0;
		endcase
	end

	/** write data :  32-bit to 256-bit **/
	always@(p1_offset or r_hit_data or p1_data_i) begin
		case (p1_offset)
			5'h00: w_hit_data <= {r_hit_data[255:32], p1_data_i};
			5'h04: w_hit_data <= {r_hit_data[255:64], p1_data_i, r_hit_data[31:0]};
			5'h08: w_hit_data <= {r_hit_data[255:96], p1_data_i, r_hit_data[63:0]};
			5'h0c: w_hit_data <= {r_hit_data[255:128], p1_data_i, r_hit_data[95:0]};
			5'h10: w_hit_data <= {r_hit_data[255:160], p1_data_i, r_hit_data[127:0]};
			5'h14: w_hit_data <= {r_hit_data[255:192], p1_data_i, r_hit_data[159:0]};
			5'h18: w_hit_data <= {r_hit_data[255:224], p1_data_i, r_hit_data[191:0]};
			5'h1c: w_hit_data <= {p1_data_i, r_hit_data[223:0]};
			default w_hit_data <= 256'b0;
		endcase
	end

	/************* Controller ************/
	always@(posedge clk_i or negedge rst_i) begin
		if(~rst_i) begin
			state      <= STATE_IDLE;
			mem_enable <= 1'b0;
			mem_write  <= 1'b0;
			cache_we   <= 1'b0; 
			write_back <= 1'b0;
		end
		else begin
			case (state)		
				STATE_IDLE: begin
					if (p1_req && !hit) begin	/*** wait for request ***/
						state <= STATE_MISS;
					end else begin
						state <= STATE_IDLE;
					end
				end
				STATE_MISS: begin
					if (sram_dirty) begin		/*** write back if dirty ***/
						/*** Add your code here! ***/ 
						mem_enable 	<= 1'b1;
						mem_write 	<= 1'b1;
						write_back 	<= 1'b1;
						state <= STATE_WRITEBACK;
					end else begin				/*** write allocate: write miss = read miss + write hit; read miss = read miss + read hit ***/
						/*** Add your code here! ***/
						mem_enable 	<= 1'b1;
						mem_write 	<= 1'b0;
						state 		<= STATE_READMISS;
					end
				end
				STATE_READMISS: begin
					if (mem_ack_i) begin		/*** wait for data memory acknowledge ***/	
						/*** Add your code here! ***/ 
						mem_enable 	<= 1'b0;
						cache_we 	<= 1'b1;
						state 		<= STATE_READMISSOK;
					end else begin
						state 		<= STATE_READMISS;
					end
				end
				STATE_READMISSOK: begin			/*** wait for data memory acknowledge ***/
						/*** Add your code here! ***/ 
					cache_we	 	<= 1'b0;
					state 			<= STATE_IDLE;
				end
				STATE_WRITEBACK: begin
					if (mem_ack_i) begin		/*** wait for data memory acknowledge ***/
						/*** Add your code here! ***/ 
						mem_write 	<= 1'b0;
						write_back 	<= 1'b0;
						state 		<= STATE_READMISS;
					end else begin
						state 		<= STATE_WRITEBACK;
					end
				end
			endcase
		end
	end

	/************* Tag SRAM 0 ************/
	dcache_tag_sram dcache_tag_sram(
		.clk_i			(clk_i),
		.addr_i			(cache_sram_index),
		.data_i			(cache_sram_tag),
		.enable_i		(cache_sram_enable),
		.write_i		(cache_sram_write),
		.data_o			(sram_cache_tag)
	);

	/************* Tag SRAM 0 ************/
	dcache_data_sram dcache_data_sram(
		.clk_i			(clk_i),
		.addr_i			(cache_sram_index),
		.data_i			(cache_sram_data),
		.enable_i		(cache_sram_enable),
		.write_i		(cache_sram_write),
		.data_o		(sram_cache_data)
	);

endmodule
