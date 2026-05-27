-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
-- Date        : Tue May 26 15:06:38 2026
-- Host        : nemesiseanu running 64-bit Linux Mint 22.3
-- Command     : write_vhdl -force -mode funcsim
--               /home/user/Desktop/Personal_Stuff/Homework/an4/LICENTA/licenta_repo/proiecte_vivado/master_controller/master_controller.gen/sources_1/bd/design_1/ip/design_1_giu_axi_slave_0_0/design_1_giu_axi_slave_0_0_sim_netlist.vhdl
-- Design      : design_1_giu_axi_slave_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_giu_axi_slave_0_0_giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE is
  port (
    axi_awready_reg_0 : out STD_LOGIC;
    axi_rvalid_reg_0 : out STD_LOGIC;
    axi_arready_reg_0 : out STD_LOGIC;
    vb_addr : out STD_LOGIC_VECTOR ( 7 downto 0 );
    vb_dataIn : out STD_LOGIC_VECTOR ( 95 downto 0 );
    eb_addr : out STD_LOGIC_VECTOR ( 9 downto 0 );
    eb_dataIn : out STD_LOGIC_VECTOR ( 19 downto 0 );
    Q : out STD_LOGIC_VECTOR ( 19 downto 0 );
    angle : out STD_LOGIC_VECTOR ( 9 downto 0 );
    \slv_reg4_reg[3]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_wready_reg_0 : out STD_LOGIC;
    giu_axi_slave_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    giu_axi_slave_bvalid : out STD_LOGIC;
    vb_wr : out STD_LOGIC;
    eb_wr : out STD_LOGIC;
    start_frame : out STD_LOGIC;
    giu_axi_slave_awvalid : in STD_LOGIC;
    giu_axi_slave_wvalid : in STD_LOGIC;
    giu_axi_slave_aclk : in STD_LOGIC;
    giu_axi_slave_rready : in STD_LOGIC;
    giu_axi_slave_arvalid : in STD_LOGIC;
    giu_axi_slave_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    giu_axi_slave_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    giu_axi_slave_araddr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    busy : in STD_LOGIC;
    giu_axi_slave_aresetn : in STD_LOGIC;
    frame_done : in STD_LOGIC;
    giu_axi_slave_bready : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_giu_axi_slave_0_0_giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE : entity is "giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE";
end design_1_giu_axi_slave_0_0_giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE;

architecture STRUCTURE of design_1_giu_axi_slave_0_0_giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE is
  signal \FSM_sequential_state_read[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state_read[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state_write[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state_write[1]_i_1_n_0\ : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal \^angle\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \axi_araddr[13]_i_1_n_0\ : STD_LOGIC;
  signal \axi_araddr_reg_n_0_[12]\ : STD_LOGIC;
  signal \axi_araddr_reg_n_0_[13]\ : STD_LOGIC;
  signal axi_arready_i_1_n_0 : STD_LOGIC;
  signal \^axi_arready_reg_0\ : STD_LOGIC;
  signal axi_awaddr : STD_LOGIC_VECTOR ( 13 downto 2 );
  signal \axi_awaddr[13]_i_1_n_0\ : STD_LOGIC;
  signal axi_awready_i_1_n_0 : STD_LOGIC;
  signal \^axi_awready_reg_0\ : STD_LOGIC;
  signal axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal axi_bvalid_i_2_n_0 : STD_LOGIC;
  signal axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal \^axi_rvalid_reg_0\ : STD_LOGIC;
  signal axi_wready_i_1_n_0 : STD_LOGIC;
  signal \^axi_wready_reg_0\ : STD_LOGIC;
  signal \eb_addr[0]_i_1_n_0\ : STD_LOGIC;
  signal \eb_addr[1]_i_1_n_0\ : STD_LOGIC;
  signal \eb_addr[9]_i_1_n_0\ : STD_LOGIC;
  signal eb_cs_i_1_n_0 : STD_LOGIC;
  signal \^giu_axi_slave_bvalid\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[0]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[10]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[11]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[12]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[13]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[14]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[15]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[16]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[17]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[18]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[19]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[1]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[20]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[21]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[22]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[23]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[24]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[25]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[26]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[27]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[28]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[29]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[2]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[30]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[31]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[3]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[4]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[5]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[6]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[7]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[8]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \giu_axi_slave_rdata[9]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal p_1_in : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal p_1_in_4 : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal sel0 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal slv_reg0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal slv_reg0_1 : STD_LOGIC;
  signal slv_reg1 : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \slv_reg1[0]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg1[1]_i_1_n_0\ : STD_LOGIC;
  signal slv_reg2 : STD_LOGIC_VECTOR ( 31 downto 20 );
  signal slv_reg2_0 : STD_LOGIC;
  signal slv_reg3 : STD_LOGIC_VECTOR ( 31 downto 10 );
  signal slv_reg3_3 : STD_LOGIC;
  signal slv_reg4 : STD_LOGIC_VECTOR ( 31 downto 4 );
  signal slv_reg4_2 : STD_LOGIC;
  signal \^slv_reg4_reg[3]_0\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal start_frame_i_1_n_0 : STD_LOGIC;
  signal start_frame_i_2_n_0 : STD_LOGIC;
  signal state_read : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal state_write : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal temp_x : STD_LOGIC;
  signal temp_y : STD_LOGIC;
  signal \vb_addr[0]_i_1_n_0\ : STD_LOGIC;
  signal \vb_addr[1]_i_1_n_0\ : STD_LOGIC;
  signal \vb_addr[2]_i_1_n_0\ : STD_LOGIC;
  signal \vb_addr[3]_i_1_n_0\ : STD_LOGIC;
  signal \vb_addr[4]_i_1_n_0\ : STD_LOGIC;
  signal \vb_addr[5]_i_1_n_0\ : STD_LOGIC;
  signal \vb_addr[6]_i_1_n_0\ : STD_LOGIC;
  signal \vb_addr[7]_i_1_n_0\ : STD_LOGIC;
  signal \vb_addr[7]_i_2_n_0\ : STD_LOGIC;
  signal \vb_addr[7]_i_3_n_0\ : STD_LOGIC;
  signal \vb_addr[7]_i_5_n_0\ : STD_LOGIC;
  signal vb_cs_i_1_n_0 : STD_LOGIC;
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_read_reg[0]\ : label is "Idle:00,Rdata:10,Raddr:01";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_read_reg[1]\ : label is "Idle:00,Rdata:10,Raddr:01";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state_write[0]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \FSM_sequential_state_write[1]_i_1\ : label is "soft_lutpair0";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_write_reg[0]\ : label is "Idle:00,Wdata:10,Waddr:01";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_write_reg[1]\ : label is "Idle:00,Wdata:10,Waddr:01";
  attribute SOFT_HLUTNM of axi_awready_i_1 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of axi_bvalid_i_2 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \eb_addr[0]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \eb_addr[1]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of eb_cs_i_2 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \slv_reg1[0]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \slv_reg1[1]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of start_frame_i_2 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \vb_addr[0]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \vb_addr[1]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \vb_addr[2]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \vb_addr[3]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \vb_addr[4]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \vb_addr[5]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \vb_addr[6]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \vb_addr[7]_i_3\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \vb_addr[7]_i_4\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \vb_addr[7]_i_5\ : label is "soft_lutpair1";
begin
  Q(19 downto 0) <= \^q\(19 downto 0);
  angle(9 downto 0) <= \^angle\(9 downto 0);
  axi_arready_reg_0 <= \^axi_arready_reg_0\;
  axi_awready_reg_0 <= \^axi_awready_reg_0\;
  axi_rvalid_reg_0 <= \^axi_rvalid_reg_0\;
  axi_wready_reg_0 <= \^axi_wready_reg_0\;
  giu_axi_slave_bvalid <= \^giu_axi_slave_bvalid\;
  \slv_reg4_reg[3]_0\(3 downto 0) <= \^slv_reg4_reg[3]_0\(3 downto 0);
\FSM_sequential_state_read[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF88880FFFFFFF"
    )
        port map (
      I0 => giu_axi_slave_rready,
      I1 => \^axi_rvalid_reg_0\,
      I2 => giu_axi_slave_arvalid,
      I3 => \^axi_arready_reg_0\,
      I4 => state_read(0),
      I5 => state_read(1),
      O => \FSM_sequential_state_read[0]_i_1_n_0\
    );
\FSM_sequential_state_read[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF7777F0000000"
    )
        port map (
      I0 => \^axi_rvalid_reg_0\,
      I1 => giu_axi_slave_rready,
      I2 => \^axi_arready_reg_0\,
      I3 => giu_axi_slave_arvalid,
      I4 => state_read(0),
      I5 => state_read(1),
      O => \FSM_sequential_state_read[1]_i_1_n_0\
    );
\FSM_sequential_state_read_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => \FSM_sequential_state_read[0]_i_1_n_0\,
      Q => state_read(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\FSM_sequential_state_read_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => \FSM_sequential_state_read[1]_i_1_n_0\,
      Q => state_read(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\FSM_sequential_state_write[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFF0F7FF"
    )
        port map (
      I0 => \^axi_awready_reg_0\,
      I1 => giu_axi_slave_awvalid,
      I2 => giu_axi_slave_wvalid,
      I3 => state_write(0),
      I4 => state_write(1),
      O => \FSM_sequential_state_write[0]_i_1_n_0\
    );
\FSM_sequential_state_write[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF0F0800"
    )
        port map (
      I0 => giu_axi_slave_awvalid,
      I1 => \^axi_awready_reg_0\,
      I2 => giu_axi_slave_wvalid,
      I3 => state_write(0),
      I4 => state_write(1),
      O => \FSM_sequential_state_write[1]_i_1_n_0\
    );
\FSM_sequential_state_write_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => \FSM_sequential_state_write[0]_i_1_n_0\,
      Q => state_write(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\FSM_sequential_state_write_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => \FSM_sequential_state_write[1]_i_1_n_0\,
      Q => state_write(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_araddr[13]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"08000000"
    )
        port map (
      I0 => state_read(0),
      I1 => giu_axi_slave_aresetn,
      I2 => state_read(1),
      I3 => giu_axi_slave_arvalid,
      I4 => \^axi_arready_reg_0\,
      O => \axi_araddr[13]_i_1_n_0\
    );
\axi_araddr_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_araddr[13]_i_1_n_0\,
      D => giu_axi_slave_araddr(3),
      Q => \axi_araddr_reg_n_0_[12]\,
      R => '0'
    );
\axi_araddr_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_araddr[13]_i_1_n_0\,
      D => giu_axi_slave_araddr(4),
      Q => \axi_araddr_reg_n_0_[13]\,
      R => '0'
    );
\axi_araddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_araddr[13]_i_1_n_0\,
      D => giu_axi_slave_araddr(0),
      Q => sel0(0),
      R => '0'
    );
\axi_araddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_araddr[13]_i_1_n_0\,
      D => giu_axi_slave_araddr(1),
      Q => sel0(1),
      R => '0'
    );
\axi_araddr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_araddr[13]_i_1_n_0\,
      D => giu_axi_slave_araddr(2),
      Q => sel0(2),
      R => '0'
    );
axi_arready_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF55FFFF40554055"
    )
        port map (
      I0 => state_read(0),
      I1 => giu_axi_slave_rready,
      I2 => \^axi_rvalid_reg_0\,
      I3 => state_read(1),
      I4 => giu_axi_slave_arvalid,
      I5 => \^axi_arready_reg_0\,
      O => axi_arready_i_1_n_0
    );
axi_arready_reg: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => axi_arready_i_1_n_0,
      Q => \^axi_arready_reg_0\,
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr[13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => state_write(1),
      I1 => state_write(0),
      I2 => giu_axi_slave_awvalid,
      I3 => \^axi_awready_reg_0\,
      O => \axi_awaddr[13]_i_1_n_0\
    );
\axi_awaddr_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(8),
      Q => axi_awaddr(10),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(9),
      Q => axi_awaddr(11),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(10),
      Q => axi_awaddr(12),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(11),
      Q => axi_awaddr(13),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(0),
      Q => axi_awaddr(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(1),
      Q => axi_awaddr(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(2),
      Q => axi_awaddr(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(3),
      Q => axi_awaddr(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(4),
      Q => axi_awaddr(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(5),
      Q => axi_awaddr(7),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(6),
      Q => axi_awaddr(8),
      R => \vb_addr[7]_i_1_n_0\
    );
\axi_awaddr_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \axi_awaddr[13]_i_1_n_0\,
      D => giu_axi_slave_awaddr(7),
      Q => axi_awaddr(9),
      R => \vb_addr[7]_i_1_n_0\
    );
axi_awready_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AFAAAF2F"
    )
        port map (
      I0 => \^axi_awready_reg_0\,
      I1 => giu_axi_slave_awvalid,
      I2 => state_write(0),
      I3 => giu_axi_slave_wvalid,
      I4 => state_write(1),
      O => axi_awready_i_1_n_0
    );
axi_awready_reg: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => axi_awready_i_1_n_0,
      Q => \^axi_awready_reg_0\,
      R => \vb_addr[7]_i_1_n_0\
    );
axi_bvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FA2FFFFF0A200A20"
    )
        port map (
      I0 => giu_axi_slave_wvalid,
      I1 => axi_bvalid_i_2_n_0,
      I2 => state_write(0),
      I3 => state_write(1),
      I4 => giu_axi_slave_bready,
      I5 => \^giu_axi_slave_bvalid\,
      O => axi_bvalid_i_1_n_0
    );
axi_bvalid_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \^axi_awready_reg_0\,
      I1 => giu_axi_slave_awvalid,
      O => axi_bvalid_i_2_n_0
    );
