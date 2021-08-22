module hanning_wd
#(parameter data_width = 32)
	(
    input clk,
    input rst_n,
    input start,
	input [6:0] index,
    input signed [data_width-1:0] data_in,
    output [data_width-1:0] data_out,
    output reg ready
    );
//---------------------------------------------------------------------------------
	reg shift_reg;
	reg [14:0]	shift_ctrl;
	reg [3:0]	count;
	wire shift;
	reg [data_width-1:0] data_loop;
	reg [data_width-1:0] data_add;
	reg [data_width-1:0] data_latch;
//---------------------------------------------------------------------------------
	wire [data_width-1:0] data_mux_1;
	wire [data_width-1:0] data_non_shift;
	wire [data_width-1:0] data_shift;
	wire [data_width-1:0]data_mux_2;
	
	wire [data_width-1:0] data_change_sign;
	reg sign_bit;
	reg [data_width-1:0] data_out_unsign;
	
	assign data_change_sign = (data_in[data_width-1] == 1'b1) ? (~(data_in)+1) : data_in;
	assign data_out = (sign_bit) ? (~(data_out_unsign)+1) : data_out_unsign;
	
	assign shift=(start|shift_reg);
	assign data_mux_1 = (start==1'b1) ? data_change_sign : data_loop;
	assign data_shift = (data_mux_1>>>1);
	//assign data_non_shift = data_mux_1;
	assign data_mux_2 = (shift_ctrl[13]==1'b1) ? data_shift : 32'b0;
	
	always @ (posedge clk) begin
		if(!rst_n) begin
			data_out_unsign <= 32'b0;
			ready <= 1'b0;
		end
		else begin
			if(count==4'd15) begin
				data_out_unsign <= data_add+data_latch;
				ready <= 1'b1;
			end
			if(ready == 1'b1) begin
				ready <= 1'b0;
			end
		end
	end
	
	always @ (posedge clk) begin
		if(ready || (!rst_n)) begin
			data_add <= 32'b0;
		end
		else begin
			data_add <= data_add+data_mux_2;
		end
	end
	
	always @ (posedge clk) begin
		if(!rst_n) begin
			data_loop<=32'b0;
		end
		else begin
			data_loop <= data_shift;
		end
	end
	
	always @ (posedge clk) begin
		if(rst_n == 1'b0) begin
			shift_reg<=1'b0;
		end
		else if(start == 1'b1) begin
			shift_reg <= 1'b1;
		end
		else if(count == 4'd15) begin
			shift_reg <= 1'b0;
		end
	end

	always @ (posedge clk) begin
		if(start) begin
			count<=4'b0;
		end
		else begin
			if(shift_reg == 1'b1) begin
				count<=count+4'b1;
			end
		end
	end
	always @ (posedge clk) begin
		if(rst_n == 1'b0) begin
			sign_bit<=0;
		end
		else if(start == 1'b1) begin
			sign_bit<=data_in[data_width-1];
		end
	end
	always @ (posedge clk) begin
		if(rst_n == 1'b0) begin
			shift_ctrl<=15'b0;
			data_latch<=0;
		end
		else begin
			if((start == 1'b1)&&(index==7'd65)) begin
				data_latch<=data_change_sign;
			end
			if(shift == 1'b1) begin
				shift_ctrl[14:0]<={shift_ctrl[13:0],1'b0};
			end
			else begin
				data_latch<=0;
				case(index)
				7'd0:shift_ctrl<=15'b000000000000000;
				7'd1:shift_ctrl<=15'b000000110010010;
				7'd2:shift_ctrl<=15'b000001100100011;
				7'd3:shift_ctrl<=15'b000010010110101;
				7'd4:shift_ctrl<=15'b000011001000101;
				7'd5:shift_ctrl<=15'b000011111010101;
				7'd6:shift_ctrl<=15'b000100101100100;
				7'd7:shift_ctrl<=15'b000101011110001;
				7'd8:shift_ctrl<=15'b000110001111100;
				7'd9:shift_ctrl<=15'b000111000000101;
				7'd10: shift_ctrl<=15'b000111110001100;
				7'd11: shift_ctrl<=15'b001000100010001;
				7'd12: shift_ctrl<=15'b001001010010100;
				7'd13: shift_ctrl<=15'b001010000010011;
				7'd14: shift_ctrl<=15'b001010110001111;
				7'd15: shift_ctrl<=15'b001011100001000;
				7'd16: shift_ctrl<=15'b001100001111101;
				7'd17: shift_ctrl<=15'b001100111101111;
				7'd18: shift_ctrl<=15'b001101101011101;
				7'd19: shift_ctrl<=15'b001110011000110;
				7'd20: shift_ctrl<=15'b001111000101011;
				7'd21: shift_ctrl<=15'b001111110001011;
				7'd22: shift_ctrl<=15'b010000011100111;
				7'd23: shift_ctrl<=15'b010001000111101;
				7'd24: shift_ctrl<=15'b010001110001110;
				7'd25: shift_ctrl<=15'b010010011011010;
				7'd26: shift_ctrl<=15'b010011000011111;
				7'd27: shift_ctrl<=15'b010011101011111;
				7'd28: shift_ctrl<=15'b010100010011001;
				7'd29: shift_ctrl<=15'b010100111001101;
				7'd30: shift_ctrl<=15'b010101011111010;
				7'd31: shift_ctrl<=15'b010110000100001;
				7'd32: shift_ctrl<=15'b010110101000001;
				7'd33: shift_ctrl<=15'b010111001011010;
				7'd34: shift_ctrl<=15'b010111101101011;
				7'd35: shift_ctrl<=15'b011000001110110;
				7'd36: shift_ctrl<=15'b011000101111001;
				7'd37: shift_ctrl<=15'b011001001110100;
				7'd38: shift_ctrl<=15'b011001101100111;
				7'd39: shift_ctrl<=15'b011010001010011;
				7'd40: shift_ctrl<=15'b011010100110110;
				7'd41: shift_ctrl<=15'b011011000010010;
				7'd42: shift_ctrl<=15'b011011011100101;
				7'd43: shift_ctrl<=15'b011011110101111;
				7'd44: shift_ctrl<=15'b011100001110001;
				7'd45: shift_ctrl<=15'b011100100101010;
				7'd46: shift_ctrl<=15'b011100111011010;
				7'd47: shift_ctrl<=15'b011101010000010;
				7'd48: shift_ctrl<=15'b011101100100000;
				7'd49: shift_ctrl<=15'b011101110110110;
				7'd50: shift_ctrl<=15'b011110001000010;
				7'd51: shift_ctrl<=15'b011110011000101;
				7'd52: shift_ctrl<=15'b011110100111110;
				7'd53: shift_ctrl<=15'b011110110101110;
				7'd54: shift_ctrl<=15'b011111000010100;
				7'd55: shift_ctrl<=15'b011111001110001;
				7'd56: shift_ctrl<=15'b011111011000101;
				7'd57: shift_ctrl<=15'b011111100001110;
				7'd58: shift_ctrl<=15'b011111101001110;
				7'd59: shift_ctrl<=15'b011111110000100;
				7'd60: shift_ctrl<=15'b011111110110001;
				7'd61: shift_ctrl<=15'b011111111010011;
				7'd62: shift_ctrl<=15'b011111111101100;
				7'd63: shift_ctrl<=15'b011111111111011;
				7'd64: begin
							shift_ctrl<=15'b100000000000000;
						end
				7'd65: shift_ctrl<=15'b011111111111011;
				7'd66: shift_ctrl<=15'b011111111101100;
				7'd67: shift_ctrl<=15'b011111111010011;
				7'd68: shift_ctrl<=15'b011111110110001;
				7'd69: shift_ctrl<=15'b011111110000100;
				7'd70: shift_ctrl<=15'b011111101001110;
				7'd71: shift_ctrl<=15'b011111100001110;
				7'd72: shift_ctrl<=15'b011111011000101;
				7'd73: shift_ctrl<=15'b011111001110001;
				7'd74: shift_ctrl<=15'b011111000010100;
				7'd75: shift_ctrl<=15'b011110110101110;
				7'd76: shift_ctrl<=15'b011110100111110;
				7'd77: shift_ctrl<=15'b011110011000101;
				7'd78: shift_ctrl<=15'b011110001000010;
				7'd79: shift_ctrl<=15'b011101110110110;
				7'd80: shift_ctrl<=15'b011101100100000;
				7'd81: shift_ctrl<=15'b011101010000010;
				7'd82: shift_ctrl<=15'b011100111011010;
				7'd83: shift_ctrl<=15'b011100100101010;
				7'd84: shift_ctrl<=15'b011100001110001;
				7'd85: shift_ctrl<=15'b011011110101111;
				7'd86: shift_ctrl<=15'b011011011100101;
				7'd87: shift_ctrl<=15'b011011000010010;
				7'd88: shift_ctrl<=15'b011010100110110;
				7'd89: shift_ctrl<=15'b011010001010011;
				7'd90: shift_ctrl<=15'b011001101100111;
				7'd91: shift_ctrl<=15'b011001001110100;
				7'd92: shift_ctrl<=15'b011000101111001;
				7'd93: shift_ctrl<=15'b011000001110110;
				7'd94: shift_ctrl<=15'b010111101101011;
				7'd95: shift_ctrl<=15'b010111001011010;
				7'd96: shift_ctrl<=15'b010110101000001;
				7'd97: shift_ctrl<=15'b010110000100001;
				7'd98: shift_ctrl<=15'b010101011111010;
				7'd99: shift_ctrl<=15'b010100111001101;
				7'd100:shift_ctrl<=15'b010100010011001;
				7'd101:shift_ctrl<=15'b010011101011111;
				7'd102:shift_ctrl<=15'b010011000011111;
				7'd103:shift_ctrl<=15'b010010011011010;
				7'd104:shift_ctrl<=15'b010001110001110;
				7'd105:shift_ctrl<=15'b010001000111101;
				7'd106:shift_ctrl<=15'b010000011100111;
				7'd107:shift_ctrl<=15'b001111110001011;
				7'd108:shift_ctrl<=15'b001111000101011;
				7'd109:shift_ctrl<=15'b001110011000110;
				7'd110:shift_ctrl<=15'b001101101011101;
				7'd111:shift_ctrl<=15'b001100111101111;
				7'd112:shift_ctrl<=15'b001100001111101;
				7'd113:shift_ctrl<=15'b001011100001000;
				7'd114:shift_ctrl<=15'b001010110001111;
				7'd115:shift_ctrl<=15'b001010000010011;
				7'd116:shift_ctrl<=15'b001001010010100;
				7'd117:shift_ctrl<=15'b001000100010001;
				7'd118:shift_ctrl<=15'b000111110001100;
				7'd119:shift_ctrl<=15'b000111000000101;
				7'd120:shift_ctrl<=15'b000110001111100;
				7'd121:shift_ctrl<=15'b000101011110001;
				7'd122:shift_ctrl<=15'b000100101100100;
				7'd123:shift_ctrl<=15'b000011111010101;
				7'd124:shift_ctrl<=15'b000011001000101;
				7'd125:shift_ctrl<=15'b000010010110101;
				7'd126:shift_ctrl<=15'b000001100100011;
				7'd127:shift_ctrl<=15'b000000110010010;
				default: shift_ctrl<=15'b0;
				endcase
			end
		end
	end
	
endmodule
