onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /tb/rst
add wave -noupdate -radix decimal /tb/clk
add wave -noupdate -radix decimal /tb/repeat
add wave -noupdate -radix decimal /tb/upperBound
add wave -noupdate -radix decimal /tb/count
add wave -noupdate -radix decimal /tb/busy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1963601 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 71
configure wave -valuecolwidth 40
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {5122816 ps}
