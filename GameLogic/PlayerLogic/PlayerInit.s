PlayerInit:

    ; place player on center of map
    ld      hl, 0 + (31*256)
    ld      (Player.X), hl
    
    ld      hl, 0 + (31*256)
    ld      (Player.Y), hl
    
    ld      hl, 45
    ld      (Player.angle), hl

    call    Player_Update_AllFields

    ret