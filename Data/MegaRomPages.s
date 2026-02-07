; ------- Page 1
	org	0x8000, 0xBFFF

MAPS_MEGAROM_PAGE: equ 1

    INCLUDE "Data/Maps/Map_1.s"


LUT_MEGAROM_PAGE: equ 1

    INCLUDE "Data/LookUpTables/LUT_cos.s"
    INCLUDE "Data/LookUpTables/LUT_sin.s"

	ds PageSize - ($ - 0x8000), 255