axi_bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => axi_bvalid_i_1_n_0,
      Q => \^giu_axi_slave_bvalid\,
      R => \vb_addr[7]_i_1_n_0\
    );
axi_rvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A2A2A2A2FAAAAAAA"
    )
        port map (
      I0 => \^axi_rvalid_reg_0\,
      I1 => giu_axi_slave_rready,
      I2 => state_read(0),
      I3 => \^axi_arready_reg_0\,
      I4 => giu_axi_slave_arvalid,
      I5 => state_read(1),
      O => axi_rvalid_i_1_n_0
    );
axi_rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => axi_rvalid_i_1_n_0,
      Q => \^axi_rvalid_reg_0\,
      R => \vb_addr[7]_i_1_n_0\
    );
axi_wready_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F1"
    )
        port map (
      I0 => state_write(1),
      I1 => state_write(0),
      I2 => \^axi_wready_reg_0\,
      O => axi_wready_i_1_n_0
    );
axi_wready_reg: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => axi_wready_i_1_n_0,
      Q => \^axi_wready_reg_0\,
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(0),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(2),
      O => \eb_addr[0]_i_1_n_0\
    );
\eb_addr[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(1),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(3),
      O => \eb_addr[1]_i_1_n_0\
    );
\eb_addr[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4540000000000000"
    )
        port map (
      I0 => p_1_in_4(0),
      I1 => giu_axi_slave_awaddr(11),
      I2 => giu_axi_slave_awvalid,
      I3 => axi_awaddr(13),
      I4 => \^axi_wready_reg_0\,
      I5 => giu_axi_slave_wvalid,
      O => \eb_addr[9]_i_1_n_0\
    );
