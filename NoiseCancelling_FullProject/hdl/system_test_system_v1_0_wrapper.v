//-----------------------------------------------------------------------------
// system_test_system_v1_0_wrapper.v
//-----------------------------------------------------------------------------

module system_test_system_v1_0_wrapper
  (
    A_PORT,
    B_PORT,
    C_PORT,
    D_PORT,
    E_PORT,
    F_PORT,
    G_PORT,
    H_PORT,
    I_PORT,
    J_PORT,
    S_AXI_ACLK,
    S_AXI_ARESETN,
    S_AXI_AWADDR,
    S_AXI_AWVALID,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WVALID,
    S_AXI_BREADY,
    S_AXI_ARADDR,
    S_AXI_ARVALID,
    S_AXI_RREADY,
    S_AXI_ARREADY,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RVALID,
    S_AXI_WREADY,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_AWREADY
  );
  output [31:0] A_PORT;
  output [31:0] B_PORT;
  output [31:0] C_PORT;
  output [31:0] D_PORT;
  output [31:0] E_PORT;
  output [31:0] F_PORT;
  output [31:0] G_PORT;
  output [31:0] H_PORT;
  output [31:0] I_PORT;
  output [31:0] J_PORT;
  input S_AXI_ACLK;
  input S_AXI_ARESETN;
  input [31:0] S_AXI_AWADDR;
  input S_AXI_AWVALID;
  input [31:0] S_AXI_WDATA;
  input [3:0] S_AXI_WSTRB;
  input S_AXI_WVALID;
  input S_AXI_BREADY;
  input [31:0] S_AXI_ARADDR;
  input S_AXI_ARVALID;
  input S_AXI_RREADY;
  output S_AXI_ARREADY;
  output [31:0] S_AXI_RDATA;
  output [1:0] S_AXI_RRESP;
  output S_AXI_RVALID;
  output S_AXI_WREADY;
  output [1:0] S_AXI_BRESP;
  output S_AXI_BVALID;
  output S_AXI_AWREADY;

  test_system_v1
    #(
      .C_S_AXI_DATA_WIDTH ( 32 ),
      .C_S_AXI_ADDR_WIDTH ( 32 ),
      .C_S_AXI_MIN_SIZE ( 32'h000001ff ),
      .C_USE_WSTRB ( 0 ),
      .C_DPHASE_TIMEOUT ( 8 ),
      .C_BASEADDR ( 32'h75e00000 ),
      .C_HIGHADDR ( 32'h75e0ffff ),
      .C_FAMILY ( "spartan6" ),
      .C_NUM_REG ( 1 ),
      .C_NUM_MEM ( 1 ),
      .C_SLV_AWIDTH ( 32 ),
      .C_SLV_DWIDTH ( 32 )
    )
    test_system_v1_0 (
      .A_PORT ( A_PORT ),
      .B_PORT ( B_PORT ),
      .C_PORT ( C_PORT ),
      .D_PORT ( D_PORT ),
      .E_PORT ( E_PORT ),
      .F_PORT ( F_PORT ),
      .G_PORT ( G_PORT ),
      .H_PORT ( H_PORT ),
      .I_PORT ( I_PORT ),
      .J_PORT ( J_PORT ),
      .S_AXI_ACLK ( S_AXI_ACLK ),
      .S_AXI_ARESETN ( S_AXI_ARESETN ),
      .S_AXI_AWADDR ( S_AXI_AWADDR ),
      .S_AXI_AWVALID ( S_AXI_AWVALID ),
      .S_AXI_WDATA ( S_AXI_WDATA ),
      .S_AXI_WSTRB ( S_AXI_WSTRB ),
      .S_AXI_WVALID ( S_AXI_WVALID ),
      .S_AXI_BREADY ( S_AXI_BREADY ),
      .S_AXI_ARADDR ( S_AXI_ARADDR ),
      .S_AXI_ARVALID ( S_AXI_ARVALID ),
      .S_AXI_RREADY ( S_AXI_RREADY ),
      .S_AXI_ARREADY ( S_AXI_ARREADY ),
      .S_AXI_RDATA ( S_AXI_RDATA ),
      .S_AXI_RRESP ( S_AXI_RRESP ),
      .S_AXI_RVALID ( S_AXI_RVALID ),
      .S_AXI_WREADY ( S_AXI_WREADY ),
      .S_AXI_BRESP ( S_AXI_BRESP ),
      .S_AXI_BVALID ( S_AXI_BVALID ),
      .S_AXI_AWREADY ( S_AXI_AWREADY )
    );

endmodule

