module fifo128_type4
#(
	parameter dwidth = 32
)
(
	//---Control signals
	input	clk, 
	input 	n_rst,
	input 	wr_ce,
	input 	rd_ce,
	//---Data in
	input	[dwidth-1:0]	data_in,
	//---Data out
	output	[dwidth-1:0]	data_out,
	//---Status signals
	output 	full,
	output 	empty,
	output	error
);
	
	//---FLIPFLOPs to store
	reg		[dwidth-1:0]	reg_file [63:0];
	
	reg 	full_reg, empty_reg, error_reg;
	reg		[6:0] count;

	//---Assign
	assign data_out = reg_file[0];
	assign full = full_reg;
	assign empty = empty_reg;
	assign error = error_reg;
	
	always @(posedge clk) begin
		if (!n_rst) begin
			// reset
			error_reg <= 1'b0;
			count <= 0;
			full_reg <= 1'b0;
			empty_reg <= 1'b0;
			reg_file[0] <= 32'b0;
			reg_file[1] <= 32'b0;
			reg_file[2] <= 32'b0;
			reg_file[3] <= 32'b0;
			reg_file[4] <= 32'b0;
			reg_file[5] <= 32'b0;
			reg_file[6] <= 32'b0;
			reg_file[7] <= 32'b0;
			reg_file[8] <= 32'b0;
			reg_file[9] <= 32'b0;
			reg_file[10] <= 32'b0;
			reg_file[11] <= 32'b0;
			reg_file[12] <= 32'b0;
			reg_file[13] <= 32'b0;
			reg_file[14] <= 32'b0;
			reg_file[15] <= 32'b0;
			reg_file[16] <= 32'b0;
			reg_file[17] <= 32'b0;
			reg_file[18] <= 32'b0;
			reg_file[19] <= 32'b0;
			reg_file[20] <= 32'b0;
			reg_file[21] <= 32'b0;
			reg_file[22] <= 32'b0;
			reg_file[23] <= 32'b0;
			reg_file[24] <= 32'b0;
			reg_file[25] <= 32'b0;
			reg_file[26] <= 32'b0;
			reg_file[27] <= 32'b0;
			reg_file[28] <= 32'b0;
			reg_file[29] <= 32'b0;
			reg_file[30] <= 32'b0;
			reg_file[31] <= 32'b0;
			reg_file[32] <= 32'b0;
			reg_file[33] <= 32'b0;
			reg_file[34] <= 32'b0;
			reg_file[35] <= 32'b0;
			reg_file[36] <= 32'b0;
			reg_file[37] <= 32'b0;
			reg_file[38] <= 32'b0;
			reg_file[39] <= 32'b0;
			reg_file[40] <= 32'b0;
			reg_file[41] <= 32'b0;
			reg_file[42] <= 32'b0;
			reg_file[43] <= 32'b0;
			reg_file[44] <= 32'b0;
			reg_file[45] <= 32'b0;
			reg_file[46] <= 32'b0;
			reg_file[47] <= 32'b0;
			reg_file[48] <= 32'b0;
			reg_file[49] <= 32'b0;
			reg_file[50] <= 32'b0;
			reg_file[51] <= 32'b0;
			reg_file[52] <= 32'b0;
			reg_file[53] <= 32'b0;
			reg_file[54] <= 32'b0;
			reg_file[55] <= 32'b0;
			reg_file[56] <= 32'b0;
			reg_file[57] <= 32'b0;
			reg_file[58] <= 32'b0;
			reg_file[59] <= 32'b0;
			reg_file[60] <= 32'b0;
			reg_file[61] <= 32'b0;
			reg_file[62] <= 32'b0;
			reg_file[63] <= 32'b0;
		end
		else begin
			if(count == 7'd64 && rd_ce == 0) full_reg <= 1'b1;
			else if (count > 7'd64) error_reg <= 1'b1;
			else begin
				full_reg <= 1'b0;
				error_reg <= 1'b0;
			end

			if (wr_ce && (!rd_ce)) begin
				reg_file[63] <= data_in;
				count <= count + 7'b1;
			end

			if (wr_ce || rd_ce) begin
				reg_file[62] <= reg_file[63];
				reg_file[61] <= reg_file[62];
				reg_file[60] <= reg_file[61];
				reg_file[59] <= reg_file[60];
				reg_file[58] <= reg_file[59];
				reg_file[57] <= reg_file[58];
				reg_file[56] <= reg_file[57];
				reg_file[55] <= reg_file[56];
				reg_file[54] <= reg_file[55];
				reg_file[53] <= reg_file[54];
				reg_file[52] <= reg_file[53];
				reg_file[51] <= reg_file[52];
				reg_file[50] <= reg_file[51];
				reg_file[49] <= reg_file[50];
				reg_file[48] <= reg_file[49];
				reg_file[47] <= reg_file[48];
				reg_file[46] <= reg_file[47];
				reg_file[45] <= reg_file[46];
				reg_file[44] <= reg_file[45];
				reg_file[43] <= reg_file[44];
				reg_file[42] <= reg_file[43];
				reg_file[41] <= reg_file[42];
				reg_file[40] <= reg_file[41];
				reg_file[39] <= reg_file[40];
				reg_file[38] <= reg_file[39];
				reg_file[37] <= reg_file[38];
				reg_file[36] <= reg_file[37];
				reg_file[35] <= reg_file[36];
				reg_file[34] <= reg_file[35];
				reg_file[33] <= reg_file[34];
				reg_file[32] <= reg_file[33];
				reg_file[31] <= reg_file[32];
				reg_file[30] <= reg_file[31];
				reg_file[29] <= reg_file[30];
				reg_file[28] <= reg_file[29];
				reg_file[27] <= reg_file[28];
				reg_file[26] <= reg_file[27];
				reg_file[25] <= reg_file[26];
				reg_file[24] <= reg_file[25];
				reg_file[23] <= reg_file[24];
				reg_file[22] <= reg_file[23];
				reg_file[21] <= reg_file[22];
				reg_file[20] <= reg_file[21];
				reg_file[19] <= reg_file[20];
				reg_file[18] <= reg_file[19];
				reg_file[17] <= reg_file[18];
				reg_file[16] <= reg_file[17];
				reg_file[15] <= reg_file[16];
				reg_file[14] <= reg_file[15];
				reg_file[13] <= reg_file[14];
				reg_file[12] <= reg_file[13];
				reg_file[11] <= reg_file[12];
				reg_file[10] <= reg_file[11];
				reg_file[9] <= reg_file[10];
				reg_file[8] <= reg_file[9];
				reg_file[7] <= reg_file[8];
				reg_file[6] <= reg_file[7];
				reg_file[5] <= reg_file[6];
				reg_file[4] <= reg_file[5];
				reg_file[3] <= reg_file[4];
				reg_file[2] <= reg_file[3];
				reg_file[1] <= reg_file[2];
				reg_file[0] <= reg_file[1];
			end
			if(rd_ce && (!wr_ce)) begin
				reg_file[63] <= {32{1'b0}};
				count <= count - 7'b1;
			end
		end
	end


endmodule
