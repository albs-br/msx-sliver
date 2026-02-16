LoadTiles:

    ; load PATTBL (first part)
    ld		hl, Tile_Patterns           ; RAM address (source)
    ld		de, PATTBL		            ; VRAM address (destiny)
    ld		bc, Tile_Patterns.size      ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ; load COLTBL (first part)
    ld		hl, Tile_Colors             ; RAM address (source)
    ld		de, COLTBL		            ; VRAM address (destiny)
    ld		bc, Tile_Colors.size        ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ; ; load NAMTBL (first part)
    ; ld		hl, NAMTBL_Test             ; RAM address (source)
    ; ld		de, NAMTBL		            ; VRAM address (destiny)
    ; ld		bc, NAMTBL_Test.size	    ; Block length
    ; call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ; load PATTBL (second part)
    ld		hl, Tile_Patterns           ; RAM address (source)
    ld		de, PATTBL + (256 * 8)      ; VRAM address (destiny)
    ld		bc, Tile_Patterns.size      ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ; load COLTBL (second part)
    ld		hl, Tile_Colors             ; RAM address (source)
    ld		de, COLTBL + (256 * 8)      ; VRAM address (destiny)
    ld		bc, Tile_Colors.size        ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory


;     ; --- reverse each pattern on PATTBL (second part)
;     ld		hl, PATTBL + (256 * 8)      ; VRAM address (source)
;     ld      b, 160
; .loop_10:    
;     push    bc
;         ld      de, TempData                ; RAM address (destiny)
;         ld		bc, 8                       ; Block length
;         push    hl
;             call 	BIOS_LDIRMV        		    ; Block transfer to memory from VRAM (READ FROM VRAM)
;         pop     hl
;         xor     a
;         ;ld      hl, NAMTBL
;         push    hl
;             call    SetVDP_Write ; Set VDP address counter to write from address AHL (17-bit)
;             ld      hl, TempData + 7
;             ld      c, PORT_0
;             ld      b, 8
;         .loop_11:
;             ld      a, (hl)
;             out     (c), a
;             dec     hl
;             djnz    .loop_11

            
;         pop     hl
;         ld      bc, 8
;         add     hl, bc
;     pop     bc
;     djnz    .loop_10



    ; --- reverse each tile on COLTBL (second part)
    ld		hl, COLTBL + (256 * 8)      ; VRAM address (source)
    ld      b, 160
.loop_20:    
    push    bc
        ld      de, TempData                ; RAM address (destiny)
        ld		bc, 8                       ; Block length
        push    hl
            call 	BIOS_LDIRMV        		    ; Block transfer to memory from VRAM (READ FROM VRAM)
        pop     hl
        xor     a
        ;ld      hl, NAMTBL
        push    hl
            call    SetVDP_Write ; Set VDP address counter to write from address AHL (17-bit)
            ld      hl, TempData + 7
            ld      c, PORT_0
            ld      b, 8
        .loop_21:
            ld      a, (hl)
            out     (c), a
            dec     hl
            djnz    .loop_21

            
        pop     hl
        ld      bc, 8
        add     hl, bc
    pop     bc
    djnz    .loop_20




    ; ---- tiles for BlackColumn
    ; load PATTBL (first part)
    ld		hl, Tile_Patterns + (4 * 8) ; RAM address (source)
    ld		de, PATTBL + (254 * 8)      ; VRAM address (destiny)
    ld		bc, 8                       ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ; load COLTBL (first part)
    ld      hl, BlackColumn_Colors
    ld		de, COLTBL + (254 * 8)      ; RAM address (source)
    ld      bc, 8                       ; Length of the area to be written
    call    BIOS_LDIRVM                 ; Fill VRAM with value

    ; load PATTBL (second part)
    ld		hl, Tile_Patterns + (4 * 8)             ; RAM address (source)
    ld		de, PATTBL + (256 * 8) + (254 * 8)      ; VRAM address (destiny)
    ld		bc, 8                       ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ; load COLTBL (second part)
    ld      hl, BlackColumn_Colors_Reverted
    ld		de, COLTBL + (256 * 8) + (254 * 8)      ; RAM address (source)
    ld      bc, 8                       ; Length of the area to be written
    call    BIOS_LDIRVM                 ; Fill VRAM with value


    ret