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
    ; if (Player.angle == 0) Player.angle = 359; else Player.angle--;
    ld      hl, (Player.angle)
    ld      de, 0
    rst     BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jr      z, .rotateLeft_set359

    dec     hl
    jp      .rotate_return

.rotateLeft_set359:
    ld      hl, 359
    jp      .rotate_return



.rotateRight:
    ; if (Player.angle == 360) Player.angle = 0; else Player.angle++;
    ld      hl, (Player.angle)
    ld      de, 360-1
    rst     BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jr      z, .rotateRight_set0

    inc     hl
    jp      .rotate_return

.rotateRight_set0:
    ld      hl, 0

.rotate_return:
    ld      (Player.angle), hl


    ; call    Player_Update_FoV

    call    Player_Update_walkDXandDY

    ret

.walkForward:

    ; ---- Y += DY
    ld      hl, (Player.Y)
    ld      de, (Player.walk_DY)

    add     hl, de
    ld      (Player.Y), hl

    ; TODO: check map limits

    ; ---- X += DX
    ld      hl, (Player.X)
    ld      de, (Player.walk_DX)

    add     hl, de
    ld      (Player.X), hl

    call    Player_Update_MapCell

    ret

.walkBackwards:

    ; ---- Y -= DY
    ld      hl, (Player.Y)
    ld      de, (Player.walk_DY)

    xor     a ; clear carry
    sbc     hl, de
    ld      (Player.Y), hl

    ; TODO: check map limit

    ; ---- X -= DX
    ld      hl, (Player.X)
    ld      de, (Player.walk_DX)

    xor     a ; clear carry
    sbc     hl, de
    ld      (Player.X), hl

    call    Player_Update_MapCell

    ret
