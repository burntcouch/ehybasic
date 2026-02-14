; configuration
CONFIG_2A := 1

CONFIG_SCRTCH_ORDER := 2
CONFIG_PEEK_SAVE_LINNUM := 1     ; try this out?

; zero page
ZP_START0 = $00
ZP_START1 = $3C
ZP_START2 = $48            ; for 44 byte INPUTBUFFER
ZP_START3 = $7A
ZP_START4 = $86

; extra/override ZP variables
USR := GORESTART

; constants
SPACE_FOR_GOSUB := $3E
STACK_TOP := $FA
WIDTH := 44
WIDTH2 := 30
RAMSTART2 := $0400
MONCOUT := $F803       ; will point to WRITE_CHAR in hydra bios
MONRDKEY := $F800       ; READ_CHAR

; Hydra Entry points
; misc
;F928 CLEAR_SCR
;
; sound
;E433 YM_WRITE
;
; spi
;F9E8 SPI_INIT_DELAY
;F9CC SPI_RECV
;F9AD SPI_SEND
;F9A3 SPI_OPERATION_DONE
;F974 SPI_TRANSCEIVE
