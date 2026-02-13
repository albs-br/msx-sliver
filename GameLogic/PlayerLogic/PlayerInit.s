PlayerInit:

    
    ; ld      hl, 0 + (48*256)
    ; ld      (Player.X), hl
    
    ; ld      hl, 0 + (48*256)
    ; ld      (Player.Y), hl
    
    ; ld      hl, 44              ; only even numbers allowed
    ; ld      (Player.angle), hl

    ; --- test fisheye fix
    ld      hl, 3650
    ld      (Player.X), hl
    
    ld      hl, 15261
    ld      (Player.Y), hl
    
    ld      hl, 24              ; only even numbers allowed
    ld      (Player.angle), hl

    call    Player_Update_AllFields

    ret