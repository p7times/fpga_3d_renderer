// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
// Date        : Tue May 26 15:06:38 2026
// Host        : nemesiseanu running 64-bit Linux Mint 22.3
// Command     : write_verilog -force -mode funcsim
//               /home/user/Desktop/Personal_Stuff/Homework/an4/LICENTA/licenta_repo/proiecte_vivado/master_controller/master_controller.gen/sources_1/bd/design_1/ip/design_1_giu_axi_slave_0_0/design_1_giu_axi_slave_0_0_sim_netlist.v
// Design      : design_1_giu_axi_slave_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_giu_axi_slave_0_0,giu_axi_slave,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "giu_axi_slave,Vivado 2024.1" *) 
(* NotValidForBitStream *)
module design_1_giu_axi_slave_0_0
   (vb_addr,
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
    giu_axi_slave_rready);
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 GIU_AXI_SLAVE_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME GIU_AXI_SLAVE_CLK, ASSOCIATED_BUSIF GIU_AXI_SLAVE, ASSOCIATED_RESET giu_axi_slave_aresetn, FREQ_HZ 50000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input giu_axi_slave_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 GIU_AXI_SLAVE_RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME GIU_AXI_SLAVE_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input giu_axi_slave_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWADDR" *) input [13:0]giu_axi_slave_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWPROT" *) input [2:0]giu_axi_slave_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWVALID" *) input giu_axi_slave_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWREADY" *) output giu_axi_slave_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WDATA" *) input [31:0]giu_axi_slave_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WSTRB" *) input [3:0]giu_axi_slave_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WVALID" *) input giu_axi_slave_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WREADY" *) output giu_axi_slave_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE BRESP" *) output [1:0]giu_axi_slave_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE BVALID" *) output giu_axi_slave_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE BREADY" *) input giu_axi_slave_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARADDR" *) input [13:0]giu_axi_slave_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARPROT" *) input [2:0]giu_axi_slave_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARVALID" *) input giu_axi_slave_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARREADY" *) output giu_axi_slave_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RDATA" *) output [31:0]giu_axi_slave_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RRESP" *) output [1:0]giu_axi_slave_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RVALID" *) output giu_axi_slave_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RREADY" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME GIU_AXI_SLAVE, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 8, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 50000000, ID_WIDTH 0, ADDR_WIDTH 14, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 4, NUM_WRITE_THREADS 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input giu_axi_slave_rready;

  wire \<const0> ;
  wire [9:0]angle;
  wire busy;
  wire [9:0]eb_addr;
  wire [19:0]eb_dataIn;
  wire eb_wr;
  wire [9:0]edge_count;
  wire frame_done;
  wire giu_axi_slave_aclk;
  wire [13:0]giu_axi_slave_araddr;
  wire giu_axi_slave_aresetn;
  wire giu_axi_slave_arready;
  wire giu_axi_slave_arvalid;
  wire [13:0]giu_axi_slave_awaddr;
  wire giu_axi_slave_awready;
  wire giu_axi_slave_awvalid;
  wire giu_axi_slave_bready;
  wire giu_axi_slave_bvalid;
  wire [31:0]giu_axi_slave_rdata;
  wire giu_axi_slave_rready;
  wire giu_axi_slave_rvalid;
  wire [31:0]giu_axi_slave_wdata;
  wire giu_axi_slave_wready;
  wire giu_axi_slave_wvalid;
  wire pause;
  wire [2:0]rotation_type;
  wire start_frame;
  wire [7:0]vb_addr;
  wire [95:0]vb_dataIn;
  wire vb_wr;
  wire [9:0]vertex_count;

  assign eb_cs = eb_wr;
  assign giu_axi_slave_bresp[1] = \<const0> ;
  assign giu_axi_slave_bresp[0] = \<const0> ;
  assign giu_axi_slave_rresp[1] = \<const0> ;
  assign giu_axi_slave_rresp[0] = \<const0> ;
  assign vb_cs = vb_wr;
  GND GND
       (.G(\<const0> ));
  design_1_giu_axi_slave_0_0_giu_axi_slave inst
       (.Q({edge_count,vertex_count}),
        .angle(angle),
        .axi_arready_reg(giu_axi_slave_arready),
        .axi_awready_reg(giu_axi_slave_awready),
        .axi_rvalid_reg(giu_axi_slave_rvalid),
        .axi_wready_reg(giu_axi_slave_wready),
        .busy(busy),
        .eb_addr(eb_addr),
        .eb_dataIn(eb_dataIn),
        .eb_wr(eb_wr),
        .frame_done(frame_done),
        .giu_axi_slave_aclk(giu_axi_slave_aclk),
        .giu_axi_slave_araddr({giu_axi_slave_araddr[13:12],giu_axi_slave_araddr[4:2]}),
        .giu_axi_slave_aresetn(giu_axi_slave_aresetn),
        .giu_axi_slave_arvalid(giu_axi_slave_arvalid),
        .giu_axi_slave_awaddr(giu_axi_slave_awaddr[13:2]),
        .giu_axi_slave_awvalid(giu_axi_slave_awvalid),
        .giu_axi_slave_bready(giu_axi_slave_bready),
        .giu_axi_slave_bvalid(giu_axi_slave_bvalid),
        .giu_axi_slave_rdata(giu_axi_slave_rdata),
        .giu_axi_slave_rready(giu_axi_slave_rready),
        .giu_axi_slave_wdata(giu_axi_slave_wdata),
        .giu_axi_slave_wvalid(giu_axi_slave_wvalid),
        .\slv_reg4_reg[3] ({pause,rotation_type}),
        .start_frame(start_frame),
        .vb_addr(vb_addr),
        .vb_dataIn(vb_dataIn),
        .vb_wr(vb_wr));
endmodule

