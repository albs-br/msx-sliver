; Input:
;   HL: map address
LoadMap:

    ld	    a, MAPS_MEGAROM_PAGE
	ld	    (Seg_P8000_SW), a


    ld      de, Map
    ld      bc, MAP_WIDTH * MAP_HEIGHT
    ldir

    ret