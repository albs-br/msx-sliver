; cast all 32 rays for current player position and angle
Raycast:






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
    
    ; res     7, l        ; reset lowest bit of L
    ld      a, l
    and     1111 1110 b
    ld      l, a
    
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

        ; ld      (TempWord_1), de  ; debug
        ; ld      a, c
        ; ld      (TempByte_1), a
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

        ; ld      (TempWord_1), de  ; debug
        ; ld      a, c
        ; ld      (TempByte_1), a
    pop     hl, af
    
    ; AHL = AHL + CDE
    scf     ; set carry flag
    ccf     ; complement (invert) carry flag
    add     hl, de
    adc     a, c        ; A = A + C + carry

    ld      e, l            ; DE = HL
    ld      d, h

    ; clear 2 highest bits of D
    push    af
        ld      a, d
        and     0011 1111 b
        ld      d, a

        ; DE += 0x8000        ; 0x8000 = base addr of MegaROM page
        ld      bc, 0x8000
        ex      de, hl
            add     hl, bc
        ex      de, hl

        ld      (PreCalcData_BaseAddr), de
    pop     af

    ; ------ megarom page number
    ; AHL format:
    ; --aaaaaa aabbbbbb bbbbbbbb
    ; 11111111 11111111 11111111 
    ; 
    ; aaaaaaaa          : megarom page (8 bits), must add to MAPS_MEGAROM_PAGE
    ; bbbbbb bbbbbbbb   : address inside megarom page (14 bits)

    ; shift left AH 2 bits
    scf     ; set carry flag
    ccf     ; complement (invert) carry flag
    rl      h
    rla
    rl      h
    rla

    add     PRECALC_DATA_FIRST_MEGAROM_PAGE

    ld      (PreCalcData_MegaromPage), a

    ; set MegaROM page for Precalc data
    ld	    (Seg_P8000_SW), a





; DE points to precalc squares touched data for current angle and player position inside cell
    ; DE += 2       ; +2 to skip the 2 first fields of block data
    inc     de
    inc     de

; HL points to current player cell on map
    ld      hl, (Player.mapCellAddr)

;--------
    ld      b, 0

    ld      ixl, 20
.loop:

        ; HL points to current player cell on map
        ; DE points to precalc squares touched data for current angle and player position inside cell

        ; TODO: unroll loop 20x: 53 * 20 cycles max to find wall
        ld      a, (de)
    
        ld      c, a

        add     hl, bc                  ; BUG here: negative values in 8 bits cannot be coverted to 16 bits this way

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

    ; number of tiles = DE - PreCalcData_BaseAddr - 2
    dec     de
    dec     de
    ex      de, hl      ; HL = DE
    ld      de, (PreCalcData_BaseAddr)
    xor     a
    sbc     hl, de


 ld (TempWord_2), hl; debug
 ;jp $ ; debug

    ; ld      hl, Columns + (0 * 16) ; first column
    ; ld      hl, Columns + (59 * 16) ; 59 = last column
    ; ld      de, NAMTBL_Buffer + 30
    ; call    DrawColumn


    ret