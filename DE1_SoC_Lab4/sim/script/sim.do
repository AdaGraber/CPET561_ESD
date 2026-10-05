vlib work

vcom -93 -work work ../../servo_controller.vhd
vcom -93 -work work ../src/servo_controller_tb.vhd
vsim -voptargs=+acc servo_controller_tb
do wave.do
run 200000 ns
