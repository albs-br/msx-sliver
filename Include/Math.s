;
; Divide 8-bit values
; In: Divide E by divider C
; Out: A = result, B = rest
;
Div8:
    xor a
    ld b,8
Div8_Loop:
    rl e
    rla
    sub c
    jr nc,Div8_NoAdd
    add a,c
Div8_NoAdd:
    djnz Div8_Loop
    ld b,a
    ld a,e
    rla
    cpl
    ret

;
; Divide 16-bit values (with 16-bit result)
; In: Divide BC by divider DE
; Out: BC = result, HL = rest
;
Div16:
    ld hl,0
    ld a,b
    ld b,8
Div16_Loop1:
    rla
    adc hl,hl
    sbc hl,de
    jr nc,Div16_NoAdd1
    add hl,de
Div16_NoAdd1:
    djnz Div16_Loop1
    rla
    cpl
    ld b,a
    ld a,c
    ld c,b
    ld b,8
Div16_Loop2:
    rla
    adc hl,hl
    sbc hl,de
    jr nc,Div16_NoAdd2
    add hl,de
Div16_NoAdd2:
    djnz Div16_Loop2
    rla
    cpl
    ld b,c
    ld c,a
    ret

;
; Multiply 8-bit values
; In:  Multiply H with E
; Out: HL = result
;
Mult8:
    ld d,0
    ld l,d
    ld b,8
Mult8_Loop:
    add hl,hl
    jr nc,Mult8_NoAdd
    add hl,de
Mult8_NoAdd:
    djnz Mult8_Loop
    ret


; DE divided by BC (both 8.8 fixed point), result in ADE (16.8)
FPDE_Div_BC88:
;Inputs:
;     DE,BC are 8.8 Fixed Point numbers
;Outputs:
;     ADE is the 16.8 Fixed Point result (rounded to the least significant bit)
    ;  di

    ; bug fix by Andre (sep 9th, 2024)
    ; if (DE == 0) ADE = 0;
    xor     a
    or      d
    or      e
    ret     z


     ld a,16
     ld hl,0
Loop1:
     sla e
     rl d
     adc hl,hl
     jr nc,$+8
     or a
     sbc hl,bc
     jp incE
     sbc hl,bc
     jr c,$+5
incE:
     inc e
     jr $+3
     add hl,bc
     dec a
     jr nz,Loop1
     ex af,af'
     ld a,8
Loop2:
     ex af,af'
     sla e
     rl d
     rla
     ex af,af'
     add hl,hl
     jr nc,$+8
     or a
     sbc hl,bc
     jp incE_2
     sbc hl,bc
     jr c,$+5
incE_2:
     inc e
     jr $+3
     add hl,bc
     dec a
     jr nz,Loop2
;round
     ex af,af'
     add hl,hl
     jr c,$+5
     sbc hl,de
     ret c
     inc e
     ret nz
     inc d
     ret nz
     inc a
     ret


; Shift right DE (divide by 2)
ShiftRight_DE:
    ex      de, hl
        srl     h
        rr      l
    ex      de, hl
    ret

; NOTE: this can be unrolled with quite a good gain of performance
DE_Times_BC:
;Inputs:
;     DE and BC are factors
;Outputs:
;     A is 0
;     BC is not changed
;     DEHL is the product
;
    ld hl,0
    ld a,16
Mul_Loop_1:
    add hl,hl
    ; rl e \ rl d      ; original
    rl     e
    rl     d
    jr nc,$+6
    add hl,bc
    jr nc,$+3
    inc de
    
    dec a
    jr nz,Mul_Loop_1
    ret