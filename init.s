.segment "INIT"

; ----------------------------------------------------------------------------
;   hacked away from vanilla 'init.s' by PGS
;

QT_VERSION:
    .byte   $0D,$0A
    .byte   "77-v021626-1153"
    .byte   0
PR_WRITTEN_BY:
        lda     #<QT_VERSION
        ldy     #>QT_VERSION
        jsr     STROUT
COLD_START:
        ldx     #$FF
        stx     CURLIN+1
.ifdef CONFIG_NO_INPUTBUFFER_ZP
        ldx     #$FB
.endif
        txs
        lda     #<COLD_START
        ldy     #>COLD_START
        sta     GORESTART+1
        sty     GORESTART+2
        sta     GOSTROUT+1
        sty     GOSTROUT+2
        lda     #<AYINT
        ldy     #>AYINT
        sta     GOAYINT
        sty     GOAYINT+1
        lda     #<GIVAYF
        ldy     #>GIVAYF
        sta     GOGIVEAYF
        sty     GOGIVEAYF+1
        lda     #$4C
        sta     GORESTART
        sta     GOSTROUT
        sta     JMPADRS
            ;  do we do this for our USR
        sta     USR
        lda     #<IQERR
        ldy     #>IQERR
        sta     USR+1
        sty     USR+2
            ;  ...ya know?
        lda     #WIDTH
        sta     Z17
        lda     #WIDTH2
        sta     Z18
;
;  Ben Eater ran
;       jsr     LCDINIT 
;
;  ...here to init the LCD
; 
        
; All non-CONFIG_SMALL versions of BASIC have
; the same bug here: While the number of bytes
; to be copied is correct for CONFIG_SMALL,
; it is one byte short on non-CONFIG_SMALL:
; It seems the "ldx" value below has been
; hardcoded. So on these configurations,
; the last byte of GENERIC_RNDSEED, which
; is 5 bytes instead of 4, does not get copied -
; which is nothing major, because it is just
; the least significant 8 bits of the mantissa
; of the random number seed.
; KBD added three bytes to CHRGET and removed
; the random number seed, but only adjusted
; the number of bytes by adding 3 - this
; copies four bytes too many, which is no
; problem.
.ifdef CONFIG_SMALL
        ldx     #GENERIC_CHRGET_END-GENERIC_CHRGET
.else
        ldx     #GENERIC_CHRGET_END-GENERIC_CHRGET-1 ; XXX
.endif
L4098:
        lda     GENERIC_CHRGET-1,x
        sta     CHRGET-1,x
        dex
        bne     L4098
        lda     #$03
        sta     DSCLEN
        txa
        sta     SHIFTSIGNEXT
        sta     LASTPT+1
.if .defined(CONFIG_NULL) || .defined(CONFIG_PRINTNULLS)
        sta     Z15
.endif
        pha
        sta     Z14
        lda     #$03
        sta     DSCLEN
        jsr     CRDO
        ldx     #TEMPST
        stx     TEMPPT
        lda     #<QT_MEMORY_SIZE
        ldy     #>QT_MEMORY_SIZE
        jsr     STROUT
        jsr     NXIN
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
        cmp     #$41
        beq     PR_WRITTEN_BY
        tay
        bne     L40EE
        lda     #<RAMSTART2
        ldy     #>RAMSTART2
        sta     TXTTAB
        sty     TXTTAB+1
        sta     LINNUM
        sty     LINNUM+1
        ldy     #$00
L40D7:
        inc     LINNUM
        bne     L40DD
        inc     LINNUM+1
L40DD:
        lda     #$55 ; 01010101 / 10101010
        sta     (LINNUM),y
        cmp     (LINNUM),y
        bne     L40FA
        asl     a
        sta     (LINNUM),y
        cmp     (LINNUM),y
        bne     L40FA; new: slower
        beq     L40D7
L40EE:
        jsr     CHRGOT
        jsr     LINGET
        tay
        beq     L40FA
        jmp     SYNERR
L40FA:
        lda     LINNUM
        ldy     LINNUM+1
        sta     MEMSIZ
        sty     MEMSIZ+1
        sta     FRETOP
        sty     FRETOP+1
L4106:
        lda     #<QT_TERMINAL_WIDTH
        ldy     #>QT_TERMINAL_WIDTH
        jsr     STROUT
        jsr     NXIN
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
        tay
        beq     L4136
        jsr     LINGET
        lda     LINNUM+1
        bne     L4106
        lda     LINNUM
        cmp     #$10
        bcc     L4106
L2829:
        sta     Z17
L4129:
        sbc     #$0E
        bcs     L4129
        eor     #$FF
        sbc     #$0C
        clc
        adc     Z17
        sta     Z18
L4136:
        ldx     #<RAMSTART2
        ldy     #>RAMSTART2
        stx     TXTTAB
        sty     TXTTAB+1
        ldy     #$00
        tya
        sta     (TXTTAB),y
        inc     TXTTAB
        bne     L4192
        inc     TXTTAB+1
L4192:
.if CONFIG_SCRTCH_ORDER = 1
        jsr     SCRTCH
.endif
        lda     TXTTAB
        ldy     TXTTAB+1
        jsr     REASON
        jsr     CRDO
        lda     MEMSIZ
        sec
        sbc     TXTTAB
        tax
        lda     MEMSIZ+1
        sbc     TXTTAB+1
        jsr     LINPRT
        lda     #<QT_BYTES_FREE
        ldy     #>QT_BYTES_FREE
        jsr     STROUT
.if CONFIG_SCRTCH_ORDER = 2
        jsr     SCRTCH
.endif
        lda     #<STROUT
        ldy     #>STROUT
        sta     GOSTROUT+1
        sty     GOSTROUT+2
.if CONFIG_SCRTCH_ORDER = 3
         jsr     SCRTCH
.endif
        lda     #<RESTART
        ldy     #>RESTART
        sta     GORESTART+1
        sty     GORESTART+2
        jmp     (GORESTART+1)

QT_MEMORY_SIZE:
    .byte   "M:"
    .byte   0
QT_TERMINAL_WIDTH:
    .byte   "W:"
    .byte   0
QT_BYTES_FREE:
    .byte   " FREE"
    .byte   $0D,$0A
QT_BASIC:
    .byte   0