(* ORIG_REF_NAME = "giu_axi_slave" *) 
module design_1_giu_axi_slave_0_0_giu_axi_slave
   (axi_awready_reg,
    axi_rvalid_reg,
    axi_arready_reg,
    vb_addr,
    vb_dataIn,
    eb_addr,
    eb_dataIn,
    Q,
    angle,
    \slv_reg4_reg[3] ,
    axi_wready_reg,
    giu_axi_slave_rdata,
    giu_axi_slave_bvalid,
    vb_wr,
    eb_wr,
    start_frame,
    giu_axi_slave_awvalid,
    giu_axi_slave_wvalid,
    giu_axi_slave_aclk,
    giu_axi_slave_rready,
    giu_axi_slave_arvalid,
    giu_axi_slave_awaddr,
    giu_axi_slave_wdata,
    giu_axi_slave_araddr,
    busy,
    giu_axi_slave_aresetn,
    frame_done,
    giu_axi_slave_bready);
  output axi_awready_reg;
  output axi_rvalid_reg;
  output axi_arready_reg;
  output [7:0]vb_addr;
  output [95:0]vb_dataIn;
  output [9:0]eb_addr;
  output [19:0]eb_dataIn;
  output [19:0]Q;
  output [9:0]angle;
  output [3:0]\slv_reg4_reg[3] ;
  output axi_wready_reg;
  output [31:0]giu_axi_slave_rdata;
  output giu_axi_slave_bvalid;
  output vb_wr;
  output eb_wr;
  output start_frame;
  input giu_axi_slave_awvalid;
  input giu_axi_slave_wvalid;
  input giu_axi_slave_aclk;
  input giu_axi_slave_rready;
  input giu_axi_slave_arvalid;
  input [11:0]giu_axi_slave_awaddr;
  input [31:0]giu_axi_slave_wdata;
  input [4:0]giu_axi_slave_araddr;
  input busy;
  input giu_axi_slave_aresetn;
  input frame_done;
  input giu_axi_slave_bready;

  wire [19:0]Q;
  wire [9:0]angle;
  wire axi_arready_reg;
  wire axi_awready_reg;
  wire axi_rvalid_reg;
  wire axi_wready_reg;
  wire busy;
  wire [9:0]eb_addr;
  wire [19:0]eb_dataIn;
  wire eb_wr;
  wire frame_done;
  wire giu_axi_slave_aclk;
  wire [4:0]giu_axi_slave_araddr;
  wire giu_axi_slave_aresetn;
  wire giu_axi_slave_arvalid;
  wire [11:0]giu_axi_slave_awaddr;
  wire giu_axi_slave_awvalid;
  wire giu_axi_slave_bready;
  wire giu_axi_slave_bvalid;
  wire [31:0]giu_axi_slave_rdata;
  wire giu_axi_slave_rready;
  wire [31:0]giu_axi_slave_wdata;
  wire giu_axi_slave_wvalid;
  wire [3:0]\slv_reg4_reg[3] ;
  wire start_frame;
  wire [7:0]vb_addr;
  wire [95:0]vb_dataIn;
  wire vb_wr;

  design_1_giu_axi_slave_0_0_giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE_inst
       (.Q(Q),
        .angle(angle),
        .axi_arready_reg_0(axi_arready_reg),
        .axi_awready_reg_0(axi_awready_reg),
        .axi_rvalid_reg_0(axi_rvalid_reg),
        .axi_wready_reg_0(axi_wready_reg),
        .busy(busy),
        .eb_addr(eb_addr),
        .eb_dataIn(eb_dataIn),
        .eb_wr(eb_wr),
        .frame_done(frame_done),
        .giu_axi_slave_aclk(giu_axi_slave_aclk),
        .giu_axi_slave_araddr(giu_axi_slave_araddr),
        .giu_axi_slave_aresetn(giu_axi_slave_aresetn),
        .giu_axi_slave_arvalid(giu_axi_slave_arvalid),
        .giu_axi_slave_awaddr(giu_axi_slave_awaddr),
        .giu_axi_slave_awvalid(giu_axi_slave_awvalid),
        .giu_axi_slave_bready(giu_axi_slave_bready),
        .giu_axi_slave_bvalid(giu_axi_slave_bvalid),
        .giu_axi_slave_rdata(giu_axi_slave_rdata),
        .giu_axi_slave_rready(giu_axi_slave_rready),
        .giu_axi_slave_wdata(giu_axi_slave_wdata),
        .giu_axi_slave_wvalid(giu_axi_slave_wvalid),
        .\slv_reg4_reg[3]_0 (\slv_reg4_reg[3] ),
        .start_frame(start_frame),
        .vb_addr(vb_addr),
        .vb_dataIn(vb_dataIn),
        .vb_wr(vb_wr));
endmodule

