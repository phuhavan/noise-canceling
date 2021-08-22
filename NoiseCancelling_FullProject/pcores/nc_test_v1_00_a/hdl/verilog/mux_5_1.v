module mux_5_1
#(
	parameter data_width = 32
)
(
	input	[data_width-1:0] in0,
	input	[data_width-1:0] in1,
	input	[data_width-1:0] in2,
	input	[data_width-1:0] in3,
	input	[data_width-1:0] in4,
	input	[2:0] sel,
	output	[data_width-1:0] result
);
	assign result = (sel==3'b000) ? in0 :
					(sel==3'b001) ? in1 :
					(sel==3'b010) ? in2 :
					(sel==3'b011) ? in3 :
					(sel==3'b100) ? in4 : {data_width{1'b0}};
endmodule
