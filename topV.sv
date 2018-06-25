module topV (
    input logic clk, rst, input logic[31:0] datain,
    output logic[7:0] r, g, b,
	 output logic o_hs, o_vs, o_sync, o_blank, o_clk,output logic [31:0] dir);
	 
	 logic [9:0] x, y;
	 
	 frequencyDivider ffd(clk, rst, o_clk);
	 
	 vgaController v0(o_clk, rst, o_hs, o_vs, o_sync, o_blank, x, y);
	 
	 assign r = datain[31:24];
	 assign g = datain[15:8];
	 assign b = datain[7:0];
	 logic [9:0] y0,x0;
	 assign y0 = {7'b0000000,y[8:6]};
	 assign x0 = {7'b0000000,x[9:7]};
	 assign dir = {12'd0,y0,x0[2:0],2'b00};
	 //assign dir = 32'b00000000000000000000000000000000;
	 
endmodule

