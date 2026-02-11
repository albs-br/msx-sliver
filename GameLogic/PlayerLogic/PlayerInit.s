PlayerInit:

    
    ld      hl, 0 + (48*256)
    ld      (Player.X), hl
    
    ld      hl, 0 + (48*256)
    ld      (Player.Y), hl
    
    ld      hl, 44              ; only even number allowed
    ld      (Player.angle), hl

    call    Player_Update_AllFields

    ret