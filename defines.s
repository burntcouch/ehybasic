;
; defines.s
;
.if .def(hydra16)
HYDRA := 1
.include "defines_hydra.s"
.endif

.ifdef CONFIG_2C
CONFIG_2B := 1
.endif
.ifdef CONFIG_2B
CONFIG_2A := 1
.endif
.ifdef CONFIG_2A
CONFIG_2 := 1
.endif
.ifdef CONFIG_2
CONFIG_11A := 1
.endif
.ifdef CONFIG_11A
CONFIG_11 := 1
.endif
.ifdef CONFIG_11
CONFIG_10A := 1
.endif

.ifdef CONFIG_SMALL
BYTES_FP		:= 4
CONFIG_SMALL_ERROR := 1
.else
BYTES_FP		:= 5
.endif

.ifndef BYTES_PER_ELEMENT
BYTES_PER_ELEMENT := BYTES_FP
.endif
BYTES_PER_VARIABLE := BYTES_FP+2
MANTISSA_BYTES	:= BYTES_FP-1
BYTES_PER_FRAME := 2*BYTES_FP+8
FOR_STACK1		:= 2*BYTES_FP+5
FOR_STACK2		:= BYTES_FP+4

.ifndef MAX_EXPON
MAX_EXPON = 10
.endif

STACK           := $0100
.ifndef STACK2
STACK2          := STACK
.endif

; setup non ZP buffer
;
;INPUTBUFFER = $0300
.ifdef INPUTBUFFER
  .if INPUTBUFFER >= $0100
CONFIG_NO_INPUTBUFFER_ZP := 1
  .endif
  .if INPUTBUFFER = $0200
CONFIG_INPUTBUFFER_0200 := 1
  .endif
.endif
INPUTBUFFERX = INPUTBUFFER & $FF00

CRLF_1 := $0D
CRLF_2 := $0A




