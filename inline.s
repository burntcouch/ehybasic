;
;  PGS 2/13/26 - removed most conditionals for old machine versions
;
;  inline.s
;
.segment "CODE"

; ----------------------------------------------------------------------------
; READ A LINE, AND STRIP OFF SIGN BITS
; ----------------------------------------------------------------------------

INLIN:
        ldx     #$00
INLIN2:
        jsr     GETLN
      ; eor     #$80      ; do we need this?  
        cmp     #$07
        beq     L2443
        cmp     #$0D
        beq     L2453
        cmp     #$7F
        beq     L2420
        cmp     #$20  ; screen out anything else below 32 decimal
        bcc     INLIN2
        cmp     #$7E ; ~ for cancel line?  (was $40, @)
        bne     L2443
        jsr     CRDO
        jmp     INLIN
        jmp     L2443
L2420:
        dex
        bpl     INLIN2
        jsr     CRDO 
        jmp     INLIN
L2443:
        cpx     #$47
        bcs     L244C
        sta     INPUTBUFFER,x
        sta     CLIPBOARD+1,x
        inx
        bne     INLIN2
L244C:
        lda     #$07 ; BEL
L244E:
        jsr     OUTDO
        bne     INLIN2
L2453:
        stx     CLIPBOARD           ; save last input line
        jmp     L29B9
GETLN:
        jsr     MONRDKEY
        cmp     #$0F
        bne     L2465
        pha
        lda     Z14
        eor     #$FF
        sta     Z14
        pla
L2465:
        rts

