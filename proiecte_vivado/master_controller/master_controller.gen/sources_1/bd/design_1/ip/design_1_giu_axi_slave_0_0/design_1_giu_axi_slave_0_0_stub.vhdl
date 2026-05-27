-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
-- Date        : Tue May 26 15:06:38 2026
-- Host        : nemesiseanu running 64-bit Linux Mint 22.3
-- Command     : write_vhdl -force -mode synth_stub
--               /home/user/Desktop/Personal_Stuff/Homework/an4/LICENTA/licenta_repo/proiecte_vivado/master_controller/master_controller.gen/sources_1/bd/design_1/ip/design_1_giu_axi_slave_0_0/design_1_giu_axi_slave_0_0_stub.vhdl
-- Design      : design_1_giu_axi_slave_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_giu_axi_slave_0_0 is
  Port ( 
    vb_addr : out STD_LOGIC_VECTOR ( 7 downto 0 );
    vb_cs : out STD_LOGIC;
    vb_wr : out STD_LOGIC;
    vb_dataIn : out STD_LOGIC_VECTOR ( 95 downto 0 );
    eb_addr : out STD_LOGIC_VECTOR ( 9 downto 0 );
    eb_cs : out STD_LOGIC;
    eb_wr : out STD_LOGIC;
    eb_dataIn : out STD_LOGIC_VECTOR ( 19 downto 0 );
    start_frame : out STD_LOGIC;
    vertex_count : out STD_LOGIC_VECTOR ( 9 downto 0 );
    edge_count : out STD_LOGIC_VECTOR ( 9 downto 0 );
    angle : out STD_LOGIC_VECTOR ( 9 downto 0 );
    rotation_type : out STD_LOGIC_VECTOR ( 2 downto 0 );
    pause : out STD_LOGIC;
    frame_done : in STD_LOGIC;
    busy : in STD_LOGIC;
    giu_axi_slave_aclk : in STD_LOGIC;
    giu_axi_slave_aresetn : in STD_LOGIC;
    giu_axi_slave_awaddr : in STD_LOGIC_VECTOR ( 13 downto 0 );
    giu_axi_slave_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    giu_axi_slave_awvalid : in STD_LOGIC;
    giu_axi_slave_awready : out STD_LOGIC;
    giu_axi_slave_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    giu_axi_slave_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    giu_axi_slave_wvalid : in STD_LOGIC;
    giu_axi_slave_wready : out STD_LOGIC;
    giu_axi_slave_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    giu_axi_slave_bvalid : out STD_LOGIC;
    giu_axi_slave_bready : in STD_LOGIC;
    giu_axi_slave_araddr : in STD_LOGIC_VECTOR ( 13 downto 0 );
    giu_axi_slave_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    giu_axi_slave_arvalid : in STD_LOGIC;
    giu_axi_slave_arready : out STD_LOGIC;
    giu_axi_slave_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    giu_axi_slave_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    giu_axi_slave_rvalid : out STD_LOGIC;
    giu_axi_slave_rready : in STD_LOGIC
  );

end design_1_giu_axi_slave_0_0;

architecture stub of design_1_giu_axi_slave_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "vb_addr[7:0],vb_cs,vb_wr,vb_dataIn[95:0],eb_addr[9:0],eb_cs,eb_wr,eb_dataIn[19:0],start_frame,vertex_count[9:0],edge_count[9:0],angle[9:0],rotation_type[2:0],pause,frame_done,busy,giu_axi_slave_aclk,giu_axi_slave_aresetn,giu_axi_slave_awaddr[13:0],giu_axi_slave_awprot[2:0],giu_axi_slave_awvalid,giu_axi_slave_awready,giu_axi_slave_wdata[31:0],giu_axi_slave_wstrb[3:0],giu_axi_slave_wvalid,giu_axi_slave_wready,giu_axi_slave_bresp[1:0],giu_axi_slave_bvalid,giu_axi_slave_bready,giu_axi_slave_araddr[13:0],giu_axi_slave_arprot[2:0],giu_axi_slave_arvalid,giu_axi_slave_arready,giu_axi_slave_rdata[31:0],giu_axi_slave_rresp[1:0],giu_axi_slave_rvalid,giu_axi_slave_rready";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "giu_axi_slave,Vivado 2024.1";
begin
end;
