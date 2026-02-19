.feature force_range
.debuginfo +

.setcpu "6502"
.macpack longbranch

.include "defines.s"
.include "macros.s"     ; reviewed
.include "zeropage.s"

.include "header.s"     ; edited by PGS
.include "token.s"      ; edited by PGS
.include "error.s"      ; edited by PGS
.include "message.s"      ; edited by PGS
.include "memory.s"       ; reviewed
.include "program.s"      ; edited by PGS
.include "flow1.s"      ; edited by PGS
.include "loadsave.s"             ; not working on for now
.include "flow2.s"      ; edited by PGS
.include "misc1.s"      ; edited by PGS
.include "print.s"      ; edited by PGS
.include "input.s"      ; edited by PGS
.include "eval.s"      ; edited by PGS
.include "var.s"        ; reviewed
.include "array.s"      ; reviewed
.include "misc2.s"      ; edited by PGS
.include "string.s"      ; edited by PGS
;.include "misc3.s"     ; removed - KBD specific patches
.include "poke.s"       ; edited by PGS
.include "float.s"      ; edited by PGS
.include "chrget.s"      ; edited by PGS
.include "rnd.s"        ; edited by PGS
.include "trig.s"        ; edited by PGS
.include "init.s"      ; edited by PGS
.include "extra.s"      ; edited by PGS
