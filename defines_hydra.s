; configuration
;CONFIG_2A := 1

CONFIG_2B := 1                 ; bug fixes

CONFIG_SCRTCH_ORDER := 2
CONFIG_PEEK_SAVE_LINNUM := 1     ; try this out?

; zero page
ZP_START0 = $00
ZP_START1 = $3C
ZP_START2 = $44            
ZP_START3 = $7A
ZP_START4 = $86
;ZP_START3 = $52
;ZP_START4 = $62

; extra/override ZP variables
USRD := $0400
USR := $0410

DEBUG := 1

CLIPBOARD := $0500

RAMSTART2 := $0600

; constants
SPACE_FOR_GOSUB := $3E
STACK_TOP := $FA
WIDTH := 44
WIDTH2 := 30
MONCOUT := $F803       ; will point to WRITE_CHAR in hydra bios
MONRDKEY := $F800      ; READ_CHAR
WRITE_BYTE := $F8A3    ;  self exp
WOZMON := $FE00        ; Hydra OSROM WozMon entry
CLEAR_SCR := $F928     ; ANSI escape clear screen

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
