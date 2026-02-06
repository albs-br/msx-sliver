; ------- Page 1
	org	0x8000, 0xBFFF

MAPS_MEGAROM_PAGE: equ 1

    INCLUDE "Data/Maps/Map_1.s"

	ds PageSize - ($ - 0x8000), 255

