; Ender 3 Custom Start G-code
G92 E0 ; Reset Extruder

M206 X3.58 Y6.50    ; center bed

G28 ; Home all axes

; UBL - full, from https://marlinfw.org/docs/gcode/G029-ubl.html
G29 P1        ; FULL ONLY: Do automated probing of the bed.
G29 P3        ; FULL ONLY: Smart Fill Repeat until all mesh points are filled in, Used to fill unreachable points.
G29 S0        ; FULL ONLY: Save UBL mesh points to slot 0 (EEPROM).
G29 F 10.0    ; FULL ONLY: Set Fade Height for correction at 10.0 mm.
G29 A         ; FULL/FAST: Activate the UBL System
M500          ; FULL ONLY: Save current setup. WARNING - UBL will be active at power up, before any G28.
; G29 L0        ; FAST: Load the mesh stored in slot 0
; G29 J3        ; FAST: Probe 9 points and tilt the mesh according to what it finds

;pacman
M300 S987 P66
M300 S0 P66
M300 S1975 P66
M300 S0 P66
M300 S2959 P66
M300 S0 P66
M300 S2489 P66
M300 S0 P66
M300 S1975 P66
M300 S2959 P66
M300 S0 P133
M300 S2489 P133
M300 S0 P133
M300 S2093 P66
M300 S0 P66
M300 S4186 P66
M300 S0 P66
M300 S3135 P66
M300 S0 P66
M300 S2637 P66
M300 S0 P66
M300 S4186 P66
M300 S3135 P66
M300 S0 P133
M300 S2637 P133
M300 S0 P133
M300 S987 P66
M300 S0 P66
M300 S1975 P66
M300 S0 P66
M300 S2959 P66
M300 S0 P66
M300 S2489 P66
M300 S0 P66
M300 S1975 P66
M300 S2959 P66
M300 S0 P133
M300 S2489 P133
M300 S0 P133
M300 S2489 P66
M300 S2637 P66
M300 S2793 P66
M300 S0 P66
M300 S2793 P66
M300 S2959 P66
M300 S3135 P66
M300 S0 P66
M300 S3135 P66
M300 S3322 P66
M300 S1760 P66
M300 S0 P66
M300 S1975 P100

G1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
G1 X0.1 Y20 Z0.3 F5000.0 ; Move to start position
G1 X0.1 Y200.0 Z0.3 F1500.0 E15 ; Draw the first line
G1 X0.4 Y200.0 Z0.3 F5000.0 ; Move to side a little
G1 X0.4 Y20 Z0.3 F1500.0 E30 ; Draw the second line
G92 E0 ; Reset Extruder
G1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
G1 X5 Y20 Z0.3 F5000.0 ; Move over to prevent blob squish
