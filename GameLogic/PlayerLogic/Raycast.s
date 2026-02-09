; cast all 32 rays for current player position and angle
Raycast:


; HL points to current player cell on map
    ; ld      hl, (Player.mapCellAddr)

; DE points to precalc squares touched data for current angle and player position inside cell
    ; ld      a, (Player.X)   ; get lowest byte of X
    ; srl     a               ; shift right register 4x to get 4 highest bits (0-15 position inside cell)
    ; srl     a
    ; srl     a
    ; srl     a



; formula to get correct block data:

    ; ex: 
    ; angle = 359
    ; x = 15
    ; y = 15
    ; angle * 32 = 11488
    ; ----
    ; 15 * 720 = 10800
    ; ----
    ; 15 * 11520 = 172800
    ; Result : 00101111101000010000
    ; megarom page: 10111110 = 190

    ; --- each angle =>     (angle/2) * 64)                 =>      angle * 32
    ld      hl, (Player.angle)
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl




    ; set MegaROM page for LUT data
    ld      a, LUT_MEGAROM_PAGE
    ld	    (Seg_P8000_SW), a

    push    hl
        ; --- each x =>         (x_inside_cell) * (180 * 64)             =>      x * 11520
        ld      a, (Player.x_inside_cell)
        ld      l, a
        ld      h, 0
        
        ld      c, l            ; BC = HL
        ld      b, h
        
        add     hl, bc          ; mult by 3 (each data is 3 bytes long)
        add     hl, bc

        ld      bc, LUT_multiply_11520
        add     hl, bc

        ld      e, (hl)     ; CDE = (HL)
        inc     hl
        ld      d, (hl)
        inc     hl
        ld      c, (hl)
    pop     hl

    ; AHL = HL + CDE
    xor     a
    add     hl, de
    adc     a, c        ; A = A + C + carry

    ; ld      e, l            ; DE = HL
    ; ld      d, h

    push    af, hl
        ; --- each y =>         (y_inside_cell) * (16 * (180 * 64))      =>      y * 184320
        ld      a, (Player.y_inside_cell)
        ld      l, a
        ld      h, 0
        
        ld      c, l            ; BC = HL
        ld      b, h
        
        add     hl, bc          ; mult by 3 (each data is 3 bytes long)
        add     hl, bc

        ld      bc, LUT_multiply_184320
        add     hl, bc

        ld      e, (hl)     ; CDE = (HL)
        inc     hl
        ld      d, (hl)
        inc     hl
        ld      c, (hl)
    pop     hl, af
    
    ; AHL = AHL + CDE
    scf     ; set carry flag
    ccf     ; complement (invert) carry flag
    add     hl, de
    adc     a, c        ; A = A + C + carry

    ld      e, l            ; DE = HL
    ld      d, h

    ; clear 2 highest bits of D
    ld      a, d
    and     0011 1111 b
    ld      d, a

    ld      (PreCalcData_BaseAddr), de

    ; ------ megarom page number
    ; AHL format:
    ; --aaaaaa aabbbbbb bbbbbbbb
    ; 11111111 11111111 11111111 
    ; 
    ; aaaaaaaa          : megarom page (8 bits), must add to MAPS_MEGAROM_PAGE
    ; bbbbbb bbbbbbbb   : address inside megarom page (14 bits)

    rl      h
    rla
    rl      h
    rla

    add     PRECALC_DATA_FIRST_MEGAROM_PAGE

    ld      (PreCalcData_MegaromPage), a

    ; set MegaROM page for Precalc data
    ld	    (Seg_P8000_SW), a



; HL points to current player cell on map
    ld      hl, (Player.mapCellAddr)

; DE points to precalc squares touched data for current angle and player position inside cell

    ; DE += 2
    inc     de
    inc     de

;--------
    ld      b, 0

    ld      ixl, 20
.loop:
        ; TODO: unroll loop 20x: 53 * 20 cycles max to find wall
        ld      a, (de)
    
        ld      c, a

        add     hl, bc

        ld      a, (hl)
        or      a
        jr      nz, .is_wall        ; JR wont work here if destiny is over 127 bytes
        ;call    nz, .is_not_empty ; map cell contains enemy/object <--- IMPROVE THIS PART

        inc     de

    dec     ixl
    jp      nz, .loop

    ; if wall not found, assume wall on last iteration
    ;ret

.is_wall:

    ; get distance and
    ; call DrawColumn with it



    ; ld      hl, Columns + (0 * 16) ; first column
    ; ld      hl, Columns + (59 * 16) ; 59 = last column
    ; ld      de, NAMTBL_Buffer + 30
    ; call    DrawColumn


    ret