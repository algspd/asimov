G21 (Set units to mm)
G90 (Absolute coordinates)
G28 (--Home all Axis ---)
G92 X0 Y0 Z0 E0 (-- Current position is 0,0,0 ---)
G1 Z1.0 F160.0
G1 X50 Y0 Z1 F2000
;-- Go up 2mm and then go to the center
G1 Z2.0 F160.0
G1 X50 Y50 Z0.72 F2000.0

