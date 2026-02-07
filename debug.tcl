#ram_watch   add     0xc000      -type byte       -desc SavedJiffy             -format dec

ram_watch   add     0xe000      -type word       -desc P.X              -format dec
ram_watch   add     0xe002      -type word       -desc P.Y              -format dec

ram_watch   add     0xe001      -type byte       -desc P.map_X          -format dec
ram_watch   add     0xe003      -type byte       -desc P.map_Y          -format dec

ram_watch   add     0xe004      -type word       -desc P.angle          -format dec
ram_watch   add     0xe006      -type word       -desc P.FoV_start      -format dec
ram_watch   add     0xe008      -type word       -desc P.FoV_end        -format dec
ram_watch   add     0xe00a      -type word       -desc P.walk_X         -format dec
ram_watch   add     0xe00c      -type word       -desc P.walk_Y         -format dec
ram_watch   add     0xe00e      -type word       -desc P.mapCell        -format hex

#ram_watch   add     0xc108      -type word       -desc O_0.angle             -format dec
#ram_watch   add     0xc10a      -type byte       -desc O_0.isVis             -format dec
#ram_watch   add     0xc10b      -type byte       -desc O_0.posX_inside_FoV             -format dec
#ram_watch   add     0xc10c      -type byte       -desc O_0.quad             -format dec
#ram_watch   add     0xc10d      -type byte       -desc O_0.div_E            -format hex
#ram_watch   add     0xc10e      -type byte       -desc O_0.div_D            -format hex
#ram_watch   add     0xc10f      -type byte       -desc O_0.div_A            -format hex
