.segment "CHRGET"
RAMSTART1:
GENERIC_CHRGET:
        inc     TXTPTR
        bne     GENERIC_CHRGOT
        inc     TXTPTR+1
GENERIC_CHRGOT:                     
GENERIC_TXTPTR = GENERIC_CHRGOT + 1
        lda     $EA60
        cmp     #$3A
        bcs     CHRG_RTS     
GENERIC_CHRGOT2:
        cmp     #$20
        beq     GENERIC_CHRGET
        sec
        sbc     #$30
        sec
        sbc     #$D0
CHRG_RTS:
        rts
