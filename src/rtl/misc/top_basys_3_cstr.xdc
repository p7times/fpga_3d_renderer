# Clock signal
set_property PACKAGE_PIN W5 [get_ports sys_clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports sys_clk]


# Switches
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]


##Buttons
set_property PACKAGE_PIN U18 [get_ports btn_rst]						
	set_property IOSTANDARD LVCMOS33 [get_ports btn_rst]
	

##VGA Connector
set_property PACKAGE_PIN G19 [get_ports {vga_red[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[0]}]
set_property PACKAGE_PIN H19 [get_ports {vga_red[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[1]}]
set_property PACKAGE_PIN J19 [get_ports {vga_red[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[2]}]
set_property PACKAGE_PIN N19 [get_ports {vga_red[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[3]}]
set_property PACKAGE_PIN N18 [get_ports {vga_blue[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[0]}]
set_property PACKAGE_PIN L18 [get_ports {vga_blue[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[1]}]
set_property PACKAGE_PIN K18 [get_ports {vga_blue[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[2]}]
set_property PACKAGE_PIN J18 [get_ports {vga_blue[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[3]}]
set_property PACKAGE_PIN J17 [get_ports {vga_green[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[0]}]
set_property PACKAGE_PIN H17 [get_ports {vga_green[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[1]}]
set_property PACKAGE_PIN G17 [get_ports {vga_green[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[2]}]
set_property PACKAGE_PIN D17 [get_ports {vga_green[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[3]}]
	
set_property PACKAGE_PIN P19 [get_ports hsync]						
	set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property PACKAGE_PIN R19 [get_ports vsync]						
	set_property IOSTANDARD LVCMOS33 [get_ports vsync]
	

##LEDs
set_property PACKAGE_PIN U16 [get_ports rst_led]
	set_property IOSTANDARD LVCMOS33 [get_ports rst_led]
