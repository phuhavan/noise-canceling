module demux_1_5
#(
	parameter data_width = 32
)
(
	input [data_width-1:0] in0,
	input [2:0] sel,
	output [data_width-1:0] res0,res1,res2,res3,res4
);
	assign res0 = (sel==3'b000) ? in0 : 0;
	assign res1 = (sel==3'b001) ? in0 : 0;
	assign res2 = (sel==3'b010) ? in0 : 0;
	assign res3 = (sel==3'b011) ? in0 : 0;
	assign res4 = (sel==3'b100) ? in0 : 0;
	
endmodule
