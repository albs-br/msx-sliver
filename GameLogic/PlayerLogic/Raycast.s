; cast all 32 rays for current player position and angle
Raycast:


    ; ------------------- Init

    xor     a
    ld      (CurrentColumn), a


    ; --- CurrentAngle = Player.angle - 32
    ld      hl, (Player.angle)

    ; not necessary anymore, as only even angles are used
    ; ; res     7, l        ; reset lowest bit of L
    ; ld      a, l          
    ; and     1111 1110 b
    ; ld      l, a

    ; if (angle < 32)
    ld      de, 32
    rst     BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jp      c, .lessThan32

    ; angle -= 32
    ld      bc, -32
    add     hl, bc
    jp      .saveAngle
    
.lessThan32:    
    ; angle = 360 - (32 - angle)        =>      angle = 360 - 32 + angle     =>      angle = 328 + angle
    ld      bc, 328
    add     hl, bc
    
.saveAngle:
    ld      (CurrentAngle), hl



.loopColumns:

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
    ld      hl, (CurrentAngle)
    
    ; not necessary (is always 0)
    ; ; res     7, l        ; reset lowest bit of L
    ; ld      a, l
    ; and     1111 1110 b
    ; ld      l, a
    
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
    ; ld      b, 0 ; not needed when using sign extension


    ; 20x unrolled code to avoid loop logic (21 * 20 * 32 = 13440 cycles saved)
    ; 71 cycles x 20 x 32 = 45440 cycles
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    INCLUDE "GameLogic/PlayerLogic/Raycast_Tiles.s"
    
    ; ---- old

;     ld      ixl, 20 ; max number of tiles
; .loop:

        ; ; ----- Tiles delta calc and test if is wall

        ; ; HL points to current player cell on map
        ; ; DE points to precalc squares touched data for current angle and player position inside cell

        ; ; TODO: unroll loop 20x: 53 * 20 cycles max to find wall
        ; ld      a, (de)

        ; ; sign extension (convert signed 8 bit int to signed 16 bit int)
        ; ld      c, a
        ; add     a, a
        ; sbc     a, a
        ; ld      b, a

        ; ; ; without sign extension (not much faster)
        ; ; ld      c, a

        ; add     hl, bc                  ; BUG here: negative values in 8 bits cannot be coverted to 16 bits this way

        ; ld      a, (hl)


        ; or      a
        ; jr      nz, .is_wall        ; JR wont work here if destiny is over 127 bytes
        ; ;call    nz, .is_not_empty ; map cell contains enemy/object <--- IMPROVE THIS PART

        ; inc     de

    ; dec     ixl
    ; jp      nz, .loop

    ; ------------


    ; ; if wall not found, assume wall on last iteration
    ; dec     de ; must decrement DE or value will be above limit (0-19)

    ; if wall not found, render the smallest column
    ld      hl, Columns + (59 * 16)	
    jp      .drawColumn

    ; ; if wall not found, render black column
    ; ld      hl, BlackColumn
    ; jp      .drawColumn

.is_wall:

    ; ------- get distance and call DrawColumn with it

    ; number of tiles = DE - PreCalcData_BaseAddr - 2
    dec     de
    dec     de
    ex      de, hl      ; HL = DE
    ld      de, (PreCalcData_BaseAddr)
    xor     a
    sbc     hl, de


;  ld (TempWord_2), hl; debug
 
    ; addr of column data for this tile:
    ; addr = PreCalcData_BaseAddr + 22 + (tiles * 2)

    ld      a, l    ; HL = tiles * 2
    add     a, a
    ld      l, a

    ld      de, 22  ; HL += 22
    add     hl, de

    ld      de, (PreCalcData_BaseAddr)      ; HL += (PreCalcData_BaseAddr)
    add     hl, de

;  ld (TempWord_3), hl; debug

    ; DE = (HL)
    ld      e, (hl)
    inc     hl
    ld      d, (hl)

;  ld (TempWord_1), hl; debug

;     ; --------- Fix fisheye effect by multiplying by cos of angle (using fixed point 8.8 math)

;     ; DE contains the distance value (FP 8.8) [MUST COMMENT EX DE,HL ABOVE]

;     ; BC = cos (player.angle - currentAngle)
;     ld      a, (CurrentColumn)
;     add     a, a ; mult by 2 (each value is a word)
;     ld      h, 0
;     ld      l, a
;     ld      bc, CosTable32
;     add     hl, bc
;     ld      c, (hl)
;     inc     hl
;     ld      b, (hl)

; ld (TempWord_1), de; debug
; ld (TempWord_2), bc; debug


;     call    DE_Times_BC ; multiply DE by BC, result in DEHL

; ld (TempWord_3), de; debug

; ; jp $

;     ; get integer part, mult by 16 and add to Columns addr
;     ex      de, hl ; HL = DE
;     add     hl, hl
;     add     hl, hl
;     add     hl, hl
;     add     hl, hl
;     ld      de, Columns
;     add     hl, de

    ; --------- Fix fisheye effect by using a Look up table (original column height --> adjusted column height)
    ; this method uses two math roundings, leading to a big difference when very close to a perpendicular wall

    ex      de, hl        ; HL = DE

    ; now HL contains addr of the table for fixing fisheye effect, pointed first entry for this column height

    ; adjust to current screen column
    ; HL += CurrentColumn * 2
    ld      a, (CurrentColumn)
    add     a, a
    ld      e, a
    ld      d, 0
    add     hl, de


    ; set MegaROM page for FIX_FISHEYE_TABLE data
    ld      a, FIX_FISHEYE_TABLE_MEGAROM_PAGE
    ld	    (Seg_P8000_SW), a

    ; finally get the address of the ajusted colunn
    ; HL = (HL)
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl


.drawColumn:

    ; DrawColumn Inputs:
    ;   HL: ROM start addr of column strip (16 bytes)
    ;       Columns + (0 * 16) ; first column
    ;       Columns + (59 * 16) ; 59 = last column
    ;   DE: NAMTBL_buffer addr for this column

    ; ld      hl, Columns + (0 * 16) ; first column
    ; ld      hl, Columns + (59 * 16) ; 59 = last column
    push    hl
        ld      a, (CurrentColumn)
        ld      l, a
        ld      h, 0
        ld      de, NAMTBL_Buffer + 0
        add     hl, de
        ex      de, hl  ; DE = HL
    pop     hl
    call    DrawColumn

; jp $ ; debug

    ; --------------------------- go to next colunn

    ld      a, (CurrentColumn)
    cp      31
    jp      z, .return

    ; CurrentColumn ++
    inc     a
    ld      (CurrentColumn), a

    ; CurrentAngle += 2
    ld      hl, (CurrentAngle)
    inc     hl
    inc     hl

    ; if (angle == 360) angle = 0
    ld      de, 360
    rst     BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jr      z, .resetAngle
    jp      .dontResetAngle

.resetAngle:
    ld      hl, 0
.dontResetAngle:
    ld      (CurrentAngle), hl

    jp      .loopColumns

.return:

    ret