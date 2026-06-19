# Timing
create_clock -period 8.000 -name sys_clk -waveform {0.000 4.000} [get_ports sys_clk]

##Clock signal
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { sys_clk }]; 

##Switches
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; 
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }];
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }];

##Buttons
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { btn_rst }];

##HDMI TX
set_property -dict { PACKAGE_PIN H17   IOSTANDARD TMDS_33     } [get_ports { tmds_clk_n }];
set_property -dict { PACKAGE_PIN H16   IOSTANDARD TMDS_33     } [get_ports { tmds_clk_p }]; 
set_property -dict { PACKAGE_PIN D20   IOSTANDARD TMDS_33     } [get_ports { tmds_data_n[0] }]; 
set_property -dict { PACKAGE_PIN D19   IOSTANDARD TMDS_33     } [get_ports { tmds_data_p[0] }]; 
set_property -dict { PACKAGE_PIN B20   IOSTANDARD TMDS_33     } [get_ports { tmds_data_n[1] }]; 
set_property -dict { PACKAGE_PIN C20   IOSTANDARD TMDS_33     } [get_ports { tmds_data_p[1] }]; 
set_property -dict { PACKAGE_PIN A20   IOSTANDARD TMDS_33     } [get_ports { tmds_data_n[2] }]; 
set_property -dict { PACKAGE_PIN B19   IOSTANDARD TMDS_33     } [get_ports { tmds_data_p[2] }]; 

