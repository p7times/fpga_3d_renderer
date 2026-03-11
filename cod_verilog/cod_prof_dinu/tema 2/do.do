vlog -reportprogress 300 -work work ./*.v
vsim -gui work.divTEST
add wave -position insertpoint sim:/divTEST/*
run 1000

