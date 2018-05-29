module Aligner #(parameter bus = 32) (input logic [bus-1:0]a,output logic [bus-1:0] s);

	assign s = {a[bus-3:0],2'b00};

endmodule

