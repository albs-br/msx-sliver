        ; ----- Tiles delta calc and test if is wall

        ; HL points to current player cell on map
        ; DE points to precalc squares touched data for current angle and player position inside cell

        ld      a, (de)
        ; TODO: maybe check for zero here 
        ; (trade off: improve when there is zeros on the end of tiles delta
        ; but worst performance for all cases (OR A, jr z, xxxx))

        ; sign extension (convert signed 8 bit int to signed 16 bit int)
        ld      c, a
        add     a, a
        sbc     a, a
        ld      b, a

        ; ; without sign extension (not much faster)
        ; ld      c, a

        add     hl, bc                  ; BUG here: negative values in 8 bits cannot be coverted to 16 bits this way

        ld      a, (hl)


        or      a
        ;jr      nz, .is_wall        ; JR wont work here if destiny is over 127 bytes
        jp      nz, .is_wall        ; JR wont work here if destiny is over 127 bytes
        ;call    nz, .is_not_empty ; map cell contains enemy/object <--- IMPROVE THIS PART

        inc     de