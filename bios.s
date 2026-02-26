.setcpu "65C02"
.debuginfo

;
;  macros for debugging stuff
;
.macro debug_varstr varble
.ident(.concat(.string(varble), "TXT")):
        .byte $0D, $0A
        .byte .concat(.string(varble), " : $")
        .byte 0
.endmacro

.macro OUTDEBUGLN varble, len
    .local Loop
        lda #<.ident(.concat(.string(varble), "TXT")) 
        ldy #>.ident(.concat(.string(varble), "TXT")) 
        jsr STROUT
        ldy #0
        ldx #len
   .if len > 0
Loop:    
        iny
        lda varble, y
        jsr WRITE_BYTE
        dex 
        bne Loop
   .endif   
.endmacro

;
;  some necc zero page stuff
;
.zeropage
.org ZP_START0
    .res 15
ZP_READ_PTR:
    .res 1
ZP_WRITE_PTR:
    .res 1
ZP_SER_SEND_STATUS:
    .res 1
ZP_SCRATCH:
    .res 2    
;
.segment "INPUT_BUFFER"
INPUT_BUFFER:   
    .res 256
;
.segment "BIOS"
BASEXIT:
        lda #>RESTART
        jsr WRITE_BYTE
        lda #<RESTART
        jsr WRITE_BYTE
        lda #$0D
        jsr MONCOUT
        lda #$0A
        jsr MONCOUT
        jmp WOZMON
USRGO:
        lda FAC
        sta USRD+8
        lda FAC+1
        sta USRD+9
        lda FAC+2
        sta USRD+10
        lda FAC+3
        sta USRD+11
        jsr USR                    ; do a thing at $0410?
        lda USRD
        sta RESULT
        lda USRD+1
        sta RESULT+1
        lda USRD+2
        sta RESULT+2
        lda USRD+3
        sta RESULT+3
        jmp COPY_RESULT_INTO_FAC
        rts
 ;
 ;  ANSI screen stuff
 ;
CLEARSCR:
        jsr GETBYT      ; # following 'CLS <val>', <val> ends up in X
        phx
        WRITE_SEQ #$1B, #$5B, #$32, #$4A, #$1B, #$5B, #$30   ; clear screen, set coords to 0,0
        WRITE_SEQ #$3B, #$30, #$66 
        jmp SCJMP
SETATTR:
        jsr GETBYT      ; # following 'ATT <val>', <val> ends up in X
        phx
SCJMP:
        WRITE_SEQ #$1B, #$5B   ; write 'ESC[<val>m'
        plx
        txa
        ldy #$FF
SC95:   iny
        sec
        sbc #10
        bcs SC95
        clc
        adc #$3A
        tax
        tya
        clc
        adc #$30
        jsr MONCOUT
        txa
        jsr MONCOUT
        lda #$6D        
        jsr MONCOUT
SCEND:  rts   

INST1:
         ; experimental functions
        jsr     GETSTR   ; returns length in y, string at INDEX
        dey
        lda     TEMP1
        pha
        lda     (INDEX),y         ; get last char
        sta     TEMP1
        tya
        tax    
        ldy     #0
I1LOOP: 
        lda     (INDEX),y
        cmp     TEMP1
        beq     I1END
        iny
        dex
        bne     I1LOOP
        ldy     #$FF
I1END:  pla
        sta     TEMP1
        iny
        jmp     SNGFLT
;
;
;
LOAD:
                rts
SAVE:
                rts
BEEP:
          rts
LCDINIT:
LCDCMD:
LCDPRINT:
          rts
          
;
