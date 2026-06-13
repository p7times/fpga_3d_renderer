# 150 MHz
# create_clock -period 5.000 -name clk -waveform {0.000 2.500} [get_ports clk]

# 125 MHz
create_clock -period 8.000 -name sys_clk -waveform {0.000 4.000} [get_ports sys_clk]
# 100 MHz
#create_clock -period 10 -name clk -waveform {0.000 6.734} [get_ports sys_clk]

# 74.25 MHz
#create_clock -period 13.4669343 -name clk -waveform {0.000 6.73346715} [get_ports sys_clk]

# 50 MHz
#create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports clk]

