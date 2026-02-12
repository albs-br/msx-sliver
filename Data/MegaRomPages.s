; ------- MegaROM Page 1
	org	0x8000, 0xBFFF

MAPS_MEGAROM_PAGE: equ 1

    INCLUDE "Data/Maps/Map_1.s"


LUT_MEGAROM_PAGE: equ 1

    INCLUDE "Data/LookUpTables/LUT_cos.s"
    INCLUDE "Data/LookUpTables/LUT_sin.s"
    INCLUDE "Data/LookUpTables/LUT_multiply.s"

FIX_FISHEYE_TABLE_MEGAROM_PAGE: equ 1
    INCLUDE "Data/FixFishEyeTable.s"

MegaROM_Page_1_size: equ $ - 0x8000     ; 0x2500

	ds PageSize - ($ - 0x8000), 255

; ----------------------------------------

; ------- MegaROM Pages from 2 to 181
PRECALC_DATA_FIRST_MEGAROM_PAGE: equ 2

    INCLUDE "Data/PreCalcData.s"
    INCLUDE "Data/PreCalcData_cont.s"
