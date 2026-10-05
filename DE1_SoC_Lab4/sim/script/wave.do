onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /servo_controller_tb/clk_50_tb
add wave -noupdate /servo_controller_tb/reset_n_tb
add wave -noupdate /servo_controller_tb/irq
add wave -noupdate /servo_controller_tb/writedata
add wave -noupdate /servo_controller_tb/address
add wave -noupdate /servo_controller_tb/out_wave
add wave -noupdate /servo_controller_tb/uut/CLK_50
add wave -noupdate /servo_controller_tb/uut/reset_n
add wave -noupdate /servo_controller_tb/uut/writedata
add wave -noupdate /servo_controller_tb/uut/write
add wave -noupdate /servo_controller_tb/uut/address
add wave -noupdate /servo_controller_tb/uut/irq
add wave -noupdate /servo_controller_tb/uut/out_wave_export
add wave -noupdate -radix unsigned /servo_controller_tb/uut/angle_count
add wave -noupdate -radix unsigned /servo_controller_tb/uut/period_count
add wave -noupdate -radix unsigned /servo_controller_tb/uut/count_registers
add wave -noupdate /servo_controller_tb/uut/present_state
add wave -noupdate /servo_controller_tb/uut/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4028 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {3990 ns} {4191 ns}
