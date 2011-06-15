onerror {resume}
quietly WaveActivateNextPane {} 0
#add wave /top_tb/top_1/*
add wave /top_tb/clk

add wave /top_tb/rst
add wave /top_tb/top_1/camd5m_init_unit/*


add wave /top_tb/cam_reset
add wave /top_tb/cam_sclk
add wave /top_tb/cam_sdata
add wave /top_tb/cam_sdata
add wave /top_tb/led_red



TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4475000 ps} 0}
configure wave -namecolwidth 347
configure wave -valuecolwidth 185
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {4333956 ps} {5517692 ps}
