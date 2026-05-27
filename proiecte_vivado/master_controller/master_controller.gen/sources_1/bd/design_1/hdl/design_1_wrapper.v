//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
//Date        : Tue May 26 15:51:32 2026
//Host        : nemesiseanu running 64-bit Linux Mint 22.3
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FCLK_CLK0,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    angle_0,
    busy_0,
    eb_addr_0,
    eb_cs_0,
    eb_dataIn_0,
    eb_wr_0,
    edge_count_0,
    frame_done_0,
    pause_0,
    rotation_type_0,
    start_frame_0,
    vb_addr_0,
    vb_cs_0,
    vb_dataIn_0,
    vb_wr_0,
    vertex_count_0);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  output FCLK_CLK0;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  output [9:0]angle_0;
  input busy_0;
  output [9:0]eb_addr_0;
  output eb_cs_0;
  output [19:0]eb_dataIn_0;
  output eb_wr_0;
  output [9:0]edge_count_0;
  input frame_done_0;
  output pause_0;
  output [2:0]rotation_type_0;
  output start_frame_0;
  output [7:0]vb_addr_0;
  output vb_cs_0;
  output [95:0]vb_dataIn_0;
  output vb_wr_0;
  output [9:0]vertex_count_0;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FCLK_CLK0;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [9:0]angle_0;
  wire busy_0;
  wire [9:0]eb_addr_0;
  wire eb_cs_0;
  wire [19:0]eb_dataIn_0;
  wire eb_wr_0;
  wire [9:0]edge_count_0;
  wire frame_done_0;
  wire pause_0;
  wire [2:0]rotation_type_0;
  wire start_frame_0;
  wire [7:0]vb_addr_0;
  wire vb_cs_0;
  wire [95:0]vb_dataIn_0;
  wire vb_wr_0;
  wire [9:0]vertex_count_0;

  design_1 design_1_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FCLK_CLK0(FCLK_CLK0),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .angle_0(angle_0),
        .busy_0(busy_0),
        .eb_addr_0(eb_addr_0),
        .eb_cs_0(eb_cs_0),
        .eb_dataIn_0(eb_dataIn_0),
        .eb_wr_0(eb_wr_0),
        .edge_count_0(edge_count_0),
        .frame_done_0(frame_done_0),
        .pause_0(pause_0),
        .rotation_type_0(rotation_type_0),
        .start_frame_0(start_frame_0),
        .vb_addr_0(vb_addr_0),
        .vb_cs_0(vb_cs_0),
        .vb_dataIn_0(vb_dataIn_0),
        .vb_wr_0(vb_wr_0),
        .vertex_count_0(vertex_count_0));
endmodule
