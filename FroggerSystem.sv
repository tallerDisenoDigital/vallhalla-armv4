 
module FroggerSystem #(bus = 32, memsize = 256) (input logic clk, reset, input logic [bus-1:0] keyboard_data, output logic [7:0] R,G,B);


	logic [bus-1:0]pcdir,instruction,memdatain,memdataout,memdir;
	logic MRE,MWE;
	
	processor #(bus) u_processor(clk,reset,instruction,memdatain,pcdir,memdataout,memdir,MRE,MWE);
	
	InstructionMemory #(bus, memsize, "instructions.txt") 
		instruction_memory(pcdir,instruction,clk,reset);

	
	DataMemory #(bus, 640*480) data_memory(memdataout,memdir,memdir,memdatain,clk,MRE,MWE);



endmodule

