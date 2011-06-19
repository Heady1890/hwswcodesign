onerror {resume}
quietly WaveActivateNextPane {} 0

#add wave /top_tb_kamera/sys_clk
add wave /top_tb_kamera/sys_res
add wave /top_tb_kamera/cam_pixclk
add wave /top_tb_kamera/cam_fval
add wave /top_tb_kamera/cam_lval
add wave /top_tb_kamera/cam_d

add wave /top_tb_kamera/read_kamera1/*

add wave /top_tb_kamera/tp_ram1/*

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
