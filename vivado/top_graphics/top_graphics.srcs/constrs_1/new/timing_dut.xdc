# 150 MHz
# create_clock -period 5.000 -name clk -waveform {0.000 2.500} [get_ports clk]

# 74.25 MHz
create_clock -period 13.468 -name clk -waveform {0.000 6.734} [get_ports clk]

# 50 MHz
#create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports clk]