\eb_addr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \eb_addr[0]_i_1_n_0\,
      Q => eb_addr(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \eb_addr[1]_i_1_n_0\,
      Q => eb_addr(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \vb_addr[0]_i_1_n_0\,
      Q => eb_addr(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \vb_addr[1]_i_1_n_0\,
      Q => eb_addr(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \vb_addr[2]_i_1_n_0\,
      Q => eb_addr(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \vb_addr[3]_i_1_n_0\,
      Q => eb_addr(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \vb_addr[4]_i_1_n_0\,
      Q => eb_addr(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \vb_addr[5]_i_1_n_0\,
      Q => eb_addr(7),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \vb_addr[6]_i_1_n_0\,
      Q => eb_addr(8),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_addr_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => \vb_addr[7]_i_3_n_0\,
      Q => eb_addr(9),
      R => \vb_addr[7]_i_1_n_0\
    );
eb_cs_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00800000"
    )
        port map (
      I0 => p_1_in_4(1),
      I1 => giu_axi_slave_wvalid,
      I2 => \^axi_wready_reg_0\,
      I3 => p_1_in_4(0),
      I4 => giu_axi_slave_aresetn,
      O => eb_cs_i_1_n_0
    );
eb_cs_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(11),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(13),
      O => p_1_in_4(1)
    );
eb_cs_reg: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => eb_cs_i_1_n_0,
      Q => eb_wr,
      R => '0'
    );
\eb_dataIn_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(0),
      Q => eb_dataIn(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(10),
      Q => eb_dataIn(10),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(11),
      Q => eb_dataIn(11),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(12),
      Q => eb_dataIn(12),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(13),
      Q => eb_dataIn(13),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(14),
      Q => eb_dataIn(14),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(15),
      Q => eb_dataIn(15),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(16),
      Q => eb_dataIn(16),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(17),
      Q => eb_dataIn(17),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(18),
      Q => eb_dataIn(18),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(19),
      Q => eb_dataIn(19),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(1),
      Q => eb_dataIn(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(2),
      Q => eb_dataIn(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(3),
      Q => eb_dataIn(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(4),
      Q => eb_dataIn(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(5),
      Q => eb_dataIn(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(6),
      Q => eb_dataIn(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(7),
      Q => eb_dataIn(7),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(8),
      Q => eb_dataIn(8),
      R => \vb_addr[7]_i_1_n_0\
    );
\eb_dataIn_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \eb_addr[9]_i_1_n_0\,
      D => giu_axi_slave_wdata(9),
      Q => eb_dataIn(9),
      R => \vb_addr[7]_i_1_n_0\
    );
\giu_axi_slave_rdata[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => \^slv_reg4_reg[3]_0\(0),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[0]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(0)
    );
\giu_axi_slave_rdata[0]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \^angle\(0),
      I1 => \^q\(0),
      I2 => sel0(1),
      I3 => slv_reg1(0),
      I4 => sel0(0),
      I5 => slv_reg0(0),
      O => \giu_axi_slave_rdata[0]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[10]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(10),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[10]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(10)
    );
\giu_axi_slave_rdata[10]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(10),
      I3 => sel0(1),
      I4 => \^q\(10),
      I5 => slv_reg3(10),
      O => \giu_axi_slave_rdata[10]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[11]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(11),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[11]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(11)
    );
\giu_axi_slave_rdata[11]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(11),
      I3 => sel0(1),
      I4 => \^q\(11),
      I5 => slv_reg3(11),
      O => \giu_axi_slave_rdata[11]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[12]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(12),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[12]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(12)
    );
\giu_axi_slave_rdata[12]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(12),
      I3 => sel0(1),
      I4 => \^q\(12),
      I5 => slv_reg3(12),
      O => \giu_axi_slave_rdata[12]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[13]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(13),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[13]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(13)
    );
\giu_axi_slave_rdata[13]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(13),
      I3 => sel0(1),
      I4 => \^q\(13),
      I5 => slv_reg3(13),
      O => \giu_axi_slave_rdata[13]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[14]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(14),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[14]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(14)
    );
\giu_axi_slave_rdata[14]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(14),
      I3 => sel0(1),
      I4 => \^q\(14),
      I5 => slv_reg3(14),
      O => \giu_axi_slave_rdata[14]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[15]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(15),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[15]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(15)
    );
\giu_axi_slave_rdata[15]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(15),
      I3 => sel0(1),
      I4 => \^q\(15),
      I5 => slv_reg3(15),
      O => \giu_axi_slave_rdata[15]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[16]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(16),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[16]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(16)
    );
\giu_axi_slave_rdata[16]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(16),
      I3 => sel0(1),
      I4 => \^q\(16),
      I5 => slv_reg3(16),
      O => \giu_axi_slave_rdata[16]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[17]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(17),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[17]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(17)
    );
\giu_axi_slave_rdata[17]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(17),
      I3 => sel0(1),
      I4 => \^q\(17),
      I5 => slv_reg3(17),
      O => \giu_axi_slave_rdata[17]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[18]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(18),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[18]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(18)
    );
\giu_axi_slave_rdata[18]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(18),
      I3 => sel0(1),
      I4 => \^q\(18),
      I5 => slv_reg3(18),
      O => \giu_axi_slave_rdata[18]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[19]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(19),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[19]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(19)
    );
\giu_axi_slave_rdata[19]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(19),
      I3 => sel0(1),
      I4 => \^q\(19),
      I5 => slv_reg3(19),
      O => \giu_axi_slave_rdata[19]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[1]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => \^slv_reg4_reg[3]_0\(1),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[1]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(1)
    );
\giu_axi_slave_rdata[1]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \^angle\(1),
      I1 => \^q\(1),
      I2 => sel0(1),
      I3 => slv_reg1(1),
      I4 => sel0(0),
      I5 => slv_reg0(1),
      O => \giu_axi_slave_rdata[1]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[20]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(20),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[20]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(20)
    );
\giu_axi_slave_rdata[20]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(20),
      I3 => sel0(1),
      I4 => slv_reg2(20),
      I5 => slv_reg3(20),
      O => \giu_axi_slave_rdata[20]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[21]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(21),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[21]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(21)
    );
\giu_axi_slave_rdata[21]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(21),
      I3 => sel0(1),
      I4 => slv_reg2(21),
      I5 => slv_reg3(21),
      O => \giu_axi_slave_rdata[21]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[22]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(22),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[22]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(22)
    );
