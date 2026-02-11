.setcpu "65C02"
.debuginfo
;
;  basic hardware defines
;
ACIA            =  $FF10

ROCKWELL_ACIA   = 1
ACIA_USE_VIA_TIMER = 0
SER_SEND_STATUS_READY = 0
SER_SEND_STATUS_BUSY = 1
SER_SEND_STATUS_ERROR = $FF

ACIA_DATA       = $FF10
ACIA_STATUS     = $FF11
ACIA_CMD        = $FF12
ACIA_CTRL       = $FF13
;PORTA           = $6001    ; used for handled DTS/RTS signals 
;DDRA            = $6003    ;

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
INPUT_BUFFER:   .res $100
;
.segment "BIOS"
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
;  the meat of the thing
;
MONRDKEY:          
READ_CHAR:
SERIAL_READ:
                jsr             BUFFER_SIZE
                bne             @down
                clc
                rts
@down:
                phx
                ldx             ZP_READ_PTR
                lda             INPUT_BUFFER,X
                inc             ZP_READ_PTR
                plx
                jsr             WRITE_CHAR           ; echo
                sec
                rts
;
;
;
MONCOUT:
WRITE_CHAR:
SERIAL_WRITE:
                phx
WRITE_DELAY:
                ldx             ZP_SER_SEND_STATUS
                cpx             #SER_SEND_STATUS_READY
                beq             @do_write
                wai                                         ; Leave this in, even if RDY has a pull-up
                bra             WRITE_DELAY
@do_write:
                IO_PORT_WRITE   ACIA_R_DATA
                ldx             #SER_SEND_STATUS_BUSY
                stx             ZP_SER_SEND_STATUS
                plx
                rts
                
                
; Return (in A) the number of unread bytes in the circular input buffer as an unsigned byte
; Modifies: flags, A
BUFFER_SIZE:
                lda             ZP_WRITE_PTR
                sec
                sbc             ZP_READ_PTR
                rts
          