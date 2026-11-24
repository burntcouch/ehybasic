;
;  so far all I get is a syntax error... supposed to return index of byte in string
;
XVGET:  jsr     GETSTR           ; returns length in y, string at INDEX
.ifdef DUMPFLG
        jsr     DUMPREG
.endif
        sty     USRD
        jsr     CHKCOM
.ifdef DUMPFLG
        jsr     DUMPREG
.endif        
        jmp     GETBYT           ; returns byte in x       
        
EX_VAR:     ; experimental functions
.ifdef DUMPFLG
        jsr     DUMPREG
.endif
        jsr     XVGET
.ifdef DUMPFLG
        jsr     DUMPREG
.endif        
        stx     USRD+1
XVSKIP:
        lda     USRD
        tax        
        ldy     #$FF
XVLOOP: 
        iny
        lda     (INDEX),y
        cmp     USRD+1
        beq     XVEND
        dex
        bne     XVLOOP
        ldy     #0
.ifdef DUMPFLG
        jsr     DUMPREG
.endif
XVEND:  jmp     SNGFLT

;;;

second try
EX_VAR:    jsr    DUMPREG
           jsr    FRMEVL      ; evaluate the expression following 'XV(<expr+char>)'
           bit    VALTYP      
           bmi    XVCONT      ; if N bit set, its a string so to ahead
           rts
XVCONT:
           jsr    FREFAC      ; ??? covert to string, len in X (A?)
           tay
           lda    (INDEX),y
           sta    USRD        ; where I always put things..last char of string
           tya
           tax                ; count down with X...
           dex                ; but only to next to last char
           ldy    #0          ; ...count up with Y.
XVloop:
           lda    (INDEX),y   ; I guess INDEX points at string?
           cmp    USRD
           bne    XVSKIP
           iny           
           bra    XVEND
XVSKIP:    iny
           dex
           bne    XVloop
           ldy    #0           ; return 0 if not there
XVEND:     jmp    SNGFLT
