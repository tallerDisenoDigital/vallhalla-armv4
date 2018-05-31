
module FroggerSystem_tb ();
	
	
	logic clk,reset;
	logic [31:0] keyboard_data;
	logic [7:0] R,G,B;
	integer i;
	
	FroggerSystem #(32, 256) _frogger(clk,reset,keyboard_data, R,G,B);
	
	initial begin
		clk = 1;
		reset = 1;
		#400 clk = ~clk;
		#400 clk = ~clk;
		#400 clk = ~clk;
		#400 clk = ~clk;
		#400 clk = ~clk;
		#400 clk = ~clk;
		#400 clk = ~clk;
		#100 reset = 0;
		#300 clk = ~clk;
		//#800 
		for (i = 0; i < 10000; i = i+1) begin:forloop
			#400 clk = ~clk;
		end
		//#40000;
	end
	/*
	always
		#400 clk = ~clk;
	*/

endmodule
