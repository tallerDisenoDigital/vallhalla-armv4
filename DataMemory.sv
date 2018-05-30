//4*1024 = 16K of memory
module DataMemory #(parameter bus = 32, parameter memsize = 1024*4) 
(input logic [bus-1:0]datain,writedir,readdir,output logic [bus-1:0]dataout,input clk, MRE,MWE);


	logic [bus-1:0] my_memory [0:memsize-1];
	
	always @(posedge clk) begin
	if (MRE == 1'b1) begin
		dataout <= my_memory[readdir];
	end
	end
	
	always @(negedge clk) begin
	if (MWE == 1'b1) begin
		my_memory[writedir] <= datain;
	end
	end


endmodule
