module demux_1_3
#(
	parameter data_width = 32
)
(
	input [data_width-1:0] in0,
	input [1:0] sel,
	output [data_width-1:0] res0,res1,res2
);
	assign res0 = (sel==2'b00) ? in0 : 0;
	assign res1 = (sel==2'b01) ? in0 : 0;
	assign res2 = (sel==2'b10) ? in0 : 0;
	
endmodule
