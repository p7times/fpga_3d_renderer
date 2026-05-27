// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: user.org:user:giu_axi_slave:1.0
// IP Revision: 2

(* X_CORE_INFO = "giu_axi_slave,Vivado 2024.1" *)
(* CHECK_LICENSE_TYPE = "design_1_giu_axi_slave_0_0,giu_axi_slave,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_giu_axi_slave_0_0 (
  vb_addr,
  vb_cs,
  vb_wr,
  vb_dataIn,
  eb_addr,
  eb_cs,
  eb_wr,
  eb_dataIn,
  start_frame,
  vertex_count,
  edge_count,
  angle,
  rotation_type,
  pause,
  frame_done,
  busy,
  giu_axi_slave_aclk,
  giu_axi_slave_aresetn,
  giu_axi_slave_awaddr,
  giu_axi_slave_awprot,
  giu_axi_slave_awvalid,
  giu_axi_slave_awready,
  giu_axi_slave_wdata,
  giu_axi_slave_wstrb,
  giu_axi_slave_wvalid,
  giu_axi_slave_wready,
  giu_axi_slave_bresp,
  giu_axi_slave_bvalid,
  giu_axi_slave_bready,
  giu_axi_slave_araddr,
  giu_axi_slave_arprot,
  giu_axi_slave_arvalid,
  giu_axi_slave_arready,
  giu_axi_slave_rdata,
  giu_axi_slave_rresp,
  giu_axi_slave_rvalid,
  giu_axi_slave_rready
);

output wire [7 : 0] vb_addr;
output wire vb_cs;
output wire vb_wr;
output wire [95 : 0] vb_dataIn;
output wire [9 : 0] eb_addr;
output wire eb_cs;
output wire eb_wr;
output wire [19 : 0] eb_dataIn;
output wire start_frame;
output wire [9 : 0] vertex_count;
output wire [9 : 0] edge_count;
output wire [9 : 0] angle;
output wire [2 : 0] rotation_type;
output wire pause;
input wire frame_done;
input wire busy;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME GIU_AXI_SLAVE_CLK, ASSOCIATED_BUSIF GIU_AXI_SLAVE, ASSOCIATED_RESET giu_axi_slave_aresetn, FREQ_HZ 50000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 GIU_AXI_SLAVE_CLK CLK" *)
input wire giu_axi_slave_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME GIU_AXI_SLAVE_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 GIU_AXI_SLAVE_RST RST" *)
input wire giu_axi_slave_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWADDR" *)
input wire [13 : 0] giu_axi_slave_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWPROT" *)
input wire [2 : 0] giu_axi_slave_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWVALID" *)
input wire giu_axi_slave_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWREADY" *)
output wire giu_axi_slave_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WDATA" *)
input wire [31 : 0] giu_axi_slave_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WSTRB" *)
input wire [3 : 0] giu_axi_slave_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WVALID" *)
input wire giu_axi_slave_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WREADY" *)
output wire giu_axi_slave_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE BRESP" *)
output wire [1 : 0] giu_axi_slave_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE BVALID" *)
output wire giu_axi_slave_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE BREADY" *)
input wire giu_axi_slave_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARADDR" *)
input wire [13 : 0] giu_axi_slave_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARPROT" *)
input wire [2 : 0] giu_axi_slave_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARVALID" *)
input wire giu_axi_slave_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARREADY" *)
output wire giu_axi_slave_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RDATA" *)
output wire [31 : 0] giu_axi_slave_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RRESP" *)
output wire [1 : 0] giu_axi_slave_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RVALID" *)
output wire giu_axi_slave_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME GIU_AXI_SLAVE, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 8, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 50000000, ID_WIDTH 0, ADDR_WIDTH 14, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_processing\
_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 4, NUM_WRITE_THREADS 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RREADY" *)
input wire giu_axi_slave_rready;

  giu_axi_slave #(
    .C_GIU_AXI_SLAVE_DATA_WIDTH(32),  // Width of S_AXI data bus
    .C_GIU_AXI_SLAVE_ADDR_WIDTH(14)  // Width of S_AXI address bus
  ) inst (
    .vb_addr(vb_addr),
    .vb_cs(vb_cs),
    .vb_wr(vb_wr),
    .vb_dataIn(vb_dataIn),
    .eb_addr(eb_addr),
    .eb_cs(eb_cs),
    .eb_wr(eb_wr),
    .eb_dataIn(eb_dataIn),
    .start_frame(start_frame),
    .vertex_count(vertex_count),
    .edge_count(edge_count),
    .angle(angle),
    .rotation_type(rotation_type),
    .pause(pause),
    .frame_done(frame_done),
    .busy(busy),
    .giu_axi_slave_aclk(giu_axi_slave_aclk),
    .giu_axi_slave_aresetn(giu_axi_slave_aresetn),
    .giu_axi_slave_awaddr(giu_axi_slave_awaddr),
    .giu_axi_slave_awprot(giu_axi_slave_awprot),
    .giu_axi_slave_awvalid(giu_axi_slave_awvalid),
    .giu_axi_slave_awready(giu_axi_slave_awready),
    .giu_axi_slave_wdata(giu_axi_slave_wdata),
    .giu_axi_slave_wstrb(giu_axi_slave_wstrb),
    .giu_axi_slave_wvalid(giu_axi_slave_wvalid),
    .giu_axi_slave_wready(giu_axi_slave_wready),
    .giu_axi_slave_bresp(giu_axi_slave_bresp),
    .giu_axi_slave_bvalid(giu_axi_slave_bvalid),
    .giu_axi_slave_bready(giu_axi_slave_bready),
    .giu_axi_slave_araddr(giu_axi_slave_araddr),
    .giu_axi_slave_arprot(giu_axi_slave_arprot),
    .giu_axi_slave_arvalid(giu_axi_slave_arvalid),
    .giu_axi_slave_arready(giu_axi_slave_arready),
    .giu_axi_slave_rdata(giu_axi_slave_rdata),
    .giu_axi_slave_rresp(giu_axi_slave_rresp),
    .giu_axi_slave_rvalid(giu_axi_slave_rvalid),
    .giu_axi_slave_rready(giu_axi_slave_rready)
  );
endmodule
