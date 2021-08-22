module top_noiseCancelling
#(
	//--- fifo data width
	parameter dwidth = 32
)
(
	input	clk, n_rst,
	input	[9:0]			wr_ce,
	input 	[9:0]			wr_ce_delay_1clk, // delay 1 clock
	input	[9:0]			rd_ce,
	input 	[dwidth-1:0]	in_c1,
	input	[dwidth-1:0]	in_c2,
	input	[dwidth-1:0]	in_nc_re,
	input	[dwidth-1:0]	in_nc_im,
	output 	[dwidth-1:0]	out_fft_c1re,
	output 	[dwidth-1:0]	out_fft_c1im,
	output 	[dwidth-1:0]	out_fft_c2re,
	output 	[dwidth-1:0]	out_fft_c2im,
	output 	[dwidth-1:0]	out_finish,
	output	[dwidth-1:0]	stt_signal
);
//--- declaration: wire
	//--- controller
	wire start_fft_c1a;
	wire start_fft_c1b;
	wire start_fft_c2a;
	wire start_fft_c2b;
	wire start_fft_nc_re;
	wire start_fft_nc_im;
	wire ready_c1a;
	wire ready_c1b;
	wire ready_c2a;
	wire ready_c2b;
	wire ready_nc_re;
	wire ready_nc_im;
	wire start_hn_c1;
	wire start_hn_c2;
	wire [6:0] index_hn_c1a;
	wire [6:0] index_hn_c1b;
	wire [6:0] index_hn_c2a;
	wire [6:0] index_hn_c2b;
	wire [3:0] controller_wr_ce;
	wire [4:0] controller_rd_ce;
	wire full_ifft_odd;
	wire full_ifft_even;
	wire ready_hn_odd;
	wire ready_hn_even;

	wire 	start_ifft_odd;
	wire	start_ifft_even;
	wire 	[6:0] index_hn_odd;
	wire 	[6:0] index_hn_even;

	//--- fft
	wire fft_start;
	wire fwd_inv;//config
	wire fwd_inv_we;//config
	wire fft_rfd; // bat trong 128 chu ki
	wire fft_edone;
	wire fft_dv;
	wire [dwidth-1:0] fft_din_re;
	wire [dwidth-1:0] fft_din_im;
	wire [dwidth-1:0] fft_dout_re;
	wire [dwidth-1:0] fft_dout_im;

	//--- mux_5_1
	wire [2:0] mux_ctrl;
	wire [dwidth-1:0] mux_fft_din_re;
	wire mux_fft_start;
	//--- dmux_5_1
	wire [1:0] dmux_ctrl1;
	wire [1:0] dmux_ctrl2;
	wire dmux_fft_rfd;
	wire dmux_fft_dv;
	wire dmux_c1_dv, dmux_c2_dv, dmux_ifft_odd_dv, dmux_ifft_even_dv;
	wire [dwidth-1:0] 	dmux_c1_din_im, dmux_c2_din_im, dmux_ifft_odd_din, dmux_ifft_even_din;
	wire dmux_fft_edone;
	wire [dwidth-1:0]	dmux_fft_dout_re;
	wire [dwidth-1:0] 	dmux_fft_dout_im;

	//---Hanning_c1a
	wire [dwidth-1:0] hanning_c1a_data_in;
	wire [dwidth-1:0] hanning_c1a_data_out;
	wire hanning_c1a_ready;

	//---Hanning_c1b
	wire [dwidth-1:0] hanning_c1b_data_in;
	wire [dwidth-1:0] hanning_c1b_data_out;
	wire hanning_c1b_ready;

	//---Hanning_c2a
	wire [dwidth-1:0] hanning_c2a_data_in;
	wire [dwidth-1:0] hanning_c2a_data_out;
	wire hanning_c2a_ready;

	//---Hanning_c2b
	wire [dwidth-1:0] hanning_c2b_data_in;
	wire [dwidth-1:0] hanning_c2b_data_out;
	wire hanning_c2b_ready;

	//---fifo: c1a
	wire [dwidth-1:0] c1a_data_in;
	wire [dwidth-1:0] c1a_data_out;
	wire c1a_wr_ce;
	wire c1a_rd_ce;
	wire c1a_full;
	wire c1a_empty;
	wire c1a_error;
	wire c1a_start_fft;
	wire c1a_fft_rfd;

	//---fifo: c1b
	wire [dwidth-1:0] c1b_data_in;
	wire [dwidth-1:0] c1b_data_out;
	wire c1b_wr_ce;
	wire c1b_rd_ce;
	wire c1b_full;
	wire c1b_empty;
	wire c1b_error;
	wire c1b_start_fft;
	wire c1b_fft_rfd;

	//---fifo: c2a
	wire [dwidth-1:0] c2a_data_in;
	wire [dwidth-1:0] c2a_data_out;
	wire c2a_wr_ce;
	wire c2a_rd_ce;
	wire c2a_full;
	wire c2a_empty;
	wire c2a_error;
	wire c2a_start_fft;
	wire c2a_fft_rfd;

	//---fifo: c2b
	wire [dwidth-1:0] c2b_data_in;
	wire [dwidth-1:0] c2b_data_out;
	wire c2b_wr_ce;
	wire c2b_rd_ce;
	wire c2b_full;
	wire c2b_empty;
	wire c2b_error;
	wire c2b_start_fft;
	wire c2b_fft_rfd;

	//---fifo: nc_re
	wire [dwidth-1:0] nc_re_data_in;
	wire [dwidth-1:0] nc_re_data_out;
	wire nc_re_wr_ce;
	wire nc_re_rd_ce;
	wire nc_re_full;
	wire nc_re_empty;
	wire nc_re_error;
	wire nc_re_start_fft;
	wire nc_fft_rfd;

	//---fifo: nc_im
	wire [dwidth-1:0] nc_im_data_in;
	wire [dwidth-1:0] nc_im_data_out;
	wire nc_im_wr_ce;
	wire nc_im_rd_ce;
	wire nc_im_full;
	wire nc_im_empty;
	wire nc_im_error;
	wire nc_im_start_fft;

	//---fifo: fft_c1re
	wire fft_c1re_done;
	wire fft_c1re_wr_ce;
	wire fft_c1re_rd_ce;
	wire [dwidth-1:0]	fft_c1re_data_in;
	wire [dwidth-1:0]	fft_c1re_data_out;
	wire fft_c1re_full;
	wire fft_c1re_error;

	//---fifo: fft_c1im
	wire fft_c1im_done;
	wire fft_c1im_wr_ce;
	wire fft_c1im_rd_ce;
	wire [dwidth-1:0]	fft_c1im_data_in;
	wire [dwidth-1:0]	fft_c1im_data_out;
	wire fft_c1im_full;
	wire fft_c1im_error;

	//---fifo: fft_c2re
	wire fft_c2re_done;
	wire fft_c2re_wr_ce;
	wire fft_c2re_rd_ce;
	wire [dwidth-1:0]	fft_c2re_data_in;
	wire [dwidth-1:0]	fft_c2re_data_out;
	wire fft_c2re_full;
	wire fft_c2re_error;

	//---fifo: fft_c2im
	wire fft_c2im_done;
	wire fft_c2im_wr_ce;
	wire fft_c2im_rd_ce;
	wire [dwidth-1:0]	fft_c2im_data_in;
	wire [dwidth-1:0]	fft_c2im_data_out;
	wire fft_c2im_full;
	wire fft_c2im_error;

	//---fifo: ifft_odd
	wire ifft_odd_done;
	wire ifft_odd_wr_ce;
	wire ifft_odd_rd_ce;
	wire [dwidth-1:0]	ifft_odd_data_in;
	wire [dwidth-1:0]	ifft_odd_data_out;
	wire ifft_odd_full;
	wire ifft_odd_error;

	//---fifo: ifft_even
	wire ifft_even_done;
	wire ifft_even_wr_ce;
	wire ifft_even_rd_ce;
	wire [dwidth-1:0]	ifft_even_data_in;
	wire [dwidth-1:0]	ifft_even_data_out;
	wire ifft_even_full;
	wire ifft_even_error;

	//---overlap_add
	wire [dwidth-1:0] overlap_add_dout;
	wire ready_hn2finish;
	wire ready_hn_recover_odd;
	wire ready_hn_recover_even;
	//---fifo: finish
	wire [dwidth-1:0] finish_data_in;
	wire [dwidth-1:0] finish_data_out;
	wire finish_wr_ce;
	wire finish_rd_ce;
	wire finish_full;
	wire finish_empty;
	wire finish_error;
	wire finish_start_fft;
	wire finish_fft_rfd;

	

