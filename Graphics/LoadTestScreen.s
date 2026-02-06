; LoadTestScreen_old:

;     ; load PATTBL (first part)
;     ld		hl, Tile_Patterns         ; RAM address (source)
;     ld		de, PATTBL		            ; VRAM address (destiny)
;     ld		bc, 0 + (1 * 8)	            ; Block length
;     call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

;     ld		hl, Tile_Patterns         ; RAM address (source)
;     ld		de, PATTBL + (1 * 8)        ; VRAM address (destiny)
;     ld		bc, 0 + (4 * 8)	            ; Block length
;     call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

;     ld		hl, Tile_Patterns         ; RAM address (source)
;     ld		de, PATTBL + (5 * 8)        ; VRAM address (destiny)
;     ld		bc, 0 + (4 * 8)	            ; Block length
;     call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

;     ld		hl, Tile_Patterns         ; RAM address (source)
;     ld		de, PATTBL + (9 * 8)        ; VRAM address (destiny)
;     ld		bc, 0 + (4 * 8)	            ; Block length
;     call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

;     ld		hl, Tile_Patterns         ; RAM address (source)
;     ld		de, PATTBL + (13 * 8)        ; VRAM address (destiny)
;     ld		bc, 0 + (4 * 8)	            ; Block length
;     call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

;     ld		hl, Tile_Patterns         ; RAM address (source)
;     ld		de, PATTBL + (17 * 8)        ; VRAM address (destiny)
;     ld		bc, 0 + (4 * 8)	            ; Block length
;     call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory


;     ; load COLTBL (first part)
;     ; ld		hl, Tile_Colors             ; RAM address (source)
;     ; ld		de, COLTBL		            ; VRAM address (destiny)
;     ; ld		bc, Tile_Colors.size	    ; Block length
;     ; call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

;     ld      a, 0xaa ; foreground color (pattern bits 1), bg color (pattern bits 0)
;     ld		hl, COLTBL                  ; RAM address (source)
;     ld      bc, 1 * 8                   ; Length of the area to be written
;     call    BIOS_BIGFIL                 ; Fill VRAM with value

;     ld      a, 0xba ; foreground color (pattern bits 1), bg color (pattern bits 0)
;     ld		hl, COLTBL + (1 * 8)        ; RAM address (source)
;     ld      bc, 4 * 8                   ; Length of the area to be written
;     call    BIOS_BIGFIL                 ; Fill VRAM with value

;     ld      a, 0xcb ; foreground color (pattern bits 1), bg color (pattern bits 0)
;     ld		hl, COLTBL + (5 * 8)        ; RAM address (source)
;     ld      bc, 4 * 8                   ; Length of the area to be written
;     call    BIOS_BIGFIL                 ; Fill VRAM with value

;     ld      a, 0xdc ; foreground color (pattern bits 1), bg color (pattern bits 0)
;     ld		hl, COLTBL + (9 * 8)        ; RAM address (source)
;     ld      bc, 4 * 8                   ; Length of the area to be written
;     call    BIOS_BIGFIL                 ; Fill VRAM with value

;     ld      a, 0xed ; foreground color (pattern bits 1), bg color (pattern bits 0)
;     ld		hl, COLTBL + (13 * 8)        ; RAM address (source)
;     ld      bc, 4 * 8                   ; Length of the area to be written
;     call    BIOS_BIGFIL                 ; Fill VRAM with value

;     ld      a, 0xfe ; foreground color (pattern bits 1), bg color (pattern bits 0)
;     ld		hl, COLTBL + (17 * 8)        ; RAM address (source)
;     ld      bc, 4 * 8                   ; Length of the area to be written
;     call    BIOS_BIGFIL                 ; Fill VRAM with value



;     ; load NAMTBL (first part)
;     ld		hl, NAMTBL_Test             ; RAM address (source)
;     ld		de, NAMTBL		            ; VRAM address (destiny)
;     ld		bc, NAMTBL_Test.size	    ; Block length
;     call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory


;     ret




LoadTestScreen:


    ; --- load NAMTBL (first part) to show all chars
    xor     a
    ld      hl, NAMTBL
    call    SetVDP_Write ; Set VDP address counter to write from address AHL (17-bit)
   
    xor     a
    ld      b, 160
.loop:
	out		(PORT_0), a
    inc     a
    djnz    .loop

    ; --- load NAMTBL (second part) to show all chars
    xor     a
    ld      hl, NAMTBL + 256
    call    SetVDP_Write ; Set VDP address counter to write from address AHL (17-bit)
   
    xor     a
    ld      b, 160
.loop_1:
	out		(PORT_0), a
    inc     a
    djnz    .loop_1


    ret