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
        jsr USR
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
