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
    ld 		a, 14      	            ; Border color
    ld 		(BIOS_BDRCLR), a    
    call 	BIOS_CHGCLR        		; Change Screen Color

    ; change to screen 4
    ld      a, 4
    call    BIOS_CHGMOD


    call    ClearVram_MSX2

    call    SetSprites16x16

    call    SetSpritesMagnified

    call    Set192Lines

    ; call    SetColor0ToNonTransparent


    call    BIOS_ENASCR

; ------------------------------------

    ; ----- Init vars

    ; call    PlayerInit

    ; ld      hl, Object_0
    ; call    ObjectInit

; ------------------------------------

; --- Main game loop

; ; code from msxpen (need to set screen 0 and comment out "call    ClearVram_MSX2" above)
;             ld hl, HelloWorld_Str
; mainLoop:   ld a, (hl)
;             cp 0
;             jp z, $             ; eternal loop if end of string
;             call BIOS_CHPUT
;             inc hl
;             jr mainLoop



; ------------------------------------

End:

; ----------------------------------------


; ----- Data

HelloWorld_Str:          db "Hello world", 0

; ----------------------------------------

    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xFF


; ----------------------------------------
; MegaROM pages at 0x8000



; ------- Page 1
	org	0x8000, 0xBFFF

; LUT_MEGAROM_PAGE: equ 1

; MegaROM_Page_1:
;     INCLUDE "LookUpTables/LUT_Cos.s"
;     INCLUDE "LookUpTables/LUT_Sin.s"
;     INCLUDE "LookUpTables/LUT_Atan2.s"
;     INCLUDE "LookUpTables/LUT_PowerOf2.s"
;     INCLUDE "LookUpTables/LUT_SqRoot.s"
; MegaROM_Page_1_size:      equ $ - MegaROM_Page_1

	ds PageSize - ($ - 0x8000), 255



; ----------------------------------------

; RAM

RamStart:

    INCLUDE "Variables.s"

RamEnd: