.setcpu "65C02"
.debuginfo
.segment "DEBUG"

.ifdef HYDRA
.ifndef DEBUG
EX_VAR:
           rts
;
GODEBUG:
           rts
;
.else

EX_VAR:
         ; experimental functions
        jsr   FRMEVL      ; evaluate the expression in parens 'XV(<expr>)'
        bit   VALTYP 
   .ifdef DUMPFLG
        jsr     DUMPREG
   .endif        
        bmi   do_instr    ; if N bit set, its a string so to ahead
        jsr   FOUT         ; else it's a number?  convert it to a string
        jsr   STRLIT       ; so make it a #?
do_instr:
        jsr   FREFAC       ; ??? covert to string, len in X
   .ifdef DUMPFLG
        jsr     DUMPREG
   .endif 
        txa
        tay
        dey
        lda   TEMP1
        pha
        lda   (INDEX),y         ; get last char       
        sta   TEMP1
        tya
        tax    
        ldy     #0
XVLOOP: 
        lda     (INDEX),y
        cmp     TEMP1
        beq     XVEND
        iny
        dex
        bne     XVLOOP
        ldy     #$FF
XVEND:  pla
        sta     TEMP1
        iny
        jmp     SNGFLT

debug_varstr LINNUM
debug_varstr CURLIN
debug_varstr TXTPTR
debug_varstr MEMSIZ
debug_varstr FRESPC
debug_varstr FRETOP
debug_varstr ARG
debug_varstr ARGEXTENSION
debug_varstr FACEXTENSION
debug_varstr FAC
debug_varstr RESULT
debug_varstr TXTTAB
debug_varstr VARTAB
debug_varstr ARYTAB
debug_varstr STREND
debug_varstr TEMPST
debug_varstr INDEX
debug_varstr DEST
debug_varstr VARPNT

                   
GODEBUG:   ; print a bunch of stuff about BASIC internals   
        OUTDEBUGLN LINNUM, 2
        OUTDEBUGLN TXTPTR, 2
        OUTDEBUGLN MEMSIZ, 2
        OUTDEBUGLN FRESPC, 2
        OUTDEBUGLN FRETOP, 2
        OUTDEBUGLN ARG, 5
        OUTDEBUGLN ARGEXTENSION, 1
        OUTDEBUGLN FAC, 5
        OUTDEBUGLN FACEXTENSION, 1
        OUTDEBUGLN RESULT, 5
        OUTDEBUGLN TXTTAB, 2
        OUTDEBUGLN VARTAB, 2
        OUTDEBUGLN ARYTAB, 2 
        OUTDEBUGLN STREND, 2
        OUTDEBUGLN TEMPST, 9
        OUTDEBUGLN INDEX, 2
        OUTDEBUGLN DEST, 2
        OUTDEBUGLN VARPNT, 2
  .ifdef DUMPFLG
        jsr DUMPREG
  .endif
        rts  
;     
;
;   DUMP REGISTERS
;

DUMPTST:
          lda #$FF
          ldx #10
          ldy #0
          clc
TSTLOOP:  jsr   DUMPREG
          bcc   TSTNXT1
          clc
          bcc   TSTNXT2
TSTNXT1:  sec
TSTNXT2:  inc a
          iny
          dex
          bne   TSTLOOP
          rts

DUMPTXT1:
        .byte "SP/PC/nv-bdizc/A/X/Y -> "
        .byte 0

DUMPREG:       ; dump registers safely and print
        php                     ; -3
        pha                     ; -4
        phx                     ; -5
        phy                     ; -6
        ldy   #0
        lda   #$0D
        jsr   MONCOUT
        lda   #$0A
        jsr   MONCOUT
DUMPLP0:        
        lda   DUMPTXT1, y
        beq   DUMPCON
        jsr   MONCOUT
        iny
        bra   DUMPLP0
DUMPCON:
        tsx                     ; -6
        txa
        clc
        adc   #6
        jsr   WRITE_BYTE        ; print stack pointer b4 jump
        lda   #'/'
        jsr   MONCOUT 
        inx                     ; -5
        inx                     ; -4
        inx                     ; -3
        inx                     ; -2
        inx                     ; -1
        lda   $0100,x              ; get PC LSB
        tay 
        inx                     ; 0
        lda   $0100,x              ; get PC MSB
        jsr   WRITE_BYTE           
        tya
        jsr   WRITE_BYTE        
        lda   #'/'
        jsr   MONCOUT   
        ;   whew
        ;
        dex                      ; -1
        dex                      ; -2
        lda   $0100,x            ; get status byte
        ldy   #8
DUMPLP2:
        rol
        pha
        bcc   DUMPSKx            ; NV-BDIZC
        lda   #$31
        bra   DUMPSKy
DUMPSKx: 
        lda   #$30      
DUMPSKy:
        jsr   MONCOUT          ; print y-th bit
        pla
        dey   
        bne   DUMPLP2
        lda   #'/'
        jsr   MONCOUT
        dex                       ; -3
        lda   $0100,x 
        jsr   WRITE_BYTE           ; print A
        lda   #'/'
        jsr   MONCOUT
        dex                        ; -4
        lda   $0100,x 
        jsr   WRITE_BYTE           ; print X
        lda   #'/'
        jsr   MONCOUT
        dex                        ; -5
        lda   $0100,x 
        jsr   WRITE_BYTE           ; print Y
        lda   #$0D
        jsr   MONCOUT
        lda   #$0A
        jsr   MONCOUT
DREGLP1: 
        jsr   MONRDKEY              ; wait for a key
        bcc   DREGLP1
        cmp   #'s'                  ; print out stack?
        bne   DREGSK3
        jsr   DUMPSTACK
DREGSK3:
        cmp   #'z'                  ; print out zp?
        bne  DREGSK4
        jsr  DUMPZP
DREGSK4:        
        cmp   #'x'
        bne   DREGNXT
        jsr   WOZGO                ; go to Wozmon if necc
DREGNXT:
        ply     ; and restore everything
        plx
        pla
        plp
        rts    

DUMPSTACK:
        php
        pha
        ldy #0
        sty TEMP1
        lda #1
        sta TEMP1+1
        bra DSTKLP1
DUMPZP:
        php
        pha
        ldy #0
        sty TEMP1
        sty TEMP1+1   
DSTKLP1:
        tya
        jsr WRITE_BYTE
        lda #':'
        jsr MONCOUT
DSTKLP2:
        lda (TEMP1), y
        jsr WRITE_BYTE
        lda #$20
        jsr MONCOUT
        iny
        tya
        and #$0F       ; 00001111  
        beq  DSTKSKL   
        bra  DSTKLP2
DSTKSKL:
        lda #$0D
        jsr MONCOUT
        lda #$0A
        jsr MONCOUT
        tya
        bne DSTKLP1        
DUMPSTKEND:
        lda #$0D
        jsr MONCOUT
        lda #$0A
        jsr MONCOUT
        pla
        plp
        rts
        
.endif                ; DEBUG
.endif               ; HYDRA

          
;
;  include WOZMON
;
.include "wozmon_hy.s"
;
;