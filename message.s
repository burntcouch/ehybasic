;
; global messages: "error", "in", "ready", "break"
;
;
;  PGS 2/13/26 - removed most conditionals for old machine versions
;
.segment "CODE"

QT_ERROR:
     .byte  " ERR"
     .byte  0
QT_IN:
     .byte   " IN "
     .byte  0
QT_OK:
		.byte   $0D,$0A,"OK",$0D,$0A
		.byte 	0
QT_BREAK:
		.byte   $0D,$0A,"BRK!"
    .byte   0

