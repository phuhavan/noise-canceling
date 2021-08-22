module overlap_add
#(
	parameter dwidth = 32
)
(
	input 	clk,    // Clock
	input 	n_rst,  // Synchronous reset active low
	input	start_odd,
	input	start_even,
	input 	[6:0]	index_hn_odd,
	input	[6:0]	index_hn_even,
	input	signed [dwidth-1:0]	din_odd,
	input	signed [dwidth-1:0]	din_even,
	
	output	[dwidth-1:0]	dout,
	output 	ready_hn2finish,
	output	ready_hn_odd,
	output	ready_hn_even
);
	//---signal declaration: wire
	wire	[dwidth-1:0] dout_odd;
	wire	[dwidth-1:0] dout_even;

	//---wire connections
	assign dout = (ready_hn_odd) ? dout_odd + dout_even : 32'b0;
	assign ready_hn2finish = ready_hn_odd;

	//---instantiate hanning_recover: ODD
	
	hanning_recover #(.data_width(dwidth)) 
		i_hanning_recover_odd (
			.clk     (clk),
			.rst_n   (n_rst),
			.start   (start_odd),
			.index   (index_hn_odd),
			.data_in (din_odd),
			.data_out(dout_odd),
			.ready   (ready_hn_odd)
		);

	//---instantiate hanning_recover: EVEN
	
	hanning_recover #(.data_width(dwidth)) 
		i_hanning_recover_even (
			.clk     (clk),
			.rst_n   (n_rst),
			.start   (start_even),
			.index   (index_hn_even),
			.data_in (din_even),
			.data_out(dout_even),
			.ready   (ready_hn_even)
		);


endmodule