; configuration
CONFIG_2A := 1

CONFIG_SCRTCH_ORDER := 2
CONFIG_PEEK_SAVE_LINNUM := 1     ; try this out?

; zero page
ZP_START0 = $00
ZP_START1 = $30
ZP_START2 = $3A
ZP_START3 = $72
ZP_START4 = $80

; extra/override ZP variables
USR := GORESTART

; constants
SPACE_FOR_GOSUB := $3E
STACK_TOP := $FA
WIDTH := 40
WIDTH2 := 30
RAMSTART2 := $0400
MONCOUT := $F8B6        ; will point to WRITE_CHAR in hydra bios
MONRDKEY := $F843       ; READ_CHAR
