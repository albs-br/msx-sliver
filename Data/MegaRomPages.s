; ------- Page 1
	org	0x8000, 0xBFFF

; LUT_MEGAROM_PAGE: equ 1

; MegaROM_Page_1:
;     INCLUDE "LookUpTables/LUT_Cos.s"
;     INCLUDE "LookUpTables/LUT_Sin.s"
;     INCLUDE "LookUpTables/LUT_Atan2.s"
;     INCLUDE "LookUpTables/LUT_PowerOf2.s"
;     INCLUDE "LookUpTables/LUT_SqRoot.s"
; MegaROM_Page_1_size:      equ $ - MegaROM_Page_1

	ds PageSize - ($ - 0x8000), 255

