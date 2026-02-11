ReadInput:
    ; --- Read input
    ld      a, 8                    ; 8th line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    
    push    af
        bit     4, a                    ; 4th bit (left)
        call   	z, .rotateLeft
    pop     af

    push    af
        bit     7, a                    ; 7th bit (right)
        call   	z, .rotateRight
    pop     af

    push    af
        bit     5, a                    ; 5th bit (up)
        call   	z, .walkForward
    pop     af

    push    af
        bit     6, a                    ; 6th bit (down)
        call   	z, .walkBackwards
    pop     af


    ret


.rotateLeft:
    ; if (Player.angle == 0) Player.angle = 358; else Player.angle -= 2;
    ld      hl, (Player.angle)
    ld      de, 0
    rst     BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jr      z, .rotateLeft_set358

    dec     hl
    dec     hl
    jp      .rotate_return

.rotateLeft_set358:
    ld      hl, 358
    jp      .rotate_return



.rotateRight:
    ; if (Player.angle == 360) Player.angle = 0; else Player.angle += 2;
    ld      hl, (Player.angle)
    ld      de, 360-2
    rst     BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jr      z, .rotateRight_set0

    inc     hl
    inc     hl
    jp      .rotate_return

.rotateRight_set0:
    ld      hl, 0

.rotate_return:
    ld      (Player.angle), hl


    ; call    Player_Update_FoV

    call    Player_Update_WalkDXandDY


    ret

.walkForward:

    ; ---- Y += DY
    ld      hl, (Player.Y)
    ld      de, (Player.walk_DY)

    add     hl, de

    ; TODO: check if new cell is wall

    ld      (Player.Y), hl


    ; ---- X += DX
    ld      hl, (Player.X)
    ld      de, (Player.walk_DX)

    add     hl, de
    ld      (Player.X), hl

    jp      .walk_return


.walkBackwards:

    ; ---- Y -= DY
    ld      hl, (Player.Y)
    ld      de, (Player.walk_DY)

    xor     a ; clear carry
    sbc     hl, de

    ; TODO: check if new cell is wall

    ld      (Player.Y), hl

    ; ---- X -= DX
    ld      hl, (Player.X)
    ld      de, (Player.walk_DX)

    xor     a ; clear carry
    sbc     hl, de
    ld      (Player.X), hl

    ; jp      .walk_return

.walk_return:

    call    Player_Update_MapCell
    call    Player_Update_InsideCell

    ret
