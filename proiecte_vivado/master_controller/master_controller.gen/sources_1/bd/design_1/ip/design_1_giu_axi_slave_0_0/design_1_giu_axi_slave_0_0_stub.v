// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
// Date        : Tue May 26 15:06:38 2026
// Host        : nemesiseanu running 64-bit Linux Mint 22.3
// Command     : write_verilog -force -mode synth_stub
//               /home/user/Desktop/Personal_Stuff/Homework/an4/LICENTA/licenta_repo/proiecte_vivado/master_controller/master_controller.gen/sources_1/bd/design_1/ip/design_1_giu_axi_slave_0_0/design_1_giu_axi_slave_0_0_stub.v
// Design      : design_1_giu_axi_slave_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "giu_axi_slave,Vivado 2024.1" *)
module design_1_giu_axi_slave_0_0(vb_addr, vb_cs, vb_wr, vb_dataIn, eb_addr, eb_cs, 
  eb_wr, eb_dataIn, start_frame, vertex_count, edge_count, angle, rotation_type, pause, frame_done, 
  busy, giu_axi_slave_aclk, giu_axi_slave_aresetn, giu_axi_slave_awaddr, 
  giu_axi_slave_awprot, giu_axi_slave_awvalid, giu_axi_slave_awready, 
  giu_axi_slave_wdata, giu_axi_slave_wstrb, giu_axi_slave_wvalid, giu_axi_slave_wready, 
  giu_axi_slave_bresp, giu_axi_slave_bvalid, giu_axi_slave_bready, giu_axi_slave_araddr, 
  giu_axi_slave_arprot, giu_axi_slave_arvalid, giu_axi_slave_arready, 
  giu_axi_slave_rdata, giu_axi_slave_rresp, giu_axi_slave_rvalid, giu_axi_slave_rready)
/* synthesis syn_black_box black_box_pad_pin="vb_addr[7:0],vb_cs,vb_wr,vb_dataIn[95:0],eb_addr[9:0],eb_cs,eb_wr,eb_dataIn[19:0],start_frame,vertex_count[9:0],edge_count[9:0],angle[9:0],rotation_type[2:0],pause,frame_done,busy,giu_axi_slave_aresetn,giu_axi_slave_awaddr[13:0],giu_axi_slave_awprot[2:0],giu_axi_slave_awvalid,giu_axi_slave_awready,giu_axi_slave_wdata[31:0],giu_axi_slave_wstrb[3:0],giu_axi_slave_wvalid,giu_axi_slave_wready,giu_axi_slave_bresp[1:0],giu_axi_slave_bvalid,giu_axi_slave_bready,giu_axi_slave_araddr[13:0],giu_axi_slave_arprot[2:0],giu_axi_slave_arvalid,giu_axi_slave_arready,giu_axi_slave_rdata[31:0],giu_axi_slave_rresp[1:0],giu_axi_slave_rvalid,giu_axi_slave_rready" */
/* synthesis syn_force_seq_prim="giu_axi_slave_aclk" */;
  output [7:0]vb_addr;
  output vb_cs;
  output vb_wr;
  output [95:0]vb_dataIn;
  output [9:0]eb_addr;
  output eb_cs;
  output eb_wr;
  output [19:0]eb_dataIn;
  output start_frame;
  output [9:0]vertex_count;
  output [9:0]edge_count;
  output [9:0]angle;
  output [2:0]rotation_type;
  output pause;
  input frame_done;
  input busy;
  input giu_axi_slave_aclk /* synthesis syn_isclock = 1 */;
  input giu_axi_slave_aresetn;
  input [13:0]giu_axi_slave_awaddr;
  input [2:0]giu_axi_slave_awprot;
  input giu_axi_slave_awvalid;
  output giu_axi_slave_awready;
  input [31:0]giu_axi_slave_wdata;
  input [3:0]giu_axi_slave_wstrb;
  input giu_axi_slave_wvalid;
  output giu_axi_slave_wready;
  output [1:0]giu_axi_slave_bresp;
  output giu_axi_slave_bvalid;
  input giu_axi_slave_bready;
  input [13:0]giu_axi_slave_araddr;
  input [2:0]giu_axi_slave_arprot;
  input giu_axi_slave_arvalid;
  output giu_axi_slave_arready;
  output [31:0]giu_axi_slave_rdata;
  output [1:0]giu_axi_slave_rresp;
  output giu_axi_slave_rvalid;
  input giu_axi_slave_rready;
endmodule
