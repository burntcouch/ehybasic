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
