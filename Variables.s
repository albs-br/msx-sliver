	org     0xc000

MAP_WIDTH:      equ 64
MAP_HEIGHT:     equ 64

; table aligned
Map:            rb MAP_WIDTH * MAP_HEIGHT      ; 64 x 64 map cells


; table aligned
NAMTBL_Buffer:  rb 512          ; buffer for first and second parts of screen

; table aligned
;SPRATR_Buffer:  rb 128




;            QIII | QIY
;            -----+-----
;            QII  | QI
;
;            Quadrant 	x-coordinate	y-coordinate
;            I (QI)	    Positive (+)	Positive (+)
;            II (QII)	Negative (-)	Positive (+)
;            III (QIII)	Negative (-)	Negative (-)
;            IV (QIV)	Positive (+)	Negative (-)

	org     0xe000          ; fixed address for make it easier to track vars with the tcl script
Player:
    .X:             rw 1        ; X coord of player on map (8.8 fixed point), integer part: 0-63
    .map_X:         equ $ - 1   ; X player cell on map
    .Y:             rw 1        ; Y coord of player on map (8.8 fixed point), integer part: 0-63
    .map_Y:         equ $ - 1   ; Y player cell on map
    .angle:         rw 1        ; 0-359 degrees, 0 is left (east), increments clockwise
    .FoV_start:     rw 1        ; 0-359 degrees
    .FoV_end:       rw 1        ; 0-359 degrees
    .walk_DX:       rw 1        ; 8.8 fixed point
    .walk_DY:       rw 1        ; 8.8 fixed point
    .mapCellAddr:   rw 1        ; real addr of current map cell position
    .mapCellValue:  rb 1        ; value of current map cell position

TempData:       rb 8

PreCalcData_MegaromPage:    rb 1
PreCalcData_BaseAddr:       rw 1


; Saved_SP:       rw 1

; SavedJiffy:     rb 1




; SPRATR_Buffer:  rb 128 ; TODO: table align it to use INC L instead of INC HL


;     org     0xc100 ; fixed addr to make it easier to track on tcl debug script
; Object_0:       ;rb Object_Temp.size
;     .X:                 rw 1 ; X coord of object on map (0-65535)
;     .Y:                 rw 1 ; Y coord of object on map (0-65535)
;     .distance_X:        rw 1 ; distance X to player
;     .distance_Y:        rw 1 ; distance Y to player
;     .angleToPlayer:     rw 1 ; angle between player and this object (0-359)
;     .isVisible:         rb 1 ; indicates if object is inside player field of view (0: not visible, not 0: visible)
;     .posX_inside_FoV:   rb 1 ; X coord of the object center inside player FoV, when visible (0-63)
;     .quadrant:          rb 1 ; quadrant in relation to player pos on map (1-4)
;     .Y_div_by_X:        rb 3 ; division result in 16.8 fixed point
;     .distanceToPlayer:  rb 1 ; distance to player when visible (0-254), 0 is closer, 255 is out of sight
;     .objDataAddr:       rw 1 ; addr of object data (sprite patterns, colors, etc)

; ;     org     0xc200
; ; Object_1:       rb Object_Temp.size

;     org     0xd000
; Object_Temp:
;     .X:                 rw 1 ; X coord of object on map (0-65535)
;     .Y:                 rw 1 ; Y coord of object on map (0-65535)
;     .distance_X:        rw 1 ; distance X to player
;     .distance_Y:        rw 1 ; distance Y to player
;     .angleToPlayer:     rw 1 ; angle between player and this object (0-359)
;     .isVisible:         rb 1 ; indicates if object is inside player field of view (0: not visible, not 0: visible)
;     .posX_inside_FoV:   rb 1 ; X coord of the object center inside player FoV, when visible (0-63)
;     .quadrant:          rb 1 ; quadrant in relation to player pos on map (1-4)
;     .Y_div_by_X:        rb 3 ; division result in 16.8 fixed point
;     .distanceToPlayer:  rb 1 ; distance to player when visible (0-254), 0 is closer, 255 is out of sight
;     .objDataAddr:       rw 1 ; addr of object data (sprite patterns, colors, etc)
; .size:          equ $ - Object_Temp

; ObjectAddress:  rw 1



; Sprites:
;     .sprite_0_Y:        rb 1    ; Y
;     .sprite_0_X:        rb 1    ; X
;     .sprite_0_Pattern:  rb 1    ; pattern
;     .sprite_0_Distance: rb 1    ; distance (0-255)

;     .sprite_1_Y:        rb 1    ; Y
;     .sprite_1_X:        rb 1    ; X
;     .sprite_1_Pattern:  rb 1    ; pattern
;     .sprite_1_Distance: rb 1    ; distance (0-255)    