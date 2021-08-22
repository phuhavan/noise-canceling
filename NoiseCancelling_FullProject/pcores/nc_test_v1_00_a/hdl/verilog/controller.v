module controller
(
	//---input signal
	input 	clk, n_rst,
	input 	[3:0] wr_ce,
	input	[4:0] rd_ce,
	input 	ready_c1a,
	input 	ready_c1b,
	input 	ready_c2a,
	input 	ready_c2b,
	input 	ready_nc_re,
	input 	ready_nc_im,

	input	fft_edone,

	input	full_ifft_odd,
	input	full_ifft_even,
	input	ready_hn_odd,
	input	ready_hn_even,

	output 	reg start_ifft_odd,
	output	reg start_ifft_even,
	output 	[6:0] index_hn_odd,
	output 	[6:0] index_hn_even,

	//---output signal
	output	reg start_hn_c1,
	output	reg	start_hn_c2,

	output	[6:0] index_hn_c1a,
	output	[6:0] index_hn_c1b,
	output	[6:0] index_hn_c2a,
	output	[6:0] index_hn_c2b,

	output	reg start_fft_c1a,
	output	reg start_fft_c1b,
	output	reg start_fft_c2a,
	output	reg start_fft_c2b,
	output	reg start_fft_nc_re,
	output	reg start_fft_nc_im,

	output	reg [2:0] mux_ctrl,
	output 	reg [1:0] dmux_ctrl2,
	output	reg [1:0] dmux_ctrl1
);
//--- signal declaration: reg
	reg fft_mode;
	reg [6:0] count_hn_c1a;	// using for hanning module
	reg [6:0] count_hn_c1b;	// using for hanning module,delay 64
	reg [6:0] count_hn_c2a;	// using for hanning module
	reg [6:0] count_hn_c2b;	// using for hanning module,delay 64

	reg [6:0] count_hn_odd;
	reg	[6:0] count_hn_odd_delay;
	reg [6:0] count_hn_even;
	reg [6:0] count_hn_even_delay;

	reg overlap_mode; 

	reg [5:0] count_64;

	reg odd;
