FNAME "sliver.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB
Seg_P8000_SW:	equ	0x7000	        ; Segment switch for page 0x8000-BFFFh (ASCII 16k Mapper)

DEBUG:          equ 255             ; defines debug mode, value is irrelevant (comment it out for production version)


; Compilation address
    org 0x4000, 0xbeff	                    ; 0x8000 can be also used here if Rom size is 16kB or less.

    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"
    
    ; INCLUDE "Include/Math.s"

    ; INCLUDE "ReadInput.s"
    ; INCLUDE "GameLogic/PlayerLogic/PlayerInit.s"
    ; INCLUDE "GameLogic/PlayerLogic/PlayerLogic.s"
    ; INCLUDE "GameLogic/ObjectLogic/ObjectInit.s"
    ; INCLUDE "GameLogic/ObjectLogic/ObjectLogic.s"
    ; INCLUDE "UpdateSPRATR.s"
    ; INCLUDE "UpdateSPRATR_Buffer.s"
    
; Default VRAM tables for Screen 4
NAMTBL:     equ 0x1800  ; to 0x1aff (768 bytes)
PATTBL:     equ 0x0000  ; to 0x17ff (6144 bytes)
COLTBL:     equ 0x2000  ; to 0x37ff (6144 bytes)
SPRPAT:     equ 0x3800  ; to 0x3fff (2048 bytes)
SPRCOL:     equ 0x1c00  ; to 0x1dff (512 bytes)
SPRATR:     equ 0x1e00  ; to 0x1e7f (128 bytes)

Execute:
    ; init interrupt mode and stack pointer (in case the ROM isn't the first thing to be loaded)
	di                          ; disable interrupts
	im      1                   ; interrupt mode 1
    ld      sp, (BIOS_HIMEM)    ; init SP


    ld      hl, RamStart        ; RAM start address
    ld      de, RamEnd + 1      ; RAM end address
    call    ClearRam_WithParameters



    call    EnableRomPage2

	; enable page 1
    ld	    a, 1
	ld	    (Seg_P8000_SW), a


; ------------------------------------



    call    BIOS_DISSCR




    ; disable keyboard click
    xor     a
    ld 		(BIOS_CLIKSW), a     ; Key Press Click Switch 0:Off 1:On (1B/RW)



    ; define screen colors
    ld 		a, 15      	            ; Foreground color
    ld 		(BIOS_FORCLR), a    
    ld 		a, 1  		            ; Background color
    ld 		(BIOS_BAKCLR), a     
    ld 		a, 9       	            ; Border color
    ld 		(BIOS_BDRCLR), a    
    call 	BIOS_CHGCLR        		; Change Screen Color

    ; change to screen 4
    ld      a, 4
    call    BIOS_CHGMOD


    call    ClearVram_MSX2

    call    SetSprites16x16

    call    SetSpritesMagnified

    call    Set192Lines

    call    SetColor0ToNonTransparent



; ------------------------------------

    ; ----- Init VRAM


    ld      hl, Palette
    call    LoadPalette


    ; load PATTBL (first part)
    ld		hl, Tile_Patterns           ; RAM address (source)
    ld		de, PATTBL		            ; VRAM address (destiny)
    ld		bc, 0 + (1 * 8)	            ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ld		hl, Tile_Patterns_1         ; RAM address (source)
    ld		de, PATTBL + (1 * 8)        ; VRAM address (destiny)
    ld		bc, 0 + (4 * 8)	            ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ld		hl, Tile_Patterns_1         ; RAM address (source)
    ld		de, PATTBL + (5 * 8)        ; VRAM address (destiny)
    ld		bc, 0 + (4 * 8)	            ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ld		hl, Tile_Patterns_1         ; RAM address (source)
    ld		de, PATTBL + (9 * 8)        ; VRAM address (destiny)
    ld		bc, 0 + (4 * 8)	            ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ld		hl, Tile_Patterns_1         ; RAM address (source)
    ld		de, PATTBL + (13 * 8)        ; VRAM address (destiny)
    ld		bc, 0 + (4 * 8)	            ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ld		hl, Tile_Patterns_1         ; RAM address (source)
    ld		de, PATTBL + (17 * 8)        ; VRAM address (destiny)
    ld		bc, 0 + (4 * 8)	            ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory


    ; load COLTBL (first part)
    ; ld		hl, Tile_Colors             ; RAM address (source)
    ; ld		de, COLTBL		            ; VRAM address (destiny)
    ; ld		bc, Tile_Colors.size	    ; Block length
    ; call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory

    ld      a, 0xba ; foreground color (pattern bits 1), bg color (pattern bits 0)
    ld		hl, COLTBL                  ; RAM address (source)
    ld      bc, 5 * 8                   ; Length of the area to be written
    call    BIOS_BIGFIL                 ; Fill VRAM with value

    ld      a, 0xcb ; foreground color (pattern bits 1), bg color (pattern bits 0)
    ld		hl, COLTBL + (5 * 8)        ; RAM address (source)
    ld      bc, 4 * 8                   ; Length of the area to be written
    call    BIOS_BIGFIL                 ; Fill VRAM with value

    ld      a, 0xdc ; foreground color (pattern bits 1), bg color (pattern bits 0)
    ld		hl, COLTBL + (9 * 8)        ; RAM address (source)
    ld      bc, 4 * 8                   ; Length of the area to be written
    call    BIOS_BIGFIL                 ; Fill VRAM with value

    ld      a, 0xed ; foreground color (pattern bits 1), bg color (pattern bits 0)
    ld		hl, COLTBL + (13 * 8)        ; RAM address (source)
    ld      bc, 4 * 8                   ; Length of the area to be written
    call    BIOS_BIGFIL                 ; Fill VRAM with value

    ld      a, 0xfe ; foreground color (pattern bits 1), bg color (pattern bits 0)
    ld		hl, COLTBL + (17 * 8)        ; RAM address (source)
    ld      bc, 4 * 8                   ; Length of the area to be written
    call    BIOS_BIGFIL                 ; Fill VRAM with value



    ; load NAMTBL (first part)
    ld		hl, NAMTBL_Test             ; RAM address (source)
    ld		de, NAMTBL		            ; VRAM address (destiny)
    ld		bc, NAMTBL_Test.size	    ; Block length
    call 	BIOS_LDIRVM        		    ; Block transfer to VRAM from memory



    call    BIOS_ENASCR

; ------------------------------------

    ; ----- Init vars

    ; call    PlayerInit

    ; ld      hl, Object_0
    ; call    ObjectInit

; ------------------------------------

; --- Main game loop

MainLoop:


    ; ld      a, 10       ; palette color number
    ; ld      hl, Color_10    ; addr of RGB color data
    ; call    SetPaletteColor_FromAddress







    jp  MainLoop


; ------------------------------------

End:

; ----------------------------------------


; ----- Data

    INCLUDE "Data/Palette.s"
    INCLUDE "Data/TilePatterns.s"



NAMTBL_Test:
    db  0
    db  1, 2, 3, 4
    db  5, 6, 7, 8
    db  9, 10, 11, 12
    db  13, 14, 15, 16
    db  17, 18, 19, 20
.size: equ $ - NAMTBL_Test


; ----------------------------------------

    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xFF


; ----------------------------------------

; ----- MegaROM pages at 0x8000

    INCLUDE "Data/MegaRomPages.s"


; ----------------------------------------

; ----- RAM

RamStart:

    INCLUDE "Variables.s"

RamEnd: