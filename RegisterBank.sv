module RegisterBank #(parameter dir = 4, bus = 2**(dir+1), reg_num = 2**dir) 
	(input logic[dir-1:0]da,db,dc,address,input logic[bus-1:0] write_data,pc_in,input logic clk,WE,RE,
	output logic [bus-1:0] doa,dob,doc,pc_out);

	logic [bus-1:0] my_memory [0:reg_num-1];
	
	integer i;

	initial begin
	$readmemb("mem.txt",my_memory);
	end
	

	//always_ff is not used because the book recomends not to use flip-flops
	//SRAMs are more compact than flipflops
	always @(posedge clk) begin
	// Use RE to indicate a valid address is on the line and read the memory into a register at that address 
	// when RE is asserted
	if (RE == 1'b1) begin
		doa <= my_memory[da];
		dob <= my_memory[db];
		doc <= my_memory[dc];
	end
	pc_out <= my_memory[15];
	end
	
	
	always @(negedge clk) begin
	if (WE == 1'b1) begin
		my_memory[address] <= write_data;
	end
	my_memory[15] <= pc_in;
	end

endmodule