//--- assigns
	//---controller
	assign ready_c1a = c1a_full;
	assign ready_c1b = c1b_full;
	assign ready_c2a = c2a_full;
	assign ready_c2b = c2b_full;
	assign ready_nc_re = nc_re_full;
	assign ready_nc_im = nc_im_full;
	assign controller_wr_ce = wr_ce[9:6];
	assign controller_rd_ce = rd_ce[5:1];
	assign full_ifft_odd = ifft_odd_full;
	assign full_ifft_even = ifft_even_full;
	assign ready_hn_odd = ready_hn_recover_odd;
	assign ready_hn_even = ready_hn_recover_even;
	


	
	//---hanning_window_c1a
	assign hanning_c1a_data_in = in_c1;
	//---hanning_window_c1b
	assign hanning_c1b_data_in = in_c1;
	//---hanning_window_c2a
	assign hanning_c2a_data_in = in_c2;
	//---hanning_window_c2b
	assign hanning_c2b_data_in = in_c2;

	//---c1a
	assign c1a_data_in = hanning_c1a_data_out;
	assign c1a_wr_ce = hanning_c1a_ready;
	assign c1a_wr_ce = hanning_c1a_ready;
	assign c1a_rd_ce = c1a_fft_rfd;
	assign c1a_start_fft = start_fft_c1a;

	//---c1b
	assign c1b_data_in = hanning_c1b_data_out;
	assign c1b_wr_ce = hanning_c1b_ready;
	assign c1b_rd_ce = c1b_fft_rfd;
	assign c1b_start_fft = start_fft_c1b;

	//---c2a
	assign c2a_data_in = hanning_c2a_data_out;
	assign c2a_wr_ce = hanning_c2a_ready;
	assign c2a_rd_ce = c2a_fft_rfd;
	assign c2a_start_fft = start_fft_c2a;

	//---c2b
	assign c2b_data_in = hanning_c2b_data_out;
	assign c2b_wr_ce = hanning_c2b_ready;
	assign c2b_rd_ce = c2b_fft_rfd;
	assign c2b_start_fft = start_fft_c2b;

	//---nc_re
	assign nc_re_data_in = in_nc_re;
	assign nc_re_wr_ce = wr_ce_delay_1clk[7];
	assign nc_re_rd_ce = nc_fft_rfd;
	assign nc_re_start_fft = start_fft_nc_re;

	//---nc_im
	assign nc_im_data_in = in_nc_im;
	assign nc_im_wr_ce = wr_ce_delay_1clk[6];
	assign nc_im_rd_ce = nc_fft_rfd;
	assign nc_im_start_fft = start_fft_nc_im;

	//---fft_c1re
	assign fft_c1re_done = fft_edone;
	assign fft_c1re_wr_ce = dmux_c1_dv;
	assign fft_c1re_rd_ce = rd_ce[5];
	assign fft_c1re_data_in = dmux_c1_din_re;


	//---fft_c1im
	assign fft_c1im_done = fft_edone;
	assign fft_c1im_wr_ce = dmux_c1_dv;
	assign fft_c1im_rd_ce = rd_ce[4];
	assign fft_c1im_data_in = dmux_c1_din_im;

	//---fft_c2re
	assign fft_c2re_done = fft_edone;
	assign fft_c2re_wr_ce = dmux_c2_dv;
	assign fft_c2re_rd_ce = rd_ce[3];
	assign fft_c2re_data_in = dmux_c2_din_re;


	//---fft_c2im
	assign fft_c2im_done = fft_edone;
	assign fft_c2im_wr_ce = dmux_c2_dv;
	assign fft_c2im_rd_ce = rd_ce[2];
	assign fft_c2im_data_in = dmux_c2_din_im;

	//---ifft_odd
	assign ifft_odd_done = fft_edone;
	assign ifft_odd_wr_ce = dmux_ifft_odd_dv;
	assign ifft_odd_rd_ce = start_ifft_odd;
	assign ifft_odd_data_in = dmux_ifft_odd_din;

	//---ifft_even
	assign ifft_even_done = fft_edone;
	assign ifft_even_wr_ce = dmux_ifft_even_dv;
	assign ifft_even_rd_ce = start_ifft_even;
	assign ifft_even_data_in = dmux_ifft_even_din;

	//---finish
	assign finish_wr_ce = ready_hn2finish;
	assign finish_rd_ce =rd_ce[1];
	assign finish_data_in = overlap_add_dout;


	//---fft
	assign fwd_inv = ~n_rst;	// fixed
	assign fwd_inv_we = ~n_rst;	// fixed
	assign fft_din_re = mux_fft_din_re;
	assign fft_din_im = nc_im_data_out;
	assign fft_start = mux_fft_start;


	// data out
	
	assign stt_signal = {ready_c1a, ready_c1b, ready_c2a, ready_c2b, ready_nc_re, ready_nc_im, mux_ctrl[2:0], dmux_ctrl1[1:0], dmux_ctrl2[1:0], 19'b0};
	assign out_fft_c1re = fft_c1re_data_out;
	assign out_fft_c1im = fft_c1im_data_out;
	assign out_fft_c2re = fft_c2re_data_out;
	assign out_fft_c2im = fft_c2im_data_out;
	assign out_finish = finish_data_out;

//--- instantiate: controller
	
	controller 
		i_controller (
			.clk            (clk            ),
			.n_rst          (n_rst          ),
			.wr_ce 			(controller_wr_ce),
			.rd_ce 			(controller_rd_ce),
			.ready_c1a      (ready_c1a      ),
			.ready_c1b      (ready_c1b      ),
			.ready_c2a      (ready_c2a      ),
			.ready_c2b      (ready_c2b      ),
			.ready_nc_re    (ready_nc_re    ),
			.ready_nc_im    (ready_nc_im    ),
			.start_fft_c1a  (start_fft_c1a  ),
			.start_fft_c1b  (start_fft_c1b  ),
			.start_fft_c2a  (start_fft_c2a  ),
			.start_fft_c2b  (start_fft_c2b  ),
			.start_fft_nc_re(start_fft_nc_re),
			.start_fft_nc_im(start_fft_nc_im),
			.mux_ctrl		(mux_ctrl),
			.dmux_ctrl1		(dmux_ctrl1),
			.dmux_ctrl2		(dmux_ctrl2),
			.fft_edone 		(fft_edone),
			.start_hn_c1	(start_hn_c1),
			.start_hn_c2	(start_hn_c2),
			.index_hn_c1a	(index_hn_c1a),
			.index_hn_c1b	(index_hn_c1b),
			.index_hn_c2a	(index_hn_c2a),
			.index_hn_c2b	(index_hn_c2b),
			.full_ifft_odd	(full_ifft_odd),
			.full_ifft_even	(full_ifft_even),
			.ready_hn_odd	(ready_hn_odd),
			.ready_hn_even	(ready_hn_even),
			.start_ifft_odd	(start_ifft_odd),
			.start_ifft_even(start_ifft_even),
			.index_hn_odd	(index_hn_odd),
			.index_hn_even	(index_hn_even)
		);

//---instantiate: hanning_window_c1a
	hanning_wd #(.data_width(dwidth)) 
		hanning_c1a (
			.clk     (clk),
			.rst_n   (n_rst),
			.start   (start_hn_c1),
			.index   (index_hn_c1a),
			.data_in (hanning_c1a_data_in),
			.data_out(hanning_c1a_data_out),
			.ready   (hanning_c1a_ready)
		);
//---instantiate: hanning_window_c1b
	hanning_wd #(.data_width(dwidth)) 
		hanning_c1b (
			.clk     (clk),
			.rst_n   (n_rst),
			.start   (start_hn_c1),
			.index   (index_hn_c1b),
			.data_in (hanning_c1b_data_in),
			.data_out(hanning_c1b_data_out),
			.ready   (hanning_c1b_ready)
		);
//---instantiate: hanning_window_c2a
	hanning_wd #(.data_width(dwidth)) 
		hanning_c2a (
			.clk     (clk),
			.rst_n   (n_rst),
			.start   (start_hn_c1),
			.index   (index_hn_c2a),
			.data_in (hanning_c2a_data_in),
			.data_out(hanning_c2a_data_out),
			.ready   (hanning_c2a_ready)
		);
//---instantiate: hanning_window_c2b
	hanning_wd #(.data_width(dwidth)) 
		hanning_c2b (
			.clk     (clk),
			.rst_n   (n_rst),
			.start   (start_hn_c1),
			.index   (index_hn_c2b),
			.data_in (hanning_c2b_data_in),
			.data_out(hanning_c2b_data_out),
			.ready   (hanning_c2b_ready)
		);
	
//--- instantiate: c1a
	fifo128_type1  #(.dwidth(dwidth),.reset_value(0))
		fifo128_c1a(
			.clk         (clk),
			.n_rst       (n_rst),
			.wr_ce       (c1a_wr_ce),
			.rd_ce       (c1a_rd_ce),
			.start_fft_in(c1a_start_fft),
			.start_fft   (),
			.data_in     (c1a_data_in),
			.data_out    (c1a_data_out),
			.full        (c1a_full),
			.empty       (c1a_empty),
			.error       (c1a_error)
		);
//--- instantiate: c1b
	fifo128_type1  #(.dwidth(dwidth),.reset_value(64))
		fifo128_c1b(
			.clk         (clk),
			.n_rst       (n_rst),
			.wr_ce       (c1b_wr_ce),
			.rd_ce       (c1b_rd_ce),
			.start_fft_in(c1b_start_fft),
			.start_fft   (),
			.data_in     (c1b_data_in),
			.data_out    (c1b_data_out),
			.full        (c1b_full),
			.empty       (c1b_empty),
			.error       (c1b_error)
		);

//--- instantiate: c2a
	fifo128_type1  #(.dwidth(dwidth),.reset_value(0))
		fifo128_c2a(
			.clk         (clk),
			.n_rst       (n_rst),
			.wr_ce       (c2a_wr_ce),
			.rd_ce       (c2a_rd_ce),
			.start_fft_in(c2a_start_fft),
			.start_fft   (),
			.data_in     (c2a_data_in),
			.data_out    (c2a_data_out),
			.full        (c2a_full),
			.empty       (c2a_empty),
			.error       (c2a_error)
		);

//--- instantiate: c2b
	fifo128_type1  #(.dwidth(dwidth),.reset_value(64))
		fifo128_c2b(
			.clk         (clk),
			.n_rst       (n_rst),
			.wr_ce       (c2b_wr_ce),
			.rd_ce       (c2b_rd_ce),
			.start_fft_in(c2b_start_fft),
			.start_fft   (),
			.data_in     (c2b_data_in),
			.data_out    (c2b_data_out),
			.full        (c2b_full),
			.empty       (c2b_empty),
			.error       (c2b_error)
		);
//--- instantiate: nc_re
	fifo128_type1  #(.dwidth(dwidth),.reset_value(0))
		fifo128_nc_re(
			.clk         (clk),
			.n_rst       (n_rst),
			.wr_ce       (nc_re_wr_ce),
			.rd_ce       (nc_re_rd_ce),
			.start_fft_in(nc_re_start_fft),
			.start_fft   (),
			.data_in     (nc_re_data_in),
			.data_out    (nc_re_data_out),
			.full        (nc_re_full),
			.empty       (nc_re_empty),
			.error       (nc_re_error)
		);
//--- instantiate: nc_im
	fifo128_type1  #(.dwidth(dwidth),.reset_value(0))
		fifo128_nc_im(
			.clk         (clk),
			.n_rst       (n_rst),
			.wr_ce       (nc_im_wr_ce),
			.rd_ce       (nc_im_rd_ce),
			.start_fft_in(nc_im_start_fft),
			.start_fft   (),
			.data_in     (nc_im_data_in),
			.data_out    (nc_im_data_out),
			.full        (nc_im_full),
			.empty       (nc_im_empty),
			.error       (nc_im_error)
		);
//--- instantiate: 128-point FFT
	// FFT
	FFT fft_inst(
			.clk		(clk),
			.ce         (1'b1),
			.start      (fft_start),
			.fwd_inv    (fwd_inv),		// setting signal
			.fwd_inv_we (fwd_inv_we),	// setting signal
			.rfd        (fft_rfd),			
			.busy       (),
			.edone      (fft_edone),
			.done       (),
			.dv         (fft_dv),
			.xn_re      (fft_din_re[23:0]),
			.xn_im      (fft_din_im[23:0]),
			.xn_index   (),
			.xk_index   (),
			.xk_re      (fft_dout_re),
			.xk_im      (fft_dout_im)
		);

	//--- Instantiate: fft_c1re
	fifo128_type2 #(.dwidth(dwidth)) 
		fifo128_fft_c1re (
			.clk      (clk),
			.n_rst    (n_rst),
			.fft_edone(fft_c1re_done),
			.wr_ce    (fft_c1re_wr_ce), 
			.rd_ce    (fft_c1re_rd_ce), 
			.data_in  (fft_c1re_data_in),
			.data_out (fft_c1re_data_out),
			.full     (fft_c1re_full),
			.error    (fft_c1re_error)
		);

	//--- Instantiate: fft_c1im
	fifo128_type2 #(.dwidth(dwidth)) 
		fifo128_fft_c1im (
			.clk      (clk),
			.n_rst    (n_rst),
			.fft_edone(fft_c1im_done),
			.wr_ce    (fft_c1im_wr_ce), 
			.rd_ce    (fft_c1im_rd_ce), 
			.data_in  (fft_c1im_data_in),
			.data_out (fft_c1im_data_out),
			.full     (fft_c1im_full),
			.error    (fft_c1im_error)
		);

	//--- Instantiate: fft_c2re
	fifo128_type2 #(.dwidth(dwidth)) 
		fifo128_fft_c2re (
			.clk      (clk),
			.n_rst    (n_rst),
			.fft_edone(fft_c2re_done),
			.wr_ce    (fft_c2re_wr_ce), 
			.rd_ce    (fft_c2re_rd_ce), 
			.data_in  (fft_c2re_data_in),
			.data_out (fft_c2re_data_out),
			.full     (fft_c2re_full),
			.error    (fft_c2re_error)
		);

	//--- Instantiate: fft_c2im
	fifo128_type2 #(.dwidth(dwidth)) 
		fifo128_fft_c2im (
			.clk      (clk),
			.n_rst    (n_rst),
			.fft_edone(fft_c2im_done),
			.wr_ce    (fft_c2im_wr_ce), 
			.rd_ce    (fft_c2im_rd_ce), 
			.data_in  (fft_c2im_data_in),
			.data_out (fft_c2im_data_out),
			.full     (fft_c2im_full),
			.error    (fft_c2im_error)
		);

	//--- Instantiate: ifft_odd
	fifo128_type3 #(.dwidth(dwidth)) 
		fifo128_ifft_odd (
			.clk      (clk),
			.n_rst    (n_rst),
			.fft_edone(ifft_odd_done),
			.wr_ce    (ifft_odd_wr_ce), 
			.rd_ce    (ifft_odd_rd_ce), 
			.data_in  (ifft_odd_data_in),
			.data_out (ifft_odd_data_out),
			.full     (ifft_odd_full),
			.error    (ifft_odd_error),
			.ready 	  (ifft_odd_ready)
		);

	//--- Instantiate: ifft_even
	fifo128_type3 #(.dwidth(dwidth)) 
		fifo128_ifft_even (
			.clk      (clk),
			.n_rst    (n_rst),
			.fft_edone(ifft_even_done),
			.wr_ce    (ifft_even_wr_ce), 
			.rd_ce    (ifft_even_rd_ce), 
			.data_in  (ifft_even_data_in),
			.data_out (ifft_even_data_out),
			.full     (ifft_even_full),
			.error    (ifft_even_error),
			.ready 	  (ifft_even_ready)
		);

	//---instantiate overlap_add
	overlap_add #(.dwidth(dwidth)) 
		i_overlap_add (
			.clk            (clk),
			.n_rst          (n_rst),
			.start_odd      (ifft_odd_ready | ifft_even_ready),
			.start_even     (ifft_odd_ready | ifft_even_ready),
			.index_hn_odd   (index_hn_odd),
			.index_hn_even  (index_hn_even),
			.din_odd        (ifft_odd_data_out),
			.din_even       (ifft_even_data_out),
			.dout           (overlap_add_dout),
			.ready_hn2finish(ready_hn2finish),
			.ready_hn_odd   (ready_hn_recover_odd),
			.ready_hn_even  (ready_hn_recover_even)
		);

	//---instantiate fifo: Finish

	fifo128_type4 #(.dwidth(dwidth)) 
		fifo128_finish (
			.clk         (clk),
			.n_rst       (n_rst),
			.wr_ce       (finish_wr_ce),
			.rd_ce       (finish_rd_ce),
			.data_in     (finish_data_in),
			.data_out    (finish_data_out),
			.full        (finish_full),
			.empty       (finish_empty),
			.error       (finish_error)
		);


	//--- Instantiate: mux_5_1
	mux_5_1 #(.data_width(dwidth)) mux_5_1_fft_din_re (
		.in0   (c1a_data_out),
		.in1   (c1b_data_out),
		.in2   (c2a_data_out),
		.in3   (c2b_data_out),
		.in4   (nc_re_data_out),
		.sel   (mux_ctrl),
		.result(mux_fft_din_re)
	);

	//--- Instantiate: mux_5_1
	mux_5_1 #(.data_width(1)) mux_5_1_fft_start (
		.in0   (start_fft_c1a),
		.in1   (start_fft_c1b),
		.in2   (start_fft_c2a),
		.in3   (start_fft_c2b),
		.in4   (start_fft_nc_re),
		.sel   (mux_ctrl),
		.result(mux_fft_start)
	);

	//--- Instantiate: dmux_1_5
	assign dmux_fft_rfd = fft_rfd;
	demux_1_5 #(.data_width(1)) demux_1_5_fft_rfd (
		.in0 (dmux_fft_rfd),
		.sel (mux_ctrl),
		.res0(c1a_fft_rfd ),
		.res1(c1b_fft_rfd ),
		.res2(c2a_fft_rfd ),
		.res3(c2b_fft_rfd ),
		.res4(nc_fft_rfd)
	);

	//--- Instantiate: dmux_1_4
	assign dmux_fft_dv = fft_dv;
	demux_1_4 #(.data_width(1)) demux_1_4_fft_dv (
		.in0 (dmux_fft_dv),
		.sel (dmux_ctrl2),
		.res0(dmux_c1_dv),
		.res1(dmux_c2_dv),
		.res2(dmux_ifft_odd_dv),
		.res3(dmux_ifft_even_dv)
	);

	//--- Instantiate: dmux_1_4
	assign dmux_fft_dout_im = fft_dout_im;
	demux_1_4 #(.data_width(dwidth)) demux_1_4_fft_dout_im (
		.in0 (dmux_fft_dout_im),
		.sel (dmux_ctrl2),
		.res0(dmux_c1_din_im),
		.res1(dmux_c2_din_im),
		.res2(dmux_ifft_odd_din),
		.res3(dmux_ifft_even_din)
	);

	//--- Instantiate: dmux_1_3
	wire [dwidth-1:0]	dmux_c1_din_re, dmux_c2_din_re;
	assign dmux_fft_dout_re = fft_dout_re;
	demux_1_3 #(.data_width(dwidth)) demux_1_3_fft_dout_re (
		.in0 (dmux_fft_dout_re),
		.sel (dmux_ctrl1),
		.res0(dmux_c1_din_re),
		.res1(dmux_c2_din_re),
		.res2()
	);

endmodule
