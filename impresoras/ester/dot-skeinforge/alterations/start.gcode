M190 S75 (--Wait for the bed to get 75C ---)
M109 S190 (-- Wait for the hotend to get 190 ---)
M104 S220
M140 S100
G21 (Set units to mm)
G90 (Absolute coordinates)
G28 (--Home all Axis ---)
G1 Z10 F120(Go up)
G91 (Relative coordinates)
G1 E15 F150 (Extrude 15mm)
G90 (Absolute coordinates)
G28 (--Home all Axis ---)
G92 X0 Y0 Z0 E0 (-- Current position is 0,0,0 ---)
G1 Z1.0 F120.0
G1 X50 Y0 Z1 F2000
;-- Go up 2mm and then go to the center
G1 Z2.0 F160.0
G1 X50 Y50 Z0.72 F2000.0