\giu_axi_slave_rdata[22]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(22),
      I3 => sel0(1),
      I4 => slv_reg2(22),
      I5 => slv_reg3(22),
      O => \giu_axi_slave_rdata[22]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[23]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(23),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[23]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(23)
    );
\giu_axi_slave_rdata[23]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(23),
      I3 => sel0(1),
      I4 => slv_reg2(23),
      I5 => slv_reg3(23),
      O => \giu_axi_slave_rdata[23]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[24]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(24),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[24]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(24)
    );
\giu_axi_slave_rdata[24]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(24),
      I3 => sel0(1),
      I4 => slv_reg2(24),
      I5 => slv_reg3(24),
      O => \giu_axi_slave_rdata[24]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[25]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(25),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[25]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(25)
    );
\giu_axi_slave_rdata[25]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(25),
      I3 => sel0(1),
      I4 => slv_reg2(25),
      I5 => slv_reg3(25),
      O => \giu_axi_slave_rdata[25]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[26]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(26),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[26]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(26)
    );
\giu_axi_slave_rdata[26]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(26),
      I3 => sel0(1),
      I4 => slv_reg2(26),
      I5 => slv_reg3(26),
      O => \giu_axi_slave_rdata[26]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[27]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(27),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[27]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(27)
    );
\giu_axi_slave_rdata[27]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(27),
      I3 => sel0(1),
      I4 => slv_reg2(27),
      I5 => slv_reg3(27),
      O => \giu_axi_slave_rdata[27]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[28]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(28),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[28]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(28)
    );
\giu_axi_slave_rdata[28]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(28),
      I3 => sel0(1),
      I4 => slv_reg2(28),
      I5 => slv_reg3(28),
      O => \giu_axi_slave_rdata[28]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[29]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(29),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[29]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(29)
    );
\giu_axi_slave_rdata[29]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(29),
      I3 => sel0(1),
      I4 => slv_reg2(29),
      I5 => slv_reg3(29),
      O => \giu_axi_slave_rdata[29]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[2]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => \^slv_reg4_reg[3]_0\(2),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[2]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(2)
    );
\giu_axi_slave_rdata[2]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(2),
      I3 => sel0(1),
      I4 => \^q\(2),
      I5 => \^angle\(2),
      O => \giu_axi_slave_rdata[2]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[30]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(30),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[30]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(30)
    );
\giu_axi_slave_rdata[30]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(30),
      I3 => sel0(1),
      I4 => slv_reg2(30),
      I5 => slv_reg3(30),
      O => \giu_axi_slave_rdata[30]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[31]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(31),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[31]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(31)
    );
\giu_axi_slave_rdata[31]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(31),
      I3 => sel0(1),
      I4 => slv_reg2(31),
      I5 => slv_reg3(31),
      O => \giu_axi_slave_rdata[31]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[31]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \axi_araddr_reg_n_0_[13]\,
      I1 => \axi_araddr_reg_n_0_[12]\,
      O => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\
    );
\giu_axi_slave_rdata[3]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => \^slv_reg4_reg[3]_0\(3),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[3]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(3)
    );
\giu_axi_slave_rdata[3]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(3),
      I3 => sel0(1),
      I4 => \^q\(3),
      I5 => \^angle\(3),
      O => \giu_axi_slave_rdata[3]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[4]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(4),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[4]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(4)
    );
\giu_axi_slave_rdata[4]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(4),
      I3 => sel0(1),
      I4 => \^q\(4),
      I5 => \^angle\(4),
      O => \giu_axi_slave_rdata[4]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[5]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(5),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[5]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(5)
    );
\giu_axi_slave_rdata[5]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(5),
      I3 => sel0(1),
      I4 => \^q\(5),
      I5 => \^angle\(5),
      O => \giu_axi_slave_rdata[5]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[6]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(6),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[6]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(6)
    );
\giu_axi_slave_rdata[6]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(6),
      I3 => sel0(1),
      I4 => \^q\(6),
      I5 => \^angle\(6),
      O => \giu_axi_slave_rdata[6]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[7]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(7),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[7]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(7)
    );
\giu_axi_slave_rdata[7]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(7),
      I3 => sel0(1),
      I4 => \^q\(7),
      I5 => \^angle\(7),
      O => \giu_axi_slave_rdata[7]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[8]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(8),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[8]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(8)
    );
\giu_axi_slave_rdata[8]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(8),
      I3 => sel0(1),
      I4 => \^q\(8),
      I5 => \^angle\(8),
      O => \giu_axi_slave_rdata[8]_INST_0_i_1_n_0\
    );
\giu_axi_slave_rdata[9]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF4F004000000000"
    )
        port map (
      I0 => sel0(0),
      I1 => slv_reg4(9),
      I2 => sel0(2),
      I3 => sel0(1),
      I4 => \giu_axi_slave_rdata[9]_INST_0_i_1_n_0\,
      I5 => \giu_axi_slave_rdata[31]_INST_0_i_2_n_0\,
      O => giu_axi_slave_rdata(9)
    );
\giu_axi_slave_rdata[9]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5510441011100010"
    )
        port map (
      I0 => sel0(2),
      I1 => sel0(0),
      I2 => slv_reg0(9),
      I3 => sel0(1),
      I4 => \^q\(9),
      I5 => \^angle\(9),
      O => \giu_axi_slave_rdata[9]_INST_0_i_1_n_0\
    );
\slv_reg0[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0004440400000000"
    )
        port map (
      I0 => \eb_addr[1]_i_1_n_0\,
      I1 => \vb_addr[7]_i_5_n_0\,
      I2 => axi_awaddr(2),
      I3 => giu_axi_slave_awvalid,
      I4 => giu_axi_slave_awaddr(0),
      I5 => start_frame_i_2_n_0,
      O => slv_reg0_1
    );