//--- signal declaration: wire
	wire start_odd, start_even;


	assign index_hn_c1a = count_hn_c1a;
	assign index_hn_c1b = count_hn_c1b;
	assign index_hn_c2a = count_hn_c2a;
	assign index_hn_c2b = count_hn_c2b;

	assign index_hn_odd = count_hn_odd;
	assign index_hn_even = count_hn_even;
	
	assign start_odd = ((ready_hn_odd|ready_hn_even) & overlap_mode);
	assign start_even = ((ready_hn_odd|ready_hn_even) & overlap_mode); // dieu khien theo odd

	// assign start_ifft_odd = ((ready_hn_odd|ready_hn_even) & overlap_mode );
	// assign start_ifft_even = ((ready_hn_odd|ready_hn_even) & overlap_mode); // dieu khien theo odd

	always @(posedge clk) begin 
		if(!n_rst) begin
			start_ifft_odd <= 0;
			start_ifft_even <= 0;
		end 
		else begin
			start_ifft_odd <= ((ready_hn_odd|ready_hn_even) & overlap_mode) | (full_ifft_odd | full_ifft_even);
			start_ifft_even <= ((ready_hn_odd|ready_hn_even) & overlap_mode) | (full_ifft_odd | full_ifft_even);
		end
	end


	always @(posedge clk) begin
		if(!n_rst) begin
			count_64 <= 6'b0;
		end 
		else begin
			if(ready_hn_odd == 1'b1) count_64 <= count_64 + 6'b1;
			else count_64 <= count_64;
		end
	end

	always @(posedge clk) begin 
		if(!n_rst) begin 
			overlap_mode <= 1'b0;
		end
		else begin 
			if(full_ifft_even || full_ifft_odd) begin 
				overlap_mode <= 1'b1;
			end
			else begin
				overlap_mode <= overlap_mode;
			end

			if(count_64 == 6'd63) begin
				overlap_mode <= 1'b0;
			end
		end
	end

//---------------------------------------------------------
// process: Hanning Window c1
//---------------------------------------------------------
	
	always @(posedge clk) begin 
		if(!n_rst) begin
			count_hn_c1a <= 7'b0;
			count_hn_c1b <= 7'd64;
			start_hn_c1 <= 1'b0;
		end 
		else begin
			start_hn_c1 <= wr_ce[3];
			if(wr_ce[3] == 1'b1) begin 
				count_hn_c1a <= count_hn_c1a + 7'b1;
				count_hn_c1b <= count_hn_c1b + 7'b1;
			end
		end
	end

//---------------------------------------------------------
// process: Hanning Window c2
//---------------------------------------------------------
	
	always @(posedge clk) begin 
		if(!n_rst) begin
			count_hn_c2a <= 7'b0;
			count_hn_c2b <= 7'd64;
			start_hn_c2 <= 1'b0;
		end 
		else begin
			start_hn_c2 <= wr_ce[2];
			if(wr_ce[2] == 1'b1) begin 
				count_hn_c2a <= count_hn_c2a + 7'b1;
				count_hn_c2b <= count_hn_c2b + 7'b1;
			end
		end
	end

//---------------------------------------------------------
// process: Hanning Window recover: odd
//---------------------------------------------------------
	
	always @(posedge clk) begin 
		if(!n_rst) begin
			count_hn_odd <= 7'b0;
			count_hn_odd_delay <= 7'b0;
		end 
		else begin
			count_hn_odd_delay <= count_hn_odd;
			if(start_odd == 1'b1) begin 
				count_hn_odd <= count_hn_odd + 7'b1;
			end
			if(count_hn_odd == 7'd127) count_hn_odd <= 0;
			if(count_hn_odd_delay == 7'd63) count_hn_odd <= 7'd64;
		end
	end

//---------------------------------------------------------
// process: Hanning Window recover: even
//---------------------------------------------------------
	
	always @(posedge clk) begin 
		if(!n_rst) begin
			count_hn_even <= 7'd64;
			count_hn_even_delay <= 7'd64;
		end 
		else begin
			count_hn_even_delay <= count_hn_even;
			if(start_even == 1'b1) begin 
				count_hn_even <= count_hn_even + 7'b1;
			end
			if(count_hn_even == 7'd127) count_hn_even <= 0;
			if(count_hn_even_delay == 7'd63) count_hn_even <= 7'd64;
		end
	end

//---------------------------------------------------------
// process fifo c1a
//---------------------------------------------------------
	always @(posedge clk) begin
		if (!n_rst) begin
			start_fft_c1a <= 1'b0;			
		end
		else begin
			if ((ready_c1a == 1'b1) && (mux_ctrl == 3'b000)) begin
				start_fft_c1a <= 1'b1;
			end
			if(start_fft_c1a == 1'b1) begin
				start_fft_c1a <= 1'b0;
			end
		end
	end
//---------------------------------------------------------
// process fifo c1b
//---------------------------------------------------------
	always @(posedge clk) begin
		if (!n_rst) begin
			start_fft_c1b <= 1'b0;			
		end
		else begin
			if ((ready_c1b == 1'b1) && (mux_ctrl == 3'b001)) begin
				start_fft_c1b <= 1'b1;
			end
			if(start_fft_c1b == 1'b1) begin
				start_fft_c1b <= 1'b0;
			end
		end
	end
//---------------------------------------------------------
// process fifo c2a
//---------------------------------------------------------
	always @(posedge clk) begin
		if (!n_rst) begin
			start_fft_c2a <= 1'b0;			
		end
		else begin
			if ((ready_c2a == 1'b1) && (fft_edone == 1'b1)) begin
				start_fft_c2a <= 1'b1;
			end
			if(start_fft_c2a == 1'b1) begin
				start_fft_c2a <= 1'b0;
			end
		end
	end
//---------------------------------------------------------
// process fifo c2b
//---------------------------------------------------------
	always @(posedge clk) begin
		if (!n_rst) begin
			start_fft_c2b <= 1'b0;			
		end
		else begin
			if ((ready_c2b == 1'b1) && (fft_edone == 1'b1))begin
				start_fft_c2b <= 1'b1;
			end
			if(start_fft_c2b == 1'b1) begin
				start_fft_c2b <= 1'b0;
			end
		end
	end
//---------------------------------------------------------
// process fifo nc_re
//---------------------------------------------------------
	always @(posedge clk) begin
		if (!n_rst) begin
			start_fft_nc_re <= 1'b0;			
		end
		else begin
			if ((ready_nc_re == 1'b1) && (mux_ctrl == 3'b100)) begin
				start_fft_nc_re <= 1'b1;
			end
			if(start_fft_nc_re == 1'b1) begin
				start_fft_nc_re <= 1'b0;
			end
		end
	end
//---------------------------------------------------------
// process fifo nc_im
//---------------------------------------------------------
	always @(posedge clk) begin
		if (!n_rst) begin
			start_fft_nc_im <= 1'b0;			
		end
		else begin
			if ((ready_nc_im == 1'b1) && (mux_ctrl == 3'b100)) begin
				start_fft_nc_im <= 1'b1;
			end
			if(start_fft_nc_im == 1'b1) begin
				start_fft_nc_im <= 1'b0;
			end
		end
	end
//--- mux_ctrl

	always @(posedge clk) begin
		if(!n_rst) begin
			 mux_ctrl<= 3'b0;
		end 
		else begin
			if(ready_c1a == 1'b1) mux_ctrl <= 3'b000;
			else if(ready_c1b == 1'b1) mux_ctrl <= 3'b001;
			else if((ready_c2a == 1'b1) && (fft_edone == 1'b1)) mux_ctrl <= 3'b010;
			else if((ready_c2b == 1'b1) && (fft_edone == 1'b1)) mux_ctrl <= 3'b011;
			else if(ready_nc_re == 1'b1) mux_ctrl <= 3'b100;
			else mux_ctrl <= mux_ctrl;
		end
	end

//--- dmux_ctrl1
	always @(posedge clk) begin
		if(!n_rst) begin
			 dmux_ctrl1 <= 1'b0;
		end 
		else begin
			if(((ready_c2a == 1'b1) && (fft_edone == 1'b1) || (ready_c2b == 1'b1) && (fft_edone == 1'b1)) && (fft_mode==1'b0)) begin
				dmux_ctrl1 <= 2'b0;
			end
			else if(((ready_c2a == 1'b0) && (fft_edone == 1'b1) || (ready_c2b == 1'b0) && (fft_edone == 1'b1)) && (fft_mode==1'b0)) begin
				dmux_ctrl1 <= 2'b1;
			end
			else if((ready_nc_re == 1'b1 || ready_nc_im == 1'b1) && (fft_mode == 1'b1)) begin
				dmux_ctrl1 <= 2'b10;
			end
			else begin
				dmux_ctrl1 <= dmux_ctrl1;
			end
		end
	end
	
//--- dmux_ctrl2
	always @ (posedge clk) begin
		if(!n_rst) begin
			odd <= 1'b1;
		end
		else if (fft_edone == 1'b1) begin
			odd <= (!odd);
		end
	end
	
	always @(posedge clk) begin
		if(!n_rst) begin
			fft_mode <= 0;
		end 
		else if((ready_c1a == 1'b1) || (ready_c1b == 1'b1)) begin
			fft_mode <= 1'b0;
		end
		else if(ready_nc_re == 1'b1) begin 
			fft_mode <= 1'b1;
		end
		else begin 
			fft_mode <= fft_mode;
		end
	end

	always @(posedge clk) begin
		if(!n_rst) begin
			dmux_ctrl2 <= 2'b00;
		end 
		else begin
			if(((ready_c2a == 1'b1) && (fft_edone == 1'b1) || (ready_c2b == 1'b1) && (fft_edone == 1'b1)) && (fft_mode==1'b0)) begin
				dmux_ctrl2 <= 2'b00;
			end
			else if(((ready_c2a == 1'b0) && (fft_edone == 1'b1) || (ready_c2b == 1'b0) && (fft_edone == 1'b1)) && (fft_mode==1'b0)) begin
				dmux_ctrl2 <= 2'b01;
			end
			else if((ready_nc_re == 1'b1 || ready_nc_im == 1'b1) && (fft_mode == 1'b1) && (odd == 1'b1)) begin
				dmux_ctrl2 <= 2'b10;
			end
			else if((ready_nc_re == 1'b1 || ready_nc_im == 1'b1) && (fft_mode == 1'b1) && (odd == 1'b0)) begin
				dmux_ctrl2 <= 2'b11;
			end
			else begin 
				dmux_ctrl2 <= dmux_ctrl2;
			end
		end
	end


endmodule
