Update_NAMTBL:

    ; ---- load NAMTBL from buffer

    ; ld		hl, NAMTBL_Buffer           ; RAM address (source)
    ; ld		de, NAMTBL		            ; VRAM address (destiny)
    ; ld		bc, 512	                    ; Block length
    ; call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ; unrolled OUTIs for performance
    xor     a
    ld      hl, NAMTBL
    call    SetVDP_Write ; Set VDP address counter to write from address AHL (17-bit)

    ld      c, PORT_0
    ld      hl, NAMTBL_Buffer

    ; 16 x 32 = 512
    ld      d, 16
.loop:
        ; 32x outi
        outi outi outi outi outi outi outi outi 
        outi outi outi outi outi outi outi outi 
        outi outi outi outi outi outi outi outi 
        outi outi outi outi outi outi outi outi 
    dec     d
    jp      nz, .loop

    ret