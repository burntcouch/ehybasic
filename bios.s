.setcpu "65C02"
.debuginfo

.zeropage
.org ZP_START0
    .res 15
ZP_READ_PTR:
    .res 1
ZP_WRITE_PTR:
    .res 1
ZP_SER_SEND_STATUS:
    .res 1   
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
        jsr USR                    ; do the thing at $0410
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
CLEARSCR:
        ;jsr CLEAR_SCR
        WRITE_SEQ #$1B, #$5B, #$32, #$4A, #$1B, #$5B, #$30,
        WRITE_SEQ #$3B, #$30, #$66, #$0D, #$0A
        rts
 
.ifdef DEBUG
   CLIPTXT:        .byte $0D, $0A
                   .byte "CLIPBOARD: "
                   .byte 0
   
   START_VARS:     .byte $0D, $0A
                   .byte "Start of variables: "
                   .byte 0
      
GODEBUG:   ; print a bunch of stuff about BASIC internals
        lda #<CLIPTXT
        ldy #>CLIPTXT
        jsr STROUT
        ldx CLIPBOARD
        ldy #0
CLIPNEXT:
        iny
        lda CLIPBOARD,y
        jsr MONCOUT
        dex
        beq  CLIPNEXT
        lda #<START_VARS
        ldy #>START_VARS
        jsr STROUT
        
        
        lda #$0D
        jsr MONCOUT
        lda #$0A
        jsr MONCOUT
        rts
.endif

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
;  include WOZMON
;
.include "wozmon_hy.s"
;
;
