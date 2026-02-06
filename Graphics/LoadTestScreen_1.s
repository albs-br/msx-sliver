LoadTestScreen_1:


    ; ld      a, 10       ; palette color number
    ; ld      hl, Color_10    ; addr of RGB color data
    ; call    SetPaletteColor_FromAddress


    ; TODO: not working, necessary for performance improvement
    ; di
    ;     ld      (Saved_SP), sp
        
    ;     ld      sp, Columns + (0 * 8)
    ;     ld      hl, NAMTBL_Buffer + 0
    ;     call    DrawColumn

    ;     ld      sp, (Saved_SP)
    ; ei



    ; ; --- test showing some columns
    ; ld      hl, Columns + (0 * 16)
    ; ld      de, NAMTBL_Buffer + 0
    ; call    DrawColumn

    ; ld      hl, Columns + (10 * 16)
    ; ld      de, NAMTBL_Buffer + 1
    ; call    DrawColumn

    ; ld      hl, Columns + (59 * 16) ; 59 = last column
    ; ld      de, NAMTBL_Buffer + 30
    ; call    DrawColumn

    ; ld      hl, Columns + (20 * 16)
    ; ld      de, NAMTBL_Buffer + 31
    ; call    DrawColumn


    ; TODO: improve dithering patterns (more patterns for smoother transitions)
    ; --- test showing columns in sequence
    ; ld      hl, Columns
    ld      hl, Columns + (28 * 16)
    ld      de, NAMTBL_Buffer
    ld      ixl, 32       ; counter
.loop:
    push    ix
        push    hl, de
            call    DrawColumn
        pop     de, hl
        
        ld      bc, 16       ; offset to be added to Columns Addr
        add     hl, bc

        inc     de

    pop     ix
    dec     ixl
    jp      nz, .loop



    ; TODO: change to unrolled OUTIs for performance
    ; load NAMTBL from buffer
    ld		hl, NAMTBL_Buffer           ; RAM address (source)
    ld		de, NAMTBL		            ; VRAM address (destiny)
    ld		bc, 512	                    ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory


    ret