Player_Update_AllFields:

    call    Player_Update_MapCell
    ; call    Player_Update_FoV
    call    Player_Update_walkDXandDY

    ret

Player_Update_MapCell:

    ; map_cell = (Y*64) + X

    ld      h, 0
    ld      a, (Player.map_Y)
    ld      l, a

    ; --- shift left 6 bits
    ; T-Cycles: 52
    ; Bytes: 13
    ; Trashed: A
    XOR A
    SRL H
    RR L
    RRA
    SRL H
    RR L
    RRA
    LD H, L
    LD L, A

    ld      b, h
    ld      c, l

    ld      h, 0
    ld      a, (Player.map_X)
    ld      l, a

    add     hl, bc



    ; Add to map addr on RAM
    ld      bc, Map
    add     hl, bc

    ld      (Player.mapCell), hl

    ret

Player_Update_walkDXandDY:

    ; set MegaROM page for LUT data
    ld      a, LUT_MEGAROM_PAGE
    ld	    (Seg_P8000_SW), a


    ; --- Update .walk_DX based on angle
    ld      hl, (Player.angle)
    
    add     hl, hl          ; HL = HL * 2

    ld      d, h            ; DE = HL
    ld      e, l

    ld      hl, LUT_cos     ; HL = LUT_cos + DE
    add     hl, de

    ld      e, (hl)         ; DE = (HL)
    inc     hl
    ld      d, (hl)

    ; ; shift right to make player walking slower
    ; push    hl
    ;     call    ShiftRight_DE
    ; pop     hl

    ld      (Player.walk_DX), de
    



    ; --- Update .walk_DY based on angle
    ld      hl, (Player.angle)
    
    add     hl, hl          ; HL = HL * 2

    ld      d, h            ; DE = HL
    ld      e, l

    ld      hl, LUT_sin     ; HL = LUT_sin + DE
    add     hl, de

    ld      e, (hl)         ; DE = (HL)
    inc     hl
    ld      d, (hl)

    ; ; for angles 0-89 invert signal (invert all bits, then add 1, ignoring overflow)
    ; ld      a, e
    ; xor     1111 1111 b
    ; ld      e, a
    
    ; ld      a, d
    ; xor     1111 1111 b
    ; ld      d, a

    ; inc     de

    ; ; shift right to make player walking slower
    ; push    hl
    ;     call    ShiftRight_DE
    ; pop     hl

    ld      (Player.walk_DY), de

    ret

