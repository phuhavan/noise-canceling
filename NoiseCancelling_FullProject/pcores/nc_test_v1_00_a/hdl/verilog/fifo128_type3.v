module fifo128_type3 
#(
	parameter dwidth = 32 // data width
)
(
	//---Control signals
	input clk,			// Clock
	input n_rst,		// Asynchronous reset active low
	input fft_edone, 	// finish FFT calculation 
	input wr_ce,
	input rd_ce,
	//---Data in	
	input	[dwidth-1:0] data_in,
	//---Data out
	output	reg [dwidth-1:0] data_out,
	//---Status signals
	output full,
	output reg ready,
	output error
);
	//--- Signal declaration: wire

	//--- Signal declaration: reg
	reg 	[dwidth-1:0]	reg_file [127:0];
	reg						full_reg, error_reg;
	reg 	[7:0]	count;
	//--- Signal assignment
	//assign data_out = reg_file[0];
	assign full = full_reg;
	assign error = error_reg;

	always @(posedge clk) begin
		if(!n_rst) begin
			ready <= 0;
		end else begin
			ready <= (rd_ce);
		end
	end

	always @(posedge clk) begin
		if(!n_rst) begin
			// reset
			full_reg <= 1'b0;
			error_reg <= 1'b0;
			count <= 8'b0;
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
			reg_file[64] <= 32'b0;
			reg_file[65] <= 32'b0;
			reg_file[66] <= 32'b0;
			reg_file[67] <= 32'b0;
			reg_file[68] <= 32'b0;
			reg_file[69] <= 32'b0;
			reg_file[70] <= 32'b0;
			reg_file[71] <= 32'b0;
			reg_file[72] <= 32'b0;
			reg_file[73] <= 32'b0;
			reg_file[74] <= 32'b0;
			reg_file[75] <= 32'b0;
			reg_file[76] <= 32'b0;
			reg_file[77] <= 32'b0;
			reg_file[78] <= 32'b0;
			reg_file[79] <= 32'b0;
			reg_file[80] <= 32'b0;
			reg_file[81] <= 32'b0;
			reg_file[82] <= 32'b0;
			reg_file[83] <= 32'b0;
			reg_file[84] <= 32'b0;
			reg_file[85] <= 32'b0;
			reg_file[86] <= 32'b0;
			reg_file[87] <= 32'b0;
			reg_file[88] <= 32'b0;
			reg_file[89] <= 32'b0;
			reg_file[90] <= 32'b0;
			reg_file[91] <= 32'b0;
			reg_file[92] <= 32'b0;
			reg_file[93] <= 32'b0;
			reg_file[94] <= 32'b0;
			reg_file[95] <= 32'b0;
			reg_file[96] <= 32'b0;
			reg_file[97] <= 32'b0;
			reg_file[98] <= 32'b0;
			reg_file[99] <= 32'b0;
			reg_file[100] <= 32'b0;
			reg_file[101] <= 32'b0;
			reg_file[102] <= 32'b0;
			reg_file[103] <= 32'b0;
			reg_file[104] <= 32'b0;
			reg_file[105] <= 32'b0;
			reg_file[106] <= 32'b0;
			reg_file[107] <= 32'b0;
			reg_file[108] <= 32'b0;
			reg_file[109] <= 32'b0;
			reg_file[110] <= 32'b0;
			reg_file[111] <= 32'b0;
			reg_file[112] <= 32'b0;
			reg_file[113] <= 32'b0;
			reg_file[114] <= 32'b0;
			reg_file[115] <= 32'b0;
			reg_file[116] <= 32'b0;
			reg_file[117] <= 32'b0;
			reg_file[118] <= 32'b0;
			reg_file[119] <= 32'b0;
			reg_file[120] <= 32'b0;
			reg_file[121] <= 32'b0;
			reg_file[122] <= 32'b0;
			reg_file[123] <= 32'b0;
			reg_file[124] <= 32'b0;
			reg_file[125] <= 32'b0;
			reg_file[126] <= 32'b0;
			reg_file[127] <= 32'b0;
			data_out <= 0;
		end 
		else begin
			if(count == 8'd128) begin
				full_reg <= 1'b1;
			end
			else if(count > 8'd128) begin
				error_reg <= 1'b1;
			end
			else begin
				full_reg <= 1'b0;
				error_reg <= 1'b0;
			end

			if((fft_edone && (!wr_ce) && (!rd_ce)) || (count == 8'd128)) begin
				count <= 8'b0;
			end
			if ((!fft_edone) && wr_ce && (!rd_ce)) begin
				reg_file[127] <= data_in;
				count <= count + 8'b1;
				data_out <= 0;
			end

			if ((!fft_edone) && wr_ce || rd_ce) begin
				reg_file[126] <= reg_file[127];
				reg_file[125] <= reg_file[126];
				reg_file[124] <= reg_file[125];
				reg_file[123] <= reg_file[124];
				reg_file[122] <= reg_file[123];
				reg_file[121] <= reg_file[122];
				reg_file[120] <= reg_file[121];
				reg_file[119] <= reg_file[120];
				reg_file[118] <= reg_file[119];
				reg_file[117] <= reg_file[118];
				reg_file[116] <= reg_file[117];
				reg_file[115] <= reg_file[116];
				reg_file[114] <= reg_file[115];
				reg_file[113] <= reg_file[114];
				reg_file[112] <= reg_file[113];
				reg_file[111] <= reg_file[112];
				reg_file[110] <= reg_file[111];
				reg_file[109] <= reg_file[110];
				reg_file[108] <= reg_file[109];
				reg_file[107] <= reg_file[108];
				reg_file[106] <= reg_file[107];
				reg_file[105] <= reg_file[106];
				reg_file[104] <= reg_file[105];
				reg_file[103] <= reg_file[104];
				reg_file[102] <= reg_file[103];
				reg_file[101] <= reg_file[102];
				reg_file[100] <= reg_file[101];
				reg_file[99] <= reg_file[100];
				reg_file[98] <= reg_file[99];
				reg_file[97] <= reg_file[98];
				reg_file[96] <= reg_file[97];
				reg_file[95] <= reg_file[96];
				reg_file[94] <= reg_file[95];
				reg_file[93] <= reg_file[94];
				reg_file[92] <= reg_file[93];
				reg_file[91] <= reg_file[92];
				reg_file[90] <= reg_file[91];
				reg_file[89] <= reg_file[90];
				reg_file[88] <= reg_file[89];
				reg_file[87] <= reg_file[88];
				reg_file[86] <= reg_file[87];
				reg_file[85] <= reg_file[86];
				reg_file[84] <= reg_file[85];
				reg_file[83] <= reg_file[84];
				reg_file[82] <= reg_file[83];
				reg_file[81] <= reg_file[82];
				reg_file[80] <= reg_file[81];
				reg_file[79] <= reg_file[80];
				reg_file[78] <= reg_file[79];
				reg_file[77] <= reg_file[78];
				reg_file[76] <= reg_file[77];
				reg_file[75] <= reg_file[76];
				reg_file[74] <= reg_file[75];
				reg_file[73] <= reg_file[74];
				reg_file[72] <= reg_file[73];
				reg_file[71] <= reg_file[72];
				reg_file[70] <= reg_file[71];
				reg_file[69] <= reg_file[70];
				reg_file[68] <= reg_file[69];
				reg_file[67] <= reg_file[68];
				reg_file[66] <= reg_file[67];
				reg_file[65] <= reg_file[66];
				reg_file[64] <= reg_file[65];
				reg_file[63] <= reg_file[64];
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
			if((!fft_edone) && rd_ce && (!wr_ce)) begin
				reg_file[127] <= {32{1'b0}};
				data_out <= reg_file[0];
			end
		end
	end



endmodule