\slv_reg0_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(0),
      Q => slv_reg0(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(10),
      Q => slv_reg0(10),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(11),
      Q => slv_reg0(11),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(12),
      Q => slv_reg0(12),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(13),
      Q => slv_reg0(13),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(14),
      Q => slv_reg0(14),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(15),
      Q => slv_reg0(15),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(16),
      Q => slv_reg0(16),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(17),
      Q => slv_reg0(17),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(18),
      Q => slv_reg0(18),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(19),
      Q => slv_reg0(19),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(1),
      Q => slv_reg0(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(20),
      Q => slv_reg0(20),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(21),
      Q => slv_reg0(21),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(22),
      Q => slv_reg0(22),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(23),
      Q => slv_reg0(23),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(24),
      Q => slv_reg0(24),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(25),
      Q => slv_reg0(25),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(26),
      Q => slv_reg0(26),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(27),
      Q => slv_reg0(27),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(28),
      Q => slv_reg0(28),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(29),
      Q => slv_reg0(29),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(2),
      Q => slv_reg0(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(30),
      Q => slv_reg0(30),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(31),
      Q => slv_reg0(31),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(3),
      Q => slv_reg0(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(4),
      Q => slv_reg0(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(5),
      Q => slv_reg0(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(6),
      Q => slv_reg0(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(7),
      Q => slv_reg0(7),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(8),
      Q => slv_reg0(8),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg0_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg0_1,
      D => giu_axi_slave_wdata(9),
      Q => slv_reg0(9),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg1[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => frame_done,
      I1 => giu_axi_slave_aresetn,
      I2 => slv_reg1(0),
      O => \slv_reg1[0]_i_1_n_0\
    );
\slv_reg1[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => busy,
      I1 => giu_axi_slave_aresetn,
      I2 => slv_reg1(1),
      O => \slv_reg1[1]_i_1_n_0\
    );
\slv_reg1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => \slv_reg1[0]_i_1_n_0\,
      Q => slv_reg1(0),
      R => '0'
    );
\slv_reg1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => \slv_reg1[1]_i_1_n_0\,
      Q => slv_reg1(1),
      R => '0'
    );
\slv_reg2[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0800088800000000"
    )
        port map (
      I0 => \eb_addr[1]_i_1_n_0\,
      I1 => start_frame_i_2_n_0,
      I2 => giu_axi_slave_awaddr(0),
      I3 => giu_axi_slave_awvalid,
      I4 => axi_awaddr(2),
      I5 => \vb_addr[7]_i_5_n_0\,
      O => slv_reg2_0
    );
\slv_reg2_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(0),
      Q => \^q\(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(10),
      Q => \^q\(10),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(11),
      Q => \^q\(11),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(12),
      Q => \^q\(12),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(13),
      Q => \^q\(13),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(14),
      Q => \^q\(14),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(15),
      Q => \^q\(15),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(16),
      Q => \^q\(16),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(17),
      Q => \^q\(17),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(18),
      Q => \^q\(18),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(19),
      Q => \^q\(19),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(1),
      Q => \^q\(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(20),
      Q => slv_reg2(20),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(21),
      Q => slv_reg2(21),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(22),
      Q => slv_reg2(22),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(23),
      Q => slv_reg2(23),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(24),
      Q => slv_reg2(24),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(25),
      Q => slv_reg2(25),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(26),
      Q => slv_reg2(26),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(27),
      Q => slv_reg2(27),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(28),
      Q => slv_reg2(28),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(29),
      Q => slv_reg2(29),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(2),
      Q => \^q\(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(30),
      Q => slv_reg2(30),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(31),
      Q => slv_reg2(31),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(3),
      Q => \^q\(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(4),
      Q => \^q\(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(5),
      Q => \^q\(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(6),
      Q => \^q\(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(7),
      Q => \^q\(7),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(8),
      Q => \^q\(8),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg2_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg2_0,
      D => giu_axi_slave_wdata(9),
      Q => \^q\(9),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A808000000000000"
    )
        port map (
      I0 => \vb_addr[7]_i_5_n_0\,
      I1 => axi_awaddr(2),
      I2 => giu_axi_slave_awvalid,
      I3 => giu_axi_slave_awaddr(0),
      I4 => \eb_addr[1]_i_1_n_0\,
      I5 => start_frame_i_2_n_0,
      O => slv_reg3_3
    );
\slv_reg3_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(0),
      Q => \^angle\(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(10),
      Q => slv_reg3(10),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(11),
      Q => slv_reg3(11),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(12),
      Q => slv_reg3(12),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(13),
      Q => slv_reg3(13),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(14),
      Q => slv_reg3(14),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(15),
      Q => slv_reg3(15),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(16),
      Q => slv_reg3(16),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(17),
      Q => slv_reg3(17),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(18),
      Q => slv_reg3(18),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(19),
      Q => slv_reg3(19),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(1),
      Q => \^angle\(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(20),
      Q => slv_reg3(20),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(21),
      Q => slv_reg3(21),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(22),
      Q => slv_reg3(22),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(23),
      Q => slv_reg3(23),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(24),
      Q => slv_reg3(24),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(25),
      Q => slv_reg3(25),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(26),
      Q => slv_reg3(26),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(27),
      Q => slv_reg3(27),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(28),
      Q => slv_reg3(28),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(29),
      Q => slv_reg3(29),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(2),
      Q => \^angle\(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(30),
      Q => slv_reg3(30),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(31),
      Q => slv_reg3(31),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(3),
      Q => \^angle\(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(4),
      Q => \^angle\(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(5),
      Q => \^angle\(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(6),
      Q => \^angle\(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(7),
      Q => \^angle\(7),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(8),
      Q => \^angle\(8),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg3_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg3_3,
      D => giu_axi_slave_wdata(9),
      Q => \^angle\(9),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000400"
    )
        port map (
      I0 => p_1_in_4(0),
      I1 => \vb_addr[0]_i_1_n_0\,
      I2 => \eb_addr[1]_i_1_n_0\,
      I3 => \vb_addr[7]_i_5_n_0\,
      I4 => \eb_addr[0]_i_1_n_0\,
      O => slv_reg4_2
    );
\slv_reg4_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(0),
      Q => \^slv_reg4_reg[3]_0\(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(10),
      Q => slv_reg4(10),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(11),
      Q => slv_reg4(11),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(12),
      Q => slv_reg4(12),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(13),
      Q => slv_reg4(13),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(14),
      Q => slv_reg4(14),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(15),
      Q => slv_reg4(15),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(16),
      Q => slv_reg4(16),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(17),
      Q => slv_reg4(17),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(18),
      Q => slv_reg4(18),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(19),
      Q => slv_reg4(19),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(1),
      Q => \^slv_reg4_reg[3]_0\(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(20),
      Q => slv_reg4(20),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(21),
      Q => slv_reg4(21),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(22),
      Q => slv_reg4(22),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(23),
      Q => slv_reg4(23),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(24),
      Q => slv_reg4(24),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(25),
      Q => slv_reg4(25),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(26),
      Q => slv_reg4(26),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(27),
      Q => slv_reg4(27),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(28),
      Q => slv_reg4(28),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(29),
      Q => slv_reg4(29),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(2),
      Q => \^slv_reg4_reg[3]_0\(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(30),
      Q => slv_reg4(30),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(31),
      Q => slv_reg4(31),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(3),
      Q => \^slv_reg4_reg[3]_0\(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(4),
      Q => slv_reg4(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(5),
      Q => slv_reg4(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(6),
      Q => slv_reg4(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(7),
      Q => slv_reg4(7),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(8),
      Q => slv_reg4(8),
      R => \vb_addr[7]_i_1_n_0\
    );
\slv_reg4_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => slv_reg4_2,
      D => giu_axi_slave_wdata(9),
      Q => slv_reg4(9),
      R => \vb_addr[7]_i_1_n_0\
    );
start_frame_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000800000"
    )
        port map (
      I0 => start_frame_i_2_n_0,
      I1 => giu_axi_slave_wdata(0),
      I2 => giu_axi_slave_aresetn,
      I3 => \eb_addr[1]_i_1_n_0\,
      I4 => \vb_addr[7]_i_5_n_0\,
      I5 => \eb_addr[0]_i_1_n_0\,
      O => start_frame_i_1_n_0
    );
start_frame_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00053305"
    )
        port map (
      I0 => axi_awaddr(4),
      I1 => giu_axi_slave_awaddr(2),
      I2 => axi_awaddr(12),
      I3 => giu_axi_slave_awvalid,
      I4 => giu_axi_slave_awaddr(10),
      O => start_frame_i_2_n_0
    );
start_frame_reg: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => start_frame_i_1_n_0,
      Q => start_frame,
      R => '0'
    );
\temp_x[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0004440400000000"
    )
        port map (
      I0 => \eb_addr[1]_i_1_n_0\,
      I1 => \vb_addr[7]_i_5_n_0\,
      I2 => axi_awaddr(2),
      I3 => giu_axi_slave_awvalid,
      I4 => giu_axi_slave_awaddr(0),
      I5 => p_1_in_4(0),
      O => temp_x
    );
\temp_x_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(0),
      Q => p_1_in(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(10),
      Q => p_1_in(10),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(11),
      Q => p_1_in(11),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(12),
      Q => p_1_in(12),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(13),
      Q => p_1_in(13),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(14),
      Q => p_1_in(14),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(15),
      Q => p_1_in(15),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(16),
      Q => p_1_in(16),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(17),
      Q => p_1_in(17),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(18),
      Q => p_1_in(18),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(19),
      Q => p_1_in(19),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(1),
      Q => p_1_in(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(20),
      Q => p_1_in(20),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(21),
      Q => p_1_in(21),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(22),
      Q => p_1_in(22),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(23),
      Q => p_1_in(23),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(24),
      Q => p_1_in(24),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(25),
      Q => p_1_in(25),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(26),
      Q => p_1_in(26),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(27),
      Q => p_1_in(27),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(28),
      Q => p_1_in(28),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(29),
      Q => p_1_in(29),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(2),
      Q => p_1_in(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(30),
      Q => p_1_in(30),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(31),
      Q => p_1_in(31),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(3),
      Q => p_1_in(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(4),
      Q => p_1_in(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(5),
      Q => p_1_in(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(6),
      Q => p_1_in(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(7),
      Q => p_1_in(7),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(8),
      Q => p_1_in(8),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_x_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_x,
      D => giu_axi_slave_wdata(9),
      Q => p_1_in(9),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000B80000000000"
    )
        port map (
      I0 => giu_axi_slave_awaddr(0),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(2),
      I3 => p_1_in_4(0),
      I4 => \eb_addr[1]_i_1_n_0\,
      I5 => \vb_addr[7]_i_5_n_0\,
      O => temp_y
    );
\temp_y_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(0),
      Q => p_1_in(32),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(10),
      Q => p_1_in(42),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(11),
      Q => p_1_in(43),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(12),
      Q => p_1_in(44),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(13),
      Q => p_1_in(45),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(14),
      Q => p_1_in(46),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(15),
      Q => p_1_in(47),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(16),
      Q => p_1_in(48),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(17),
      Q => p_1_in(49),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(18),
      Q => p_1_in(50),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(19),
      Q => p_1_in(51),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(1),
      Q => p_1_in(33),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(20),
      Q => p_1_in(52),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(21),
      Q => p_1_in(53),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(22),
      Q => p_1_in(54),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(23),
      Q => p_1_in(55),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(24),
      Q => p_1_in(56),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(25),
      Q => p_1_in(57),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(26),
      Q => p_1_in(58),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(27),
      Q => p_1_in(59),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(28),
      Q => p_1_in(60),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(29),
      Q => p_1_in(61),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(2),
      Q => p_1_in(34),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(30),
      Q => p_1_in(62),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(31),
      Q => p_1_in(63),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(3),
      Q => p_1_in(35),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(4),
      Q => p_1_in(36),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(5),
      Q => p_1_in(37),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(6),
      Q => p_1_in(38),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(7),
      Q => p_1_in(39),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(8),
      Q => p_1_in(40),
      R => \vb_addr[7]_i_1_n_0\
    );
\temp_y_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => temp_y,
      D => giu_axi_slave_wdata(9),
      Q => p_1_in(41),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_addr[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(2),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(4),
      O => \vb_addr[0]_i_1_n_0\
    );
\vb_addr[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(3),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(5),
      O => \vb_addr[1]_i_1_n_0\
    );
\vb_addr[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(4),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(6),
      O => \vb_addr[2]_i_1_n_0\
    );
\vb_addr[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(5),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(7),
      O => \vb_addr[3]_i_1_n_0\
    );
\vb_addr[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(6),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(8),
      O => \vb_addr[4]_i_1_n_0\
    );
\vb_addr[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(7),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(9),
      O => \vb_addr[5]_i_1_n_0\
    );
\vb_addr[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(8),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(10),
      O => \vb_addr[6]_i_1_n_0\
    );
\vb_addr[7]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => giu_axi_slave_aresetn,
      O => \vb_addr[7]_i_1_n_0\
    );
\vb_addr[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0800088800000000"
    )
        port map (
      I0 => \eb_addr[1]_i_1_n_0\,
      I1 => p_1_in_4(0),
      I2 => giu_axi_slave_awaddr(0),
      I3 => giu_axi_slave_awvalid,
      I4 => axi_awaddr(2),
      I5 => \vb_addr[7]_i_5_n_0\,
      O => \vb_addr[7]_i_2_n_0\
    );
\vb_addr[7]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(9),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(11),
      O => \vb_addr[7]_i_3_n_0\
    );
\vb_addr[7]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => giu_axi_slave_awaddr(10),
      I1 => giu_axi_slave_awvalid,
      I2 => axi_awaddr(12),
      O => p_1_in_4(0)
    );
\vb_addr[7]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00088808"
    )
        port map (
      I0 => \^axi_wready_reg_0\,
      I1 => giu_axi_slave_wvalid,
      I2 => axi_awaddr(13),
      I3 => giu_axi_slave_awvalid,
      I4 => giu_axi_slave_awaddr(11),
      O => \vb_addr[7]_i_5_n_0\
    );
\vb_addr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => \vb_addr[0]_i_1_n_0\,
      Q => vb_addr(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_addr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => \vb_addr[1]_i_1_n_0\,
      Q => vb_addr(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_addr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => \vb_addr[2]_i_1_n_0\,
      Q => vb_addr(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_addr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => \vb_addr[3]_i_1_n_0\,
      Q => vb_addr(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_addr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => \vb_addr[4]_i_1_n_0\,
      Q => vb_addr(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_addr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => \vb_addr[5]_i_1_n_0\,
      Q => vb_addr(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_addr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => \vb_addr[6]_i_1_n_0\,
      Q => vb_addr(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_addr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => \vb_addr[7]_i_3_n_0\,
      Q => vb_addr(7),
      R => \vb_addr[7]_i_1_n_0\
    );
vb_cs_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00800000"
    )
        port map (
      I0 => p_1_in_4(0),
      I1 => \eb_addr[1]_i_1_n_0\,
      I2 => giu_axi_slave_aresetn,
      I3 => \eb_addr[0]_i_1_n_0\,
      I4 => \vb_addr[7]_i_5_n_0\,
      O => vb_cs_i_1_n_0
    );
vb_cs_reg: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => '1',
      D => vb_cs_i_1_n_0,
      Q => vb_wr,
      R => '0'
    );
\vb_dataIn_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(0),
      Q => vb_dataIn(0),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(10),
      Q => vb_dataIn(10),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(11),
      Q => vb_dataIn(11),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(12),
      Q => vb_dataIn(12),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(13),
      Q => vb_dataIn(13),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(14),
      Q => vb_dataIn(14),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(15),
      Q => vb_dataIn(15),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(16),
      Q => vb_dataIn(16),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(17),
      Q => vb_dataIn(17),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(18),
      Q => vb_dataIn(18),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(19),
      Q => vb_dataIn(19),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(1),
      Q => vb_dataIn(1),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(20),
      Q => vb_dataIn(20),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(21),
      Q => vb_dataIn(21),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(22),
      Q => vb_dataIn(22),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(23),
      Q => vb_dataIn(23),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(24),
      Q => vb_dataIn(24),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(25),
      Q => vb_dataIn(25),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(26),
      Q => vb_dataIn(26),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(27),
      Q => vb_dataIn(27),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(28),
      Q => vb_dataIn(28),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(29),
      Q => vb_dataIn(29),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(2),
      Q => vb_dataIn(2),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(30),
      Q => vb_dataIn(30),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(31),
      Q => vb_dataIn(31),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(32),
      Q => vb_dataIn(32),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(33),
      Q => vb_dataIn(33),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(34),
      Q => vb_dataIn(34),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(35),
      Q => vb_dataIn(35),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(36),
      Q => vb_dataIn(36),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(37),
      Q => vb_dataIn(37),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(38),
      Q => vb_dataIn(38),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(39),
      Q => vb_dataIn(39),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(3),
      Q => vb_dataIn(3),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(40),
      Q => vb_dataIn(40),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(41),
      Q => vb_dataIn(41),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(42),
      Q => vb_dataIn(42),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(43),
      Q => vb_dataIn(43),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(44),
      Q => vb_dataIn(44),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(45),
      Q => vb_dataIn(45),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(46),
      Q => vb_dataIn(46),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(47),
      Q => vb_dataIn(47),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(48),
      Q => vb_dataIn(48),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(49),
      Q => vb_dataIn(49),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(4),
      Q => vb_dataIn(4),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(50),
      Q => vb_dataIn(50),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(51),
      Q => vb_dataIn(51),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(52),
      Q => vb_dataIn(52),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(53),
      Q => vb_dataIn(53),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(54),
      Q => vb_dataIn(54),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(55),
      Q => vb_dataIn(55),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(56),
      Q => vb_dataIn(56),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(57),
      Q => vb_dataIn(57),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(58),
      Q => vb_dataIn(58),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(59),
      Q => vb_dataIn(59),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(5),
      Q => vb_dataIn(5),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(60),
      Q => vb_dataIn(60),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(61),
      Q => vb_dataIn(61),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(62),
      Q => vb_dataIn(62),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(63),
      Q => vb_dataIn(63),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(0),
      Q => vb_dataIn(64),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(1),
      Q => vb_dataIn(65),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(2),
      Q => vb_dataIn(66),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(3),
      Q => vb_dataIn(67),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(4),
      Q => vb_dataIn(68),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(5),
      Q => vb_dataIn(69),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(6),
      Q => vb_dataIn(6),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(6),
      Q => vb_dataIn(70),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(7),
      Q => vb_dataIn(71),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(8),
      Q => vb_dataIn(72),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[73]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(9),
      Q => vb_dataIn(73),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[74]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(10),
      Q => vb_dataIn(74),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[75]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(11),
      Q => vb_dataIn(75),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[76]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(12),
      Q => vb_dataIn(76),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[77]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(13),
      Q => vb_dataIn(77),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[78]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(14),
      Q => vb_dataIn(78),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[79]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(15),
      Q => vb_dataIn(79),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(7),
      Q => vb_dataIn(7),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[80]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(16),
      Q => vb_dataIn(80),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[81]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(17),
      Q => vb_dataIn(81),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[82]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(18),
      Q => vb_dataIn(82),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[83]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(19),
      Q => vb_dataIn(83),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[84]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(20),
      Q => vb_dataIn(84),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[85]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(21),
      Q => vb_dataIn(85),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[86]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(22),
      Q => vb_dataIn(86),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[87]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(23),
      Q => vb_dataIn(87),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[88]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(24),
      Q => vb_dataIn(88),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[89]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(25),
      Q => vb_dataIn(89),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(8),
      Q => vb_dataIn(8),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[90]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(26),
      Q => vb_dataIn(90),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[91]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(27),
      Q => vb_dataIn(91),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[92]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(28),
      Q => vb_dataIn(92),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[93]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(29),
      Q => vb_dataIn(93),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[94]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(30),
      Q => vb_dataIn(94),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[95]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => giu_axi_slave_wdata(31),
      Q => vb_dataIn(95),
      R => \vb_addr[7]_i_1_n_0\
    );
\vb_dataIn_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => giu_axi_slave_aclk,
      CE => \vb_addr[7]_i_2_n_0\,
      D => p_1_in(9),
      Q => vb_dataIn(9),
      R => \vb_addr[7]_i_1_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_giu_axi_slave_0_0_giu_axi_slave is
  port (
    axi_awready_reg : out STD_LOGIC;
    axi_rvalid_reg : out STD_LOGIC;
    axi_arready_reg : out STD_LOGIC;
    vb_addr : out STD_LOGIC_VECTOR ( 7 downto 0 );
    vb_dataIn : out STD_LOGIC_VECTOR ( 95 downto 0 );
    eb_addr : out STD_LOGIC_VECTOR ( 9 downto 0 );
    eb_dataIn : out STD_LOGIC_VECTOR ( 19 downto 0 );
    Q : out STD_LOGIC_VECTOR ( 19 downto 0 );
    angle : out STD_LOGIC_VECTOR ( 9 downto 0 );
    \slv_reg4_reg[3]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_wready_reg : out STD_LOGIC;
    giu_axi_slave_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    giu_axi_slave_bvalid : out STD_LOGIC;
    vb_wr : out STD_LOGIC;
    eb_wr : out STD_LOGIC;
    start_frame : out STD_LOGIC;
    giu_axi_slave_awvalid : in STD_LOGIC;
    giu_axi_slave_wvalid : in STD_LOGIC;
    giu_axi_slave_aclk : in STD_LOGIC;
    giu_axi_slave_rready : in STD_LOGIC;
    giu_axi_slave_arvalid : in STD_LOGIC;
    giu_axi_slave_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    giu_axi_slave_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    giu_axi_slave_araddr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    busy : in STD_LOGIC;
    giu_axi_slave_aresetn : in STD_LOGIC;
    frame_done : in STD_LOGIC;
    giu_axi_slave_bready : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_giu_axi_slave_0_0_giu_axi_slave : entity is "giu_axi_slave";
end design_1_giu_axi_slave_0_0_giu_axi_slave;

architecture STRUCTURE of design_1_giu_axi_slave_0_0_giu_axi_slave is
begin
giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE_inst: entity work.design_1_giu_axi_slave_0_0_giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE
     port map (
      Q(19 downto 0) => Q(19 downto 0),
      angle(9 downto 0) => angle(9 downto 0),
      axi_arready_reg_0 => axi_arready_reg,
      axi_awready_reg_0 => axi_awready_reg,
      axi_rvalid_reg_0 => axi_rvalid_reg,
      axi_wready_reg_0 => axi_wready_reg,
      busy => busy,
      eb_addr(9 downto 0) => eb_addr(9 downto 0),
      eb_dataIn(19 downto 0) => eb_dataIn(19 downto 0),
      eb_wr => eb_wr,
      frame_done => frame_done,
      giu_axi_slave_aclk => giu_axi_slave_aclk,
      giu_axi_slave_araddr(4 downto 0) => giu_axi_slave_araddr(4 downto 0),
      giu_axi_slave_aresetn => giu_axi_slave_aresetn,
      giu_axi_slave_arvalid => giu_axi_slave_arvalid,
      giu_axi_slave_awaddr(11 downto 0) => giu_axi_slave_awaddr(11 downto 0),
      giu_axi_slave_awvalid => giu_axi_slave_awvalid,
      giu_axi_slave_bready => giu_axi_slave_bready,
      giu_axi_slave_bvalid => giu_axi_slave_bvalid,
      giu_axi_slave_rdata(31 downto 0) => giu_axi_slave_rdata(31 downto 0),
      giu_axi_slave_rready => giu_axi_slave_rready,
      giu_axi_slave_wdata(31 downto 0) => giu_axi_slave_wdata(31 downto 0),
      giu_axi_slave_wvalid => giu_axi_slave_wvalid,
      \slv_reg4_reg[3]_0\(3 downto 0) => \slv_reg4_reg[3]\(3 downto 0),
      start_frame => start_frame,
      vb_addr(7 downto 0) => vb_addr(7 downto 0),
      vb_dataIn(95 downto 0) => vb_dataIn(95 downto 0),
      vb_wr => vb_wr
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_giu_axi_slave_0_0 is
  port (
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
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_giu_axi_slave_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_giu_axi_slave_0_0 : entity is "design_1_giu_axi_slave_0_0,giu_axi_slave,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_giu_axi_slave_0_0 : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of design_1_giu_axi_slave_0_0 : entity is "giu_axi_slave,Vivado 2024.1";
end design_1_giu_axi_slave_0_0;

architecture STRUCTURE of design_1_giu_axi_slave_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \^eb_wr\ : STD_LOGIC;
  signal \^vb_wr\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of giu_axi_slave_aclk : signal is "xilinx.com:signal:clock:1.0 GIU_AXI_SLAVE_CLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of giu_axi_slave_aclk : signal is "XIL_INTERFACENAME GIU_AXI_SLAVE_CLK, ASSOCIATED_BUSIF GIU_AXI_SLAVE, ASSOCIATED_RESET giu_axi_slave_aresetn, FREQ_HZ 50000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of giu_axi_slave_aresetn : signal is "xilinx.com:signal:reset:1.0 GIU_AXI_SLAVE_RST RST";
  attribute X_INTERFACE_PARAMETER of giu_axi_slave_aresetn : signal is "XIL_INTERFACENAME GIU_AXI_SLAVE_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of giu_axi_slave_arready : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARREADY";
  attribute X_INTERFACE_INFO of giu_axi_slave_arvalid : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARVALID";
  attribute X_INTERFACE_INFO of giu_axi_slave_awready : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWREADY";
  attribute X_INTERFACE_INFO of giu_axi_slave_awvalid : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWVALID";
  attribute X_INTERFACE_INFO of giu_axi_slave_bready : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE BREADY";
  attribute X_INTERFACE_INFO of giu_axi_slave_bvalid : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE BVALID";
  attribute X_INTERFACE_INFO of giu_axi_slave_rready : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RREADY";
  attribute X_INTERFACE_PARAMETER of giu_axi_slave_rready : signal is "XIL_INTERFACENAME GIU_AXI_SLAVE, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 8, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 50000000, ID_WIDTH 0, ADDR_WIDTH 14, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 4, NUM_WRITE_THREADS 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of giu_axi_slave_rvalid : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RVALID";
  attribute X_INTERFACE_INFO of giu_axi_slave_wready : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WREADY";
  attribute X_INTERFACE_INFO of giu_axi_slave_wvalid : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WVALID";
  attribute X_INTERFACE_INFO of giu_axi_slave_araddr : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARADDR";
  attribute X_INTERFACE_INFO of giu_axi_slave_arprot : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE ARPROT";
  attribute X_INTERFACE_INFO of giu_axi_slave_awaddr : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWADDR";
  attribute X_INTERFACE_INFO of giu_axi_slave_awprot : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE AWPROT";
  attribute X_INTERFACE_INFO of giu_axi_slave_bresp : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE BRESP";
  attribute X_INTERFACE_INFO of giu_axi_slave_rdata : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RDATA";
  attribute X_INTERFACE_INFO of giu_axi_slave_rresp : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE RRESP";
  attribute X_INTERFACE_INFO of giu_axi_slave_wdata : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WDATA";
  attribute X_INTERFACE_INFO of giu_axi_slave_wstrb : signal is "xilinx.com:interface:aximm:1.0 GIU_AXI_SLAVE WSTRB";
begin
  eb_cs <= \^eb_wr\;
  eb_wr <= \^eb_wr\;
  giu_axi_slave_bresp(1) <= \<const0>\;
  giu_axi_slave_bresp(0) <= \<const0>\;
  giu_axi_slave_rresp(1) <= \<const0>\;
  giu_axi_slave_rresp(0) <= \<const0>\;
  vb_cs <= \^vb_wr\;
  vb_wr <= \^vb_wr\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.design_1_giu_axi_slave_0_0_giu_axi_slave
     port map (
      Q(19 downto 10) => edge_count(9 downto 0),
      Q(9 downto 0) => vertex_count(9 downto 0),
      angle(9 downto 0) => angle(9 downto 0),
      axi_arready_reg => giu_axi_slave_arready,
      axi_awready_reg => giu_axi_slave_awready,
      axi_rvalid_reg => giu_axi_slave_rvalid,
      axi_wready_reg => giu_axi_slave_wready,
      busy => busy,
      eb_addr(9 downto 0) => eb_addr(9 downto 0),
      eb_dataIn(19 downto 0) => eb_dataIn(19 downto 0),
      eb_wr => \^eb_wr\,
      frame_done => frame_done,
      giu_axi_slave_aclk => giu_axi_slave_aclk,
      giu_axi_slave_araddr(4 downto 3) => giu_axi_slave_araddr(13 downto 12),
      giu_axi_slave_araddr(2 downto 0) => giu_axi_slave_araddr(4 downto 2),
      giu_axi_slave_aresetn => giu_axi_slave_aresetn,
      giu_axi_slave_arvalid => giu_axi_slave_arvalid,
      giu_axi_slave_awaddr(11 downto 0) => giu_axi_slave_awaddr(13 downto 2),
      giu_axi_slave_awvalid => giu_axi_slave_awvalid,
      giu_axi_slave_bready => giu_axi_slave_bready,
      giu_axi_slave_bvalid => giu_axi_slave_bvalid,
      giu_axi_slave_rdata(31 downto 0) => giu_axi_slave_rdata(31 downto 0),
      giu_axi_slave_rready => giu_axi_slave_rready,
      giu_axi_slave_wdata(31 downto 0) => giu_axi_slave_wdata(31 downto 0),
      giu_axi_slave_wvalid => giu_axi_slave_wvalid,
      \slv_reg4_reg[3]\(3) => pause,
      \slv_reg4_reg[3]\(2 downto 0) => rotation_type(2 downto 0),
      start_frame => start_frame,
      vb_addr(7 downto 0) => vb_addr(7 downto 0),
      vb_dataIn(95 downto 0) => vb_dataIn(95 downto 0),
      vb_wr => \^vb_wr\
    );
end STRUCTURE;
