ram_watch   add     0xe000      -type word       -desc P.X              -format dec
ram_watch   add     0xe002      -type word       -desc P.Y              -format dec

ram_watch   add     0xe001      -type byte       -desc P.map_X          -format dec
ram_watch   add     0xe003      -type byte       -desc P.map_Y          -format dec

ram_watch   add     0xe004      -type word       -desc P.angle          -format dec
ram_watch   add     0xe006      -type word       -desc P.FoV_start      -format dec
ram_watch   add     0xe008      -type word       -desc P.FoV_end        -format dec
ram_watch   add     0xe00a      -type word       -desc P.walk_X         -format dec
ram_watch   add     0xe00c      -type word       -desc P.walk_Y         -format dec
ram_watch   add     0xe00e      -type word       -desc P.mapCellAddr    -format hex
ram_watch   add     0xe010      -type byte       -desc P.mapCellVal     -format dec
ram_watch   add     0xe011      -type byte       -desc P.x_inside_cell  -format dec
ram_watch   add     0xe012      -type byte       -desc P.y_inside_cell  -format dec

ram_watch   add     0xe200      -type byte       -desc P.PCD_Page       -format dec
ram_watch   add     0xe201      -type word       -desc P.PCD_Addr       -format hex

#ram_watch   add     0xe203      -type byte       -desc TmpByte_1        -format dec
ram_watch   add     0xe204      -type word       -desc TmpWord_1        -format dec
ram_watch   add     0xe206      -type word       -desc TmpWord_2        -format dec
