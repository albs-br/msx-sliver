PlayerInit:

    ; ld      hl, 32768 ; center of map
    

    ;     ld      hl, 32768 + 16384
    ; ld      (Object_Temp.X), hl ; X
    ; ld      hl, 32768 - 16384
    ; ld      (Object_Temp.Y), hl ; Y

    ld      hl, 32768 + 16384 - 256
    ld      (Player.X), hl
    
    ld      hl, 32768 - 16384 + 256
    ld      (Player.Y), hl
    
    ld      hl, 45
    ld      (Player.angle), hl

.updateCalcFields:
    ; call    Update_FoV
    ; call    Update_walkDXandDY

    ret