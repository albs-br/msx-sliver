
; Inputs:
;   SP: ROM start addr of column strip (16 bytes)
;   HL: NAMTBL_buffer addr for this column
DrawColumn_SP:

        ; before
    ld      a, l
    ld      d, 32

    ; 47 cycles to read 2 bytes and write them to addresses 32 bytes apart
    ; (...) unrolled 8x = 8 * 47 = 376 cycles for each column! 11280 cycles for 30 columns
    pop     bc
    ld      (hl), c
    ;add     hl, de
    add     d           ; L += 32
    ld      l, a
    ld      (hl), b
    add     d
    ld      l, a

    ; after 4 repetitions
    inc     h

    ret


; Inputs:
;   HL: ROM start addr of column strip (16 bytes)
;       Columns + (0 * 16) ; first column
;       Columns + (59 * 16) ; 59 = last column
;   DE: NAMTBL_buffer addr for this column
DrawColumn:

    ld      ixh, d ; save d

    ; before
    ld      a, e    ; save lower byte of DE
    ld      b, 32   ; value to be used to DE += 32 (next line of NAMTBL)
    ld      c, 255  ; safe value to LDI not touch B

    ; (...) unrolled 16x = 16 * 28 = 448 cycles for each column! 13440 cycles for 30 columns
    ldi     ; copy byte from (HL) to (DE), increment both HL and DE, decrement BC
    add     b       ; DE += 32, ignoring previous increment
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ; after 8 repetitions
    ld      d, ixh  ; restore d
    inc     d       ; is it really necessary? A: yes, the last LDI increments E from 224 to 225...



    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ldi
    add     b
    ld      e, a

    ret