(* ORIG_REF_NAME = "giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE" *) 
module design_1_giu_axi_slave_0_0_giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE
   (axi_awready_reg_0,
    axi_rvalid_reg_0,
    axi_arready_reg_0,
    vb_addr,
    vb_dataIn,
    eb_addr,
    eb_dataIn,
    Q,
    angle,
    \slv_reg4_reg[3]_0 ,
    axi_wready_reg_0,
    giu_axi_slave_rdata,
    giu_axi_slave_bvalid,
    vb_wr,
    eb_wr,
    start_frame,
    giu_axi_slave_awvalid,
    giu_axi_slave_wvalid,
    giu_axi_slave_aclk,
    giu_axi_slave_rready,
    giu_axi_slave_arvalid,
    giu_axi_slave_awaddr,
    giu_axi_slave_wdata,
    giu_axi_slave_araddr,
    busy,
    giu_axi_slave_aresetn,
    frame_done,
    giu_axi_slave_bready);
  output axi_awready_reg_0;
  output axi_rvalid_reg_0;
  output axi_arready_reg_0;
  output [7:0]vb_addr;
  output [95:0]vb_dataIn;
  output [9:0]eb_addr;
  output [19:0]eb_dataIn;
  output [19:0]Q;
  output [9:0]angle;
  output [3:0]\slv_reg4_reg[3]_0 ;
  output axi_wready_reg_0;
  output [31:0]giu_axi_slave_rdata;
  output giu_axi_slave_bvalid;
  output vb_wr;
  output eb_wr;
  output start_frame;
  input giu_axi_slave_awvalid;
  input giu_axi_slave_wvalid;
  input giu_axi_slave_aclk;
  input giu_axi_slave_rready;
  input giu_axi_slave_arvalid;
  input [11:0]giu_axi_slave_awaddr;
  input [31:0]giu_axi_slave_wdata;
  input [4:0]giu_axi_slave_araddr;
  input busy;
  input giu_axi_slave_aresetn;
  input frame_done;
  input giu_axi_slave_bready;

  wire \FSM_sequential_state_read[0]_i_1_n_0 ;
  wire \FSM_sequential_state_read[1]_i_1_n_0 ;
  wire \FSM_sequential_state_write[0]_i_1_n_0 ;
  wire \FSM_sequential_state_write[1]_i_1_n_0 ;
  wire [19:0]Q;
  wire [9:0]angle;
  wire \axi_araddr[13]_i_1_n_0 ;
  wire \axi_araddr_reg_n_0_[12] ;
  wire \axi_araddr_reg_n_0_[13] ;
  wire axi_arready_i_1_n_0;
  wire axi_arready_reg_0;
  wire [13:2]axi_awaddr;
  wire \axi_awaddr[13]_i_1_n_0 ;
  wire axi_awready_i_1_n_0;
  wire axi_awready_reg_0;
  wire axi_bvalid_i_1_n_0;
  wire axi_bvalid_i_2_n_0;
  wire axi_rvalid_i_1_n_0;
  wire axi_rvalid_reg_0;
  wire axi_wready_i_1_n_0;
  wire axi_wready_reg_0;
  wire busy;
  wire [9:0]eb_addr;
  wire \eb_addr[0]_i_1_n_0 ;
  wire \eb_addr[1]_i_1_n_0 ;
  wire \eb_addr[9]_i_1_n_0 ;
  wire eb_cs_i_1_n_0;
  wire [19:0]eb_dataIn;
  wire eb_wr;
  wire frame_done;
  wire giu_axi_slave_aclk;
  wire [4:0]giu_axi_slave_araddr;
  wire giu_axi_slave_aresetn;
  wire giu_axi_slave_arvalid;
  wire [11:0]giu_axi_slave_awaddr;
  wire giu_axi_slave_awvalid;
  wire giu_axi_slave_bready;
  wire giu_axi_slave_bvalid;
  wire [31:0]giu_axi_slave_rdata;
  wire \giu_axi_slave_rdata[0]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[10]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[11]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[12]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[13]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[14]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[15]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[16]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[17]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[18]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[19]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[1]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[20]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[21]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[22]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[23]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[24]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[25]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[26]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[27]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[28]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[29]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[2]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[30]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[31]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ;
  wire \giu_axi_slave_rdata[3]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[4]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[5]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[6]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[7]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[8]_INST_0_i_1_n_0 ;
  wire \giu_axi_slave_rdata[9]_INST_0_i_1_n_0 ;
  wire giu_axi_slave_rready;
  wire [31:0]giu_axi_slave_wdata;
  wire giu_axi_slave_wvalid;
  wire [63:0]p_1_in;
  wire [1:0]p_1_in_4;
  wire [2:0]sel0;
  wire [31:0]slv_reg0;
  wire slv_reg0_1;
  wire [1:0]slv_reg1;
  wire \slv_reg1[0]_i_1_n_0 ;
  wire \slv_reg1[1]_i_1_n_0 ;
  wire [31:20]slv_reg2;
  wire slv_reg2_0;
  wire [31:10]slv_reg3;
  wire slv_reg3_3;
  wire [31:4]slv_reg4;
  wire slv_reg4_2;
  wire [3:0]\slv_reg4_reg[3]_0 ;
  wire start_frame;
  wire start_frame_i_1_n_0;
  wire start_frame_i_2_n_0;
  wire [1:0]state_read;
  wire [1:0]state_write;
  wire temp_x;
  wire temp_y;
  wire [7:0]vb_addr;
  wire \vb_addr[0]_i_1_n_0 ;
  wire \vb_addr[1]_i_1_n_0 ;
  wire \vb_addr[2]_i_1_n_0 ;
  wire \vb_addr[3]_i_1_n_0 ;
  wire \vb_addr[4]_i_1_n_0 ;
  wire \vb_addr[5]_i_1_n_0 ;
  wire \vb_addr[6]_i_1_n_0 ;
  wire \vb_addr[7]_i_1_n_0 ;
  wire \vb_addr[7]_i_2_n_0 ;
  wire \vb_addr[7]_i_3_n_0 ;
  wire \vb_addr[7]_i_5_n_0 ;
  wire vb_cs_i_1_n_0;
  wire [95:0]vb_dataIn;
  wire vb_wr;

  LUT6 #(
    .INIT(64'hFFFF88880FFFFFFF)) 
    \FSM_sequential_state_read[0]_i_1 
       (.I0(giu_axi_slave_rready),
        .I1(axi_rvalid_reg_0),
        .I2(giu_axi_slave_arvalid),
        .I3(axi_arready_reg_0),
        .I4(state_read[0]),
        .I5(state_read[1]),
        .O(\FSM_sequential_state_read[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF7777F0000000)) 
    \FSM_sequential_state_read[1]_i_1 
       (.I0(axi_rvalid_reg_0),
        .I1(giu_axi_slave_rready),
        .I2(axi_arready_reg_0),
        .I3(giu_axi_slave_arvalid),
        .I4(state_read[0]),
        .I5(state_read[1]),
        .O(\FSM_sequential_state_read[1]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "Idle:00,Rdata:10,Raddr:01" *) 
  FDRE \FSM_sequential_state_read_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_state_read[0]_i_1_n_0 ),
        .Q(state_read[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "Idle:00,Rdata:10,Raddr:01" *) 
  FDRE \FSM_sequential_state_read_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_state_read[1]_i_1_n_0 ),
        .Q(state_read[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFF0F7FF)) 
    \FSM_sequential_state_write[0]_i_1 
       (.I0(axi_awready_reg_0),
        .I1(giu_axi_slave_awvalid),
        .I2(giu_axi_slave_wvalid),
        .I3(state_write[0]),
        .I4(state_write[1]),
        .O(\FSM_sequential_state_write[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFF0F0800)) 
    \FSM_sequential_state_write[1]_i_1 
       (.I0(giu_axi_slave_awvalid),
        .I1(axi_awready_reg_0),
        .I2(giu_axi_slave_wvalid),
        .I3(state_write[0]),
        .I4(state_write[1]),
        .O(\FSM_sequential_state_write[1]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "Idle:00,Wdata:10,Waddr:01" *) 
  FDRE \FSM_sequential_state_write_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_state_write[0]_i_1_n_0 ),
        .Q(state_write[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "Idle:00,Wdata:10,Waddr:01" *) 
  FDRE \FSM_sequential_state_write_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_state_write[1]_i_1_n_0 ),
        .Q(state_write[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h08000000)) 
    \axi_araddr[13]_i_1 
       (.I0(state_read[0]),
        .I1(giu_axi_slave_aresetn),
        .I2(state_read[1]),
        .I3(giu_axi_slave_arvalid),
        .I4(axi_arready_reg_0),
        .O(\axi_araddr[13]_i_1_n_0 ));
  FDRE \axi_araddr_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_araddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_araddr[3]),
        .Q(\axi_araddr_reg_n_0_[12] ),
        .R(1'b0));
  FDRE \axi_araddr_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_araddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_araddr[4]),
        .Q(\axi_araddr_reg_n_0_[13] ),
        .R(1'b0));
  FDRE \axi_araddr_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_araddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_araddr[0]),
        .Q(sel0[0]),
        .R(1'b0));
  FDRE \axi_araddr_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_araddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_araddr[1]),
        .Q(sel0[1]),
        .R(1'b0));
  FDRE \axi_araddr_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_araddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_araddr[2]),
        .Q(sel0[2]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFF55FFFF40554055)) 
    axi_arready_i_1
       (.I0(state_read[0]),
        .I1(giu_axi_slave_rready),
        .I2(axi_rvalid_reg_0),
        .I3(state_read[1]),
        .I4(giu_axi_slave_arvalid),
        .I5(axi_arready_reg_0),
        .O(axi_arready_i_1_n_0));
  FDRE axi_arready_reg
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(axi_arready_i_1_n_0),
        .Q(axi_arready_reg_0),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h4000)) 
    \axi_awaddr[13]_i_1 
       (.I0(state_write[1]),
        .I1(state_write[0]),
        .I2(giu_axi_slave_awvalid),
        .I3(axi_awready_reg_0),
        .O(\axi_awaddr[13]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[10] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[8]),
        .Q(axi_awaddr[10]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[11] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[9]),
        .Q(axi_awaddr[11]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[10]),
        .Q(axi_awaddr[12]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[11]),
        .Q(axi_awaddr[13]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[0]),
        .Q(axi_awaddr[2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[1]),
        .Q(axi_awaddr[3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[2]),
        .Q(axi_awaddr[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[3]),
        .Q(axi_awaddr[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[4]),
        .Q(axi_awaddr[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[5]),
        .Q(axi_awaddr[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[6]),
        .Q(axi_awaddr[8]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(\axi_awaddr[13]_i_1_n_0 ),
        .D(giu_axi_slave_awaddr[7]),
        .Q(axi_awaddr[9]),
        .R(\vb_addr[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hAFAAAF2F)) 
    axi_awready_i_1
       (.I0(axi_awready_reg_0),
        .I1(giu_axi_slave_awvalid),
        .I2(state_write[0]),
        .I3(giu_axi_slave_wvalid),
        .I4(state_write[1]),
        .O(axi_awready_i_1_n_0));
  FDRE axi_awready_reg
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(axi_awready_i_1_n_0),
        .Q(axi_awready_reg_0),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFA2FFFFF0A200A20)) 
    axi_bvalid_i_1
       (.I0(giu_axi_slave_wvalid),
        .I1(axi_bvalid_i_2_n_0),
        .I2(state_write[0]),
        .I3(state_write[1]),
        .I4(giu_axi_slave_bready),
        .I5(giu_axi_slave_bvalid),
        .O(axi_bvalid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h7)) 
    axi_bvalid_i_2
       (.I0(axi_awready_reg_0),
        .I1(giu_axi_slave_awvalid),
        .O(axi_bvalid_i_2_n_0));
  FDRE axi_bvalid_reg
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(axi_bvalid_i_1_n_0),
        .Q(giu_axi_slave_bvalid),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA2A2A2A2FAAAAAAA)) 
    axi_rvalid_i_1
       (.I0(axi_rvalid_reg_0),
        .I1(giu_axi_slave_rready),
        .I2(state_read[0]),
        .I3(axi_arready_reg_0),
        .I4(giu_axi_slave_arvalid),
        .I5(state_read[1]),
        .O(axi_rvalid_i_1_n_0));
  FDRE axi_rvalid_reg
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(axi_rvalid_i_1_n_0),
        .Q(axi_rvalid_reg_0),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hF1)) 
    axi_wready_i_1
       (.I0(state_write[1]),
        .I1(state_write[0]),
        .I2(axi_wready_reg_0),
        .O(axi_wready_i_1_n_0));
  FDRE axi_wready_reg
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(axi_wready_i_1_n_0),
        .Q(axi_wready_reg_0),
        .R(\vb_addr[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \eb_addr[0]_i_1 
       (.I0(giu_axi_slave_awaddr[0]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[2]),
        .O(\eb_addr[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \eb_addr[1]_i_1 
       (.I0(giu_axi_slave_awaddr[1]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[3]),
        .O(\eb_addr[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h4540000000000000)) 
    \eb_addr[9]_i_1 
       (.I0(p_1_in_4[0]),
        .I1(giu_axi_slave_awaddr[11]),
        .I2(giu_axi_slave_awvalid),
        .I3(axi_awaddr[13]),
        .I4(axi_wready_reg_0),
        .I5(giu_axi_slave_wvalid),
        .O(\eb_addr[9]_i_1_n_0 ));
  FDRE \eb_addr_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\eb_addr[0]_i_1_n_0 ),
        .Q(eb_addr[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_addr_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\eb_addr[1]_i_1_n_0 ),
        .Q(eb_addr[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_addr_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\vb_addr[0]_i_1_n_0 ),
        .Q(eb_addr[2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_addr_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\vb_addr[1]_i_1_n_0 ),
        .Q(eb_addr[3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_addr_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\vb_addr[2]_i_1_n_0 ),
        .Q(eb_addr[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_addr_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\vb_addr[3]_i_1_n_0 ),
        .Q(eb_addr[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_addr_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\vb_addr[4]_i_1_n_0 ),
        .Q(eb_addr[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_addr_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\vb_addr[5]_i_1_n_0 ),
        .Q(eb_addr[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_addr_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\vb_addr[6]_i_1_n_0 ),
        .Q(eb_addr[8]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_addr_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(\vb_addr[7]_i_3_n_0 ),
        .Q(eb_addr[9]),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00800000)) 
    eb_cs_i_1
       (.I0(p_1_in_4[1]),
        .I1(giu_axi_slave_wvalid),
        .I2(axi_wready_reg_0),
        .I3(p_1_in_4[0]),
        .I4(giu_axi_slave_aresetn),
        .O(eb_cs_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    eb_cs_i_2
       (.I0(giu_axi_slave_awaddr[11]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[13]),
        .O(p_1_in_4[1]));
  FDRE eb_cs_reg
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(eb_cs_i_1_n_0),
        .Q(eb_wr),
        .R(1'b0));
  FDRE \eb_dataIn_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[0]),
        .Q(eb_dataIn[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[10] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[10]),
        .Q(eb_dataIn[10]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[11] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[11]),
        .Q(eb_dataIn[11]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[12]),
        .Q(eb_dataIn[12]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[13]),
        .Q(eb_dataIn[13]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[14] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[14]),
        .Q(eb_dataIn[14]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[15] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[15]),
        .Q(eb_dataIn[15]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[16] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[16]),
        .Q(eb_dataIn[16]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[17] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[17]),
        .Q(eb_dataIn[17]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[18] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[18]),
        .Q(eb_dataIn[18]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[19] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[19]),
        .Q(eb_dataIn[19]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[1]),
        .Q(eb_dataIn[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[2]),
        .Q(eb_dataIn[2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[3]),
        .Q(eb_dataIn[3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[4]),
        .Q(eb_dataIn[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[5]),
        .Q(eb_dataIn[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[6]),
        .Q(eb_dataIn[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[7]),
        .Q(eb_dataIn[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[8]),
        .Q(eb_dataIn[8]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \eb_dataIn_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(\eb_addr[9]_i_1_n_0 ),
        .D(giu_axi_slave_wdata[9]),
        .Q(eb_dataIn[9]),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0F4F004000000000)) 
    \giu_axi_slave_rdata[0]_INST_0 
       (.I0(sel0[0]),
        .I1(\slv_reg4_reg[3]_0 [0]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[0]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[0]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \giu_axi_slave_rdata[0]_INST_0_i_1 
       (.I0(angle[0]),
        .I1(Q[0]),
        .I2(sel0[1]),
        .I3(slv_reg1[0]),
        .I4(sel0[0]),
        .I5(slv_reg0[0]),
        .O(\giu_axi_slave_rdata[0]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[10]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[10]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[10]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[10]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[10]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[10]),
        .I3(sel0[1]),
        .I4(Q[10]),
        .I5(slv_reg3[10]),
        .O(\giu_axi_slave_rdata[10]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[11]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[11]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[11]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[11]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[11]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[11]),
        .I3(sel0[1]),
        .I4(Q[11]),
        .I5(slv_reg3[11]),
        .O(\giu_axi_slave_rdata[11]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[12]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[12]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[12]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[12]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[12]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[12]),
        .I3(sel0[1]),
        .I4(Q[12]),
        .I5(slv_reg3[12]),
        .O(\giu_axi_slave_rdata[12]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[13]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[13]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[13]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[13]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[13]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[13]),
        .I3(sel0[1]),
        .I4(Q[13]),
        .I5(slv_reg3[13]),
        .O(\giu_axi_slave_rdata[13]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[14]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[14]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[14]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[14]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[14]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[14]),
        .I3(sel0[1]),
        .I4(Q[14]),
        .I5(slv_reg3[14]),
        .O(\giu_axi_slave_rdata[14]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[15]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[15]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[15]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[15]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[15]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[15]),
        .I3(sel0[1]),
        .I4(Q[15]),
        .I5(slv_reg3[15]),
        .O(\giu_axi_slave_rdata[15]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[16]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[16]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[16]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[16]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[16]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[16]),
        .I3(sel0[1]),
        .I4(Q[16]),
        .I5(slv_reg3[16]),
        .O(\giu_axi_slave_rdata[16]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[17]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[17]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[17]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[17]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[17]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[17]),
        .I3(sel0[1]),
        .I4(Q[17]),
        .I5(slv_reg3[17]),
        .O(\giu_axi_slave_rdata[17]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[18]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[18]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[18]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[18]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[18]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[18]),
        .I3(sel0[1]),
        .I4(Q[18]),
        .I5(slv_reg3[18]),
        .O(\giu_axi_slave_rdata[18]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[19]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[19]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[19]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[19]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[19]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[19]),
        .I3(sel0[1]),
        .I4(Q[19]),
        .I5(slv_reg3[19]),
        .O(\giu_axi_slave_rdata[19]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0F4F004000000000)) 
    \giu_axi_slave_rdata[1]_INST_0 
       (.I0(sel0[0]),
        .I1(\slv_reg4_reg[3]_0 [1]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[1]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[1]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \giu_axi_slave_rdata[1]_INST_0_i_1 
       (.I0(angle[1]),
        .I1(Q[1]),
        .I2(sel0[1]),
        .I3(slv_reg1[1]),
        .I4(sel0[0]),
        .I5(slv_reg0[1]),
        .O(\giu_axi_slave_rdata[1]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[20]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[20]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[20]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[20]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[20]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[20]),
        .I3(sel0[1]),
        .I4(slv_reg2[20]),
        .I5(slv_reg3[20]),
        .O(\giu_axi_slave_rdata[20]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[21]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[21]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[21]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[21]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[21]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[21]),
        .I3(sel0[1]),
        .I4(slv_reg2[21]),
        .I5(slv_reg3[21]),
        .O(\giu_axi_slave_rdata[21]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[22]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[22]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[22]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[22]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[22]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[22]),
        .I3(sel0[1]),
        .I4(slv_reg2[22]),
        .I5(slv_reg3[22]),
        .O(\giu_axi_slave_rdata[22]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[23]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[23]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[23]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[23]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[23]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[23]),
        .I3(sel0[1]),
        .I4(slv_reg2[23]),
        .I5(slv_reg3[23]),
        .O(\giu_axi_slave_rdata[23]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[24]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[24]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[24]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[24]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[24]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[24]),
        .I3(sel0[1]),
        .I4(slv_reg2[24]),
        .I5(slv_reg3[24]),
        .O(\giu_axi_slave_rdata[24]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[25]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[25]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[25]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[25]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[25]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[25]),
        .I3(sel0[1]),
        .I4(slv_reg2[25]),
        .I5(slv_reg3[25]),
        .O(\giu_axi_slave_rdata[25]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[26]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[26]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[26]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[26]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[26]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[26]),
        .I3(sel0[1]),
        .I4(slv_reg2[26]),
        .I5(slv_reg3[26]),
        .O(\giu_axi_slave_rdata[26]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[27]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[27]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[27]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[27]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[27]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[27]),
        .I3(sel0[1]),
        .I4(slv_reg2[27]),
        .I5(slv_reg3[27]),
        .O(\giu_axi_slave_rdata[27]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[28]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[28]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[28]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[28]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[28]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[28]),
        .I3(sel0[1]),
        .I4(slv_reg2[28]),
        .I5(slv_reg3[28]),
        .O(\giu_axi_slave_rdata[28]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[29]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[29]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[29]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[29]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[29]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[29]),
        .I3(sel0[1]),
        .I4(slv_reg2[29]),
        .I5(slv_reg3[29]),
        .O(\giu_axi_slave_rdata[29]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[2]_INST_0 
       (.I0(sel0[0]),
        .I1(\slv_reg4_reg[3]_0 [2]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[2]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[2]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[2]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[2]),
        .I3(sel0[1]),
        .I4(Q[2]),
        .I5(angle[2]),
        .O(\giu_axi_slave_rdata[2]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[30]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[30]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[30]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[30]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[30]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[30]),
        .I3(sel0[1]),
        .I4(slv_reg2[30]),
        .I5(slv_reg3[30]),
        .O(\giu_axi_slave_rdata[30]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[31]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[31]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[31]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[31]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[31]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[31]),
        .I3(sel0[1]),
        .I4(slv_reg2[31]),
        .I5(slv_reg3[31]),
        .O(\giu_axi_slave_rdata[31]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \giu_axi_slave_rdata[31]_INST_0_i_2 
       (.I0(\axi_araddr_reg_n_0_[13] ),
        .I1(\axi_araddr_reg_n_0_[12] ),
        .O(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[3]_INST_0 
       (.I0(sel0[0]),
        .I1(\slv_reg4_reg[3]_0 [3]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[3]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[3]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[3]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[3]),
        .I3(sel0[1]),
        .I4(Q[3]),
        .I5(angle[3]),
        .O(\giu_axi_slave_rdata[3]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[4]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[4]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[4]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[4]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[4]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[4]),
        .I3(sel0[1]),
        .I4(Q[4]),
        .I5(angle[4]),
        .O(\giu_axi_slave_rdata[4]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[5]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[5]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[5]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[5]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[5]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[5]),
        .I3(sel0[1]),
        .I4(Q[5]),
        .I5(angle[5]),
        .O(\giu_axi_slave_rdata[5]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[6]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[6]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[6]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[6]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[6]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[6]),
        .I3(sel0[1]),
        .I4(Q[6]),
        .I5(angle[6]),
        .O(\giu_axi_slave_rdata[6]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[7]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[7]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[7]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[7]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[7]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[7]),
        .I3(sel0[1]),
        .I4(Q[7]),
        .I5(angle[7]),
        .O(\giu_axi_slave_rdata[7]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[8]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[8]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[8]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[8]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[8]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[8]),
        .I3(sel0[1]),
        .I4(Q[8]),
        .I5(angle[8]),
        .O(\giu_axi_slave_rdata[8]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF4F004000000000)) 
    \giu_axi_slave_rdata[9]_INST_0 
       (.I0(sel0[0]),
        .I1(slv_reg4[9]),
        .I2(sel0[2]),
        .I3(sel0[1]),
        .I4(\giu_axi_slave_rdata[9]_INST_0_i_1_n_0 ),
        .I5(\giu_axi_slave_rdata[31]_INST_0_i_2_n_0 ),
        .O(giu_axi_slave_rdata[9]));
  LUT6 #(
    .INIT(64'h5510441011100010)) 
    \giu_axi_slave_rdata[9]_INST_0_i_1 
       (.I0(sel0[2]),
        .I1(sel0[0]),
        .I2(slv_reg0[9]),
        .I3(sel0[1]),
        .I4(Q[9]),
        .I5(angle[9]),
        .O(\giu_axi_slave_rdata[9]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0004440400000000)) 
    \slv_reg0[31]_i_1 
       (.I0(\eb_addr[1]_i_1_n_0 ),
        .I1(\vb_addr[7]_i_5_n_0 ),
        .I2(axi_awaddr[2]),
        .I3(giu_axi_slave_awvalid),
        .I4(giu_axi_slave_awaddr[0]),
        .I5(start_frame_i_2_n_0),
        .O(slv_reg0_1));
  FDRE \slv_reg0_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[0]),
        .Q(slv_reg0[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[10] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[10]),
        .Q(slv_reg0[10]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[11] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[11]),
        .Q(slv_reg0[11]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[12]),
        .Q(slv_reg0[12]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[13]),
        .Q(slv_reg0[13]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[14] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[14]),
        .Q(slv_reg0[14]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[15] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[15]),
        .Q(slv_reg0[15]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[16] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[16]),
        .Q(slv_reg0[16]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[17] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[17]),
        .Q(slv_reg0[17]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[18] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[18]),
        .Q(slv_reg0[18]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[19] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[19]),
        .Q(slv_reg0[19]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[1]),
        .Q(slv_reg0[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[20] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[20]),
        .Q(slv_reg0[20]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[21] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[21]),
        .Q(slv_reg0[21]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[22] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[22]),
        .Q(slv_reg0[22]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[23] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[23]),
        .Q(slv_reg0[23]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[24] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[24]),
        .Q(slv_reg0[24]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[25] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[25]),
        .Q(slv_reg0[25]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[26] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[26]),
        .Q(slv_reg0[26]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[27] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[27]),
        .Q(slv_reg0[27]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[28] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[28]),
        .Q(slv_reg0[28]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[29] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[29]),
        .Q(slv_reg0[29]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[2]),
        .Q(slv_reg0[2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[30] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[30]),
        .Q(slv_reg0[30]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[31] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[31]),
        .Q(slv_reg0[31]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[3]),
        .Q(slv_reg0[3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[4]),
        .Q(slv_reg0[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[5]),
        .Q(slv_reg0[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[6]),
        .Q(slv_reg0[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[7]),
        .Q(slv_reg0[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[8]),
        .Q(slv_reg0[8]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg0_1),
        .D(giu_axi_slave_wdata[9]),
        .Q(slv_reg0[9]),
        .R(\vb_addr[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \slv_reg1[0]_i_1 
       (.I0(frame_done),
        .I1(giu_axi_slave_aresetn),
        .I2(slv_reg1[0]),
        .O(\slv_reg1[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \slv_reg1[1]_i_1 
       (.I0(busy),
        .I1(giu_axi_slave_aresetn),
        .I2(slv_reg1[1]),
        .O(\slv_reg1[1]_i_1_n_0 ));
  FDRE \slv_reg1_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(\slv_reg1[0]_i_1_n_0 ),
        .Q(slv_reg1[0]),
        .R(1'b0));
  FDRE \slv_reg1_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(\slv_reg1[1]_i_1_n_0 ),
        .Q(slv_reg1[1]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0800088800000000)) 
    \slv_reg2[9]_i_1 
       (.I0(\eb_addr[1]_i_1_n_0 ),
        .I1(start_frame_i_2_n_0),
        .I2(giu_axi_slave_awaddr[0]),
        .I3(giu_axi_slave_awvalid),
        .I4(axi_awaddr[2]),
        .I5(\vb_addr[7]_i_5_n_0 ),
        .O(slv_reg2_0));
  FDRE \slv_reg2_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[0]),
        .Q(Q[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[10] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[10]),
        .Q(Q[10]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[11] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[11]),
        .Q(Q[11]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[12]),
        .Q(Q[12]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[13]),
        .Q(Q[13]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[14] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[14]),
        .Q(Q[14]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[15] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[15]),
        .Q(Q[15]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[16] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[16]),
        .Q(Q[16]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[17] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[17]),
        .Q(Q[17]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[18] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[18]),
        .Q(Q[18]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[19] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[19]),
        .Q(Q[19]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[1]),
        .Q(Q[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[20] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[20]),
        .Q(slv_reg2[20]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[21] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[21]),
        .Q(slv_reg2[21]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[22] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[22]),
        .Q(slv_reg2[22]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[23] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[23]),
        .Q(slv_reg2[23]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[24] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[24]),
        .Q(slv_reg2[24]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[25] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[25]),
        .Q(slv_reg2[25]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[26] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[26]),
        .Q(slv_reg2[26]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[27] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[27]),
        .Q(slv_reg2[27]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[28] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[28]),
        .Q(slv_reg2[28]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[29] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[29]),
        .Q(slv_reg2[29]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[2]),
        .Q(Q[2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[30] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[30]),
        .Q(slv_reg2[30]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[31] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[31]),
        .Q(slv_reg2[31]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[3]),
        .Q(Q[3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[4]),
        .Q(Q[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[5]),
        .Q(Q[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[6]),
        .Q(Q[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[7]),
        .Q(Q[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[8]),
        .Q(Q[8]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg2_0),
        .D(giu_axi_slave_wdata[9]),
        .Q(Q[9]),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA808000000000000)) 
    \slv_reg3[9]_i_1 
       (.I0(\vb_addr[7]_i_5_n_0 ),
        .I1(axi_awaddr[2]),
        .I2(giu_axi_slave_awvalid),
        .I3(giu_axi_slave_awaddr[0]),
        .I4(\eb_addr[1]_i_1_n_0 ),
        .I5(start_frame_i_2_n_0),
        .O(slv_reg3_3));
  FDRE \slv_reg3_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[0]),
        .Q(angle[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[10] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[10]),
        .Q(slv_reg3[10]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[11] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[11]),
        .Q(slv_reg3[11]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[12]),
        .Q(slv_reg3[12]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[13]),
        .Q(slv_reg3[13]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[14] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[14]),
        .Q(slv_reg3[14]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[15] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[15]),
        .Q(slv_reg3[15]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[16] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[16]),
        .Q(slv_reg3[16]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[17] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[17]),
        .Q(slv_reg3[17]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[18] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[18]),
        .Q(slv_reg3[18]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[19] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[19]),
        .Q(slv_reg3[19]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[1]),
        .Q(angle[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[20] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[20]),
        .Q(slv_reg3[20]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[21] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[21]),
        .Q(slv_reg3[21]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[22] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[22]),
        .Q(slv_reg3[22]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[23] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[23]),
        .Q(slv_reg3[23]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[24] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[24]),
        .Q(slv_reg3[24]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[25] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[25]),
        .Q(slv_reg3[25]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[26] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[26]),
        .Q(slv_reg3[26]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[27] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[27]),
        .Q(slv_reg3[27]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[28] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[28]),
        .Q(slv_reg3[28]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[29] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[29]),
        .Q(slv_reg3[29]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[2]),
        .Q(angle[2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[30] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[30]),
        .Q(slv_reg3[30]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[31] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[31]),
        .Q(slv_reg3[31]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[3]),
        .Q(angle[3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[4]),
        .Q(angle[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[5]),
        .Q(angle[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[6]),
        .Q(angle[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[7]),
        .Q(angle[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[8]),
        .Q(angle[8]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg3_3),
        .D(giu_axi_slave_wdata[9]),
        .Q(angle[9]),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000400)) 
    \slv_reg4[2]_i_1 
       (.I0(p_1_in_4[0]),
        .I1(\vb_addr[0]_i_1_n_0 ),
        .I2(\eb_addr[1]_i_1_n_0 ),
        .I3(\vb_addr[7]_i_5_n_0 ),
        .I4(\eb_addr[0]_i_1_n_0 ),
        .O(slv_reg4_2));
  FDRE \slv_reg4_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[0]),
        .Q(\slv_reg4_reg[3]_0 [0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[10] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[10]),
        .Q(slv_reg4[10]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[11] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[11]),
        .Q(slv_reg4[11]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[12]),
        .Q(slv_reg4[12]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[13]),
        .Q(slv_reg4[13]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[14] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[14]),
        .Q(slv_reg4[14]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[15] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[15]),
        .Q(slv_reg4[15]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[16] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[16]),
        .Q(slv_reg4[16]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[17] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[17]),
        .Q(slv_reg4[17]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[18] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[18]),
        .Q(slv_reg4[18]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[19] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[19]),
        .Q(slv_reg4[19]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[1]),
        .Q(\slv_reg4_reg[3]_0 [1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[20] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[20]),
        .Q(slv_reg4[20]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[21] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[21]),
        .Q(slv_reg4[21]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[22] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[22]),
        .Q(slv_reg4[22]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[23] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[23]),
        .Q(slv_reg4[23]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[24] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[24]),
        .Q(slv_reg4[24]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[25] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[25]),
        .Q(slv_reg4[25]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[26] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[26]),
        .Q(slv_reg4[26]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[27] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[27]),
        .Q(slv_reg4[27]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[28] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[28]),
        .Q(slv_reg4[28]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[29] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[29]),
        .Q(slv_reg4[29]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[2]),
        .Q(\slv_reg4_reg[3]_0 [2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[30] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[30]),
        .Q(slv_reg4[30]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[31] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[31]),
        .Q(slv_reg4[31]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[3]),
        .Q(\slv_reg4_reg[3]_0 [3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[4]),
        .Q(slv_reg4[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[5]),
        .Q(slv_reg4[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[6]),
        .Q(slv_reg4[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[7]),
        .Q(slv_reg4[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[8]),
        .Q(slv_reg4[8]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(slv_reg4_2),
        .D(giu_axi_slave_wdata[9]),
        .Q(slv_reg4[9]),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000800000)) 
    start_frame_i_1
       (.I0(start_frame_i_2_n_0),
        .I1(giu_axi_slave_wdata[0]),
        .I2(giu_axi_slave_aresetn),
        .I3(\eb_addr[1]_i_1_n_0 ),
        .I4(\vb_addr[7]_i_5_n_0 ),
        .I5(\eb_addr[0]_i_1_n_0 ),
        .O(start_frame_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00053305)) 
    start_frame_i_2
       (.I0(axi_awaddr[4]),
        .I1(giu_axi_slave_awaddr[2]),
        .I2(axi_awaddr[12]),
        .I3(giu_axi_slave_awvalid),
        .I4(giu_axi_slave_awaddr[10]),
        .O(start_frame_i_2_n_0));
  FDRE start_frame_reg
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(start_frame_i_1_n_0),
        .Q(start_frame),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0004440400000000)) 
    \temp_x[31]_i_1 
       (.I0(\eb_addr[1]_i_1_n_0 ),
        .I1(\vb_addr[7]_i_5_n_0 ),
        .I2(axi_awaddr[2]),
        .I3(giu_axi_slave_awvalid),
        .I4(giu_axi_slave_awaddr[0]),
        .I5(p_1_in_4[0]),
        .O(temp_x));
  FDRE \temp_x_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[0]),
        .Q(p_1_in[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[10] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[10]),
        .Q(p_1_in[10]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[11] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[11]),
        .Q(p_1_in[11]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[12]),
        .Q(p_1_in[12]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[13]),
        .Q(p_1_in[13]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[14] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[14]),
        .Q(p_1_in[14]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[15] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[15]),
        .Q(p_1_in[15]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[16] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[16]),
        .Q(p_1_in[16]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[17] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[17]),
        .Q(p_1_in[17]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[18] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[18]),
        .Q(p_1_in[18]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[19] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[19]),
        .Q(p_1_in[19]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[1]),
        .Q(p_1_in[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[20] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[20]),
        .Q(p_1_in[20]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[21] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[21]),
        .Q(p_1_in[21]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[22] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[22]),
        .Q(p_1_in[22]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[23] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[23]),
        .Q(p_1_in[23]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[24] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[24]),
        .Q(p_1_in[24]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[25] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[25]),
        .Q(p_1_in[25]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[26] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[26]),
        .Q(p_1_in[26]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[27] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[27]),
        .Q(p_1_in[27]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[28] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[28]),
        .Q(p_1_in[28]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[29] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[29]),
        .Q(p_1_in[29]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[2]),
        .Q(p_1_in[2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[30] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[30]),
        .Q(p_1_in[30]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[31] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[31]),
        .Q(p_1_in[31]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[3]),
        .Q(p_1_in[3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[4]),
        .Q(p_1_in[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[5]),
        .Q(p_1_in[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[6]),
        .Q(p_1_in[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[7]),
        .Q(p_1_in[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[8]),
        .Q(p_1_in[8]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_x_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_x),
        .D(giu_axi_slave_wdata[9]),
        .Q(p_1_in[9]),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000B80000000000)) 
    \temp_y[31]_i_1 
       (.I0(giu_axi_slave_awaddr[0]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[2]),
        .I3(p_1_in_4[0]),
        .I4(\eb_addr[1]_i_1_n_0 ),
        .I5(\vb_addr[7]_i_5_n_0 ),
        .O(temp_y));
  FDRE \temp_y_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[0]),
        .Q(p_1_in[32]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[10] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[10]),
        .Q(p_1_in[42]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[11] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[11]),
        .Q(p_1_in[43]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[12]),
        .Q(p_1_in[44]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[13]),
        .Q(p_1_in[45]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[14] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[14]),
        .Q(p_1_in[46]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[15] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[15]),
        .Q(p_1_in[47]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[16] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[16]),
        .Q(p_1_in[48]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[17] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[17]),
        .Q(p_1_in[49]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[18] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[18]),
        .Q(p_1_in[50]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[19] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[19]),
        .Q(p_1_in[51]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[1]),
        .Q(p_1_in[33]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[20] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[20]),
        .Q(p_1_in[52]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[21] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[21]),
        .Q(p_1_in[53]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[22] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[22]),
        .Q(p_1_in[54]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[23] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[23]),
        .Q(p_1_in[55]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[24] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[24]),
        .Q(p_1_in[56]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[25] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[25]),
        .Q(p_1_in[57]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[26] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[26]),
        .Q(p_1_in[58]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[27] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[27]),
        .Q(p_1_in[59]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[28] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[28]),
        .Q(p_1_in[60]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[29] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[29]),
        .Q(p_1_in[61]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[2]),
        .Q(p_1_in[34]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[30] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[30]),
        .Q(p_1_in[62]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[31] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[31]),
        .Q(p_1_in[63]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[3]),
        .Q(p_1_in[35]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[4]),
        .Q(p_1_in[36]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[5]),
        .Q(p_1_in[37]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[6]),
        .Q(p_1_in[38]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[7]),
        .Q(p_1_in[39]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[8]),
        .Q(p_1_in[40]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \temp_y_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(temp_y),
        .D(giu_axi_slave_wdata[9]),
        .Q(p_1_in[41]),
        .R(\vb_addr[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vb_addr[0]_i_1 
       (.I0(giu_axi_slave_awaddr[2]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[4]),
        .O(\vb_addr[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vb_addr[1]_i_1 
       (.I0(giu_axi_slave_awaddr[3]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[5]),
        .O(\vb_addr[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vb_addr[2]_i_1 
       (.I0(giu_axi_slave_awaddr[4]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[6]),
        .O(\vb_addr[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vb_addr[3]_i_1 
       (.I0(giu_axi_slave_awaddr[5]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[7]),
        .O(\vb_addr[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vb_addr[4]_i_1 
       (.I0(giu_axi_slave_awaddr[6]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[8]),
        .O(\vb_addr[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vb_addr[5]_i_1 
       (.I0(giu_axi_slave_awaddr[7]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[9]),
        .O(\vb_addr[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vb_addr[6]_i_1 
       (.I0(giu_axi_slave_awaddr[8]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[10]),
        .O(\vb_addr[6]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \vb_addr[7]_i_1 
       (.I0(giu_axi_slave_aresetn),
        .O(\vb_addr[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0800088800000000)) 
    \vb_addr[7]_i_2 
       (.I0(\eb_addr[1]_i_1_n_0 ),
        .I1(p_1_in_4[0]),
        .I2(giu_axi_slave_awaddr[0]),
        .I3(giu_axi_slave_awvalid),
        .I4(axi_awaddr[2]),
        .I5(\vb_addr[7]_i_5_n_0 ),
        .O(\vb_addr[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vb_addr[7]_i_3 
       (.I0(giu_axi_slave_awaddr[9]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[11]),
        .O(\vb_addr[7]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vb_addr[7]_i_4 
       (.I0(giu_axi_slave_awaddr[10]),
        .I1(giu_axi_slave_awvalid),
        .I2(axi_awaddr[12]),
        .O(p_1_in_4[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00088808)) 
    \vb_addr[7]_i_5 
       (.I0(axi_wready_reg_0),
        .I1(giu_axi_slave_wvalid),
        .I2(axi_awaddr[13]),
        .I3(giu_axi_slave_awvalid),
        .I4(giu_axi_slave_awaddr[11]),
        .O(\vb_addr[7]_i_5_n_0 ));
  FDRE \vb_addr_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(\vb_addr[0]_i_1_n_0 ),
        .Q(vb_addr[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_addr_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(\vb_addr[1]_i_1_n_0 ),
        .Q(vb_addr[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_addr_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(\vb_addr[2]_i_1_n_0 ),
        .Q(vb_addr[2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_addr_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(\vb_addr[3]_i_1_n_0 ),
        .Q(vb_addr[3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_addr_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(\vb_addr[4]_i_1_n_0 ),
        .Q(vb_addr[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_addr_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(\vb_addr[5]_i_1_n_0 ),
        .Q(vb_addr[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_addr_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(\vb_addr[6]_i_1_n_0 ),
        .Q(vb_addr[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_addr_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(\vb_addr[7]_i_3_n_0 ),
        .Q(vb_addr[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00800000)) 
    vb_cs_i_1
       (.I0(p_1_in_4[0]),
        .I1(\eb_addr[1]_i_1_n_0 ),
        .I2(giu_axi_slave_aresetn),
        .I3(\eb_addr[0]_i_1_n_0 ),
        .I4(\vb_addr[7]_i_5_n_0 ),
        .O(vb_cs_i_1_n_0));
  FDRE vb_cs_reg
       (.C(giu_axi_slave_aclk),
        .CE(1'b1),
        .D(vb_cs_i_1_n_0),
        .Q(vb_wr),
        .R(1'b0));
  FDRE \vb_dataIn_reg[0] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[0]),
        .Q(vb_dataIn[0]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[10] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[10]),
        .Q(vb_dataIn[10]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[11] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[11]),
        .Q(vb_dataIn[11]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[12] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[12]),
        .Q(vb_dataIn[12]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[13] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[13]),
        .Q(vb_dataIn[13]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[14] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[14]),
        .Q(vb_dataIn[14]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[15] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[15]),
        .Q(vb_dataIn[15]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[16] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[16]),
        .Q(vb_dataIn[16]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[17] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[17]),
        .Q(vb_dataIn[17]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[18] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[18]),
        .Q(vb_dataIn[18]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[19] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[19]),
        .Q(vb_dataIn[19]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[1] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[1]),
        .Q(vb_dataIn[1]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[20] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[20]),
        .Q(vb_dataIn[20]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[21] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[21]),
        .Q(vb_dataIn[21]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[22] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[22]),
        .Q(vb_dataIn[22]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[23] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[23]),
        .Q(vb_dataIn[23]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[24] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[24]),
        .Q(vb_dataIn[24]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[25] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[25]),
        .Q(vb_dataIn[25]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[26] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[26]),
        .Q(vb_dataIn[26]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[27] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[27]),
        .Q(vb_dataIn[27]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[28] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[28]),
        .Q(vb_dataIn[28]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[29] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[29]),
        .Q(vb_dataIn[29]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[2] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[2]),
        .Q(vb_dataIn[2]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[30] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[30]),
        .Q(vb_dataIn[30]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[31] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[31]),
        .Q(vb_dataIn[31]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[32] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[32]),
        .Q(vb_dataIn[32]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[33] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[33]),
        .Q(vb_dataIn[33]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[34] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[34]),
        .Q(vb_dataIn[34]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[35] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[35]),
        .Q(vb_dataIn[35]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[36] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[36]),
        .Q(vb_dataIn[36]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[37] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[37]),
        .Q(vb_dataIn[37]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[38] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[38]),
        .Q(vb_dataIn[38]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[39] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[39]),
        .Q(vb_dataIn[39]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[3] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[3]),
        .Q(vb_dataIn[3]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[40] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[40]),
        .Q(vb_dataIn[40]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[41] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[41]),
        .Q(vb_dataIn[41]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[42] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[42]),
        .Q(vb_dataIn[42]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[43] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[43]),
        .Q(vb_dataIn[43]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[44] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[44]),
        .Q(vb_dataIn[44]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[45] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[45]),
        .Q(vb_dataIn[45]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[46] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[46]),
        .Q(vb_dataIn[46]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[47] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[47]),
        .Q(vb_dataIn[47]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[48] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[48]),
        .Q(vb_dataIn[48]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[49] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[49]),
        .Q(vb_dataIn[49]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[4] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[4]),
        .Q(vb_dataIn[4]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[50] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[50]),
        .Q(vb_dataIn[50]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[51] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[51]),
        .Q(vb_dataIn[51]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[52] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[52]),
        .Q(vb_dataIn[52]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[53] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[53]),
        .Q(vb_dataIn[53]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[54] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[54]),
        .Q(vb_dataIn[54]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[55] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[55]),
        .Q(vb_dataIn[55]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[56] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[56]),
        .Q(vb_dataIn[56]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[57] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[57]),
        .Q(vb_dataIn[57]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[58] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[58]),
        .Q(vb_dataIn[58]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[59] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[59]),
        .Q(vb_dataIn[59]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[5] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[5]),
        .Q(vb_dataIn[5]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[60] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[60]),
        .Q(vb_dataIn[60]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[61] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[61]),
        .Q(vb_dataIn[61]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[62] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[62]),
        .Q(vb_dataIn[62]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[63] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[63]),
        .Q(vb_dataIn[63]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[64] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[0]),
        .Q(vb_dataIn[64]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[65] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[1]),
        .Q(vb_dataIn[65]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[66] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[2]),
        .Q(vb_dataIn[66]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[67] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[3]),
        .Q(vb_dataIn[67]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[68] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[4]),
        .Q(vb_dataIn[68]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[69] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[5]),
        .Q(vb_dataIn[69]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[6] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[6]),
        .Q(vb_dataIn[6]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[70] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[6]),
        .Q(vb_dataIn[70]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[71] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[7]),
        .Q(vb_dataIn[71]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[72] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[8]),
        .Q(vb_dataIn[72]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[73] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[9]),
        .Q(vb_dataIn[73]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[74] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[10]),
        .Q(vb_dataIn[74]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[75] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[11]),
        .Q(vb_dataIn[75]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[76] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[12]),
        .Q(vb_dataIn[76]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[77] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[13]),
        .Q(vb_dataIn[77]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[78] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[14]),
        .Q(vb_dataIn[78]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[79] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[15]),
        .Q(vb_dataIn[79]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[7] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[7]),
        .Q(vb_dataIn[7]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[80] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[16]),
        .Q(vb_dataIn[80]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[81] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[17]),
        .Q(vb_dataIn[81]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[82] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[18]),
        .Q(vb_dataIn[82]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[83] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[19]),
        .Q(vb_dataIn[83]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[84] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[20]),
        .Q(vb_dataIn[84]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[85] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[21]),
        .Q(vb_dataIn[85]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[86] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[22]),
        .Q(vb_dataIn[86]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[87] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[23]),
        .Q(vb_dataIn[87]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[88] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[24]),
        .Q(vb_dataIn[88]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[89] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[25]),
        .Q(vb_dataIn[89]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[8] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[8]),
        .Q(vb_dataIn[8]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[90] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[26]),
        .Q(vb_dataIn[90]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[91] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[27]),
        .Q(vb_dataIn[91]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[92] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[28]),
        .Q(vb_dataIn[92]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[93] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[29]),
        .Q(vb_dataIn[93]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[94] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[30]),
        .Q(vb_dataIn[94]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[95] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(giu_axi_slave_wdata[31]),
        .Q(vb_dataIn[95]),
        .R(\vb_addr[7]_i_1_n_0 ));
  FDRE \vb_dataIn_reg[9] 
       (.C(giu_axi_slave_aclk),
        .CE(\vb_addr[7]_i_2_n_0 ),
        .D(p_1_in[9]),
        .Q(vb_dataIn[9]),
        .R(\vb_addr[7]_i_1_n_0 ));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
