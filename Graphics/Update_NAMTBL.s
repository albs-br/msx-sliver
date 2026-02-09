Update_NAMTBL:

    ; TODO: change to unrolled OUTIs for performance
    ; load NAMTBL from buffer
    ld		hl, NAMTBL_Buffer           ; RAM address (source)
    ld		de, NAMTBL		            ; VRAM address (destiny)
    ld		bc, 512	                    ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ret