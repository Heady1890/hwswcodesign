onerror {resume}
quietly WaveActivateNextPane {} 0
#add wave /top_tb/top_1/*
add wave /top_tb/top_1/rwsdram0/*
add wave /top_tb/top_1/rwsdramsel
add wave /top_tb/top_1/dp_ram0/*
#add wave /top_tb/top_1/counter_segsel
add wave /top_tb/top_1/exti
add wave /top_tb/top_1/clk
add wave /top_tb/top_1/rst

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
