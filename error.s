init_error_table

.ifdef CONFIG_SMALL_ERROR
define_error ERR_NOFOR, "NF"
define_error ERR_SYNTAX, "SN"
define_error ERR_NOGOSUB, "RG"
define_error ERR_NODATA, "OD"
define_error ERR_ILLQTY, "FC"
define_error ERR_OVERFLOW, "OV"
define_error ERR_MEMFULL, "OM"
define_error ERR_UNDEFSTAT, "US"
define_error ERR_BADSUBS, "BS"
define_error ERR_REDIMD, "DD"
define_error ERR_ZERODIV, "/0"
define_error ERR_ILLDIR, "ID"
define_error ERR_BADTYPE, "TM"
define_error ERR_STRLONG, "LS"
define_error ERR_FRMCPX, "ST"
define_error ERR_CANTCONT, "CN"
define_error ERR_UNDEFFN, "UF"
.else
define_error ERR_NOFOR, "NXT WO FOR"
define_error ERR_SYNTAX, "SYNTAX"
define_error ERR_NOGOSUB, "RTN WO JSR"
define_error ERR_NODATA, "OO DAT"
define_error ERR_ILLQTY, "ILLG QNT"
.ifdef CBM1
	.byte 0,0,0,0,0
.endif
define_error ERR_OVERFLOW, "OVFLW"
define_error ERR_MEMFULL, "OO MEM"
define_error ERR_UNDEFSTAT, "U'D STMT"
define_error ERR_BADSUBS, "! SBSCR"
define_error ERR_REDIMD, "R'D ARR"
define_error ERR_ZERODIV, "DIV/0"
define_error ERR_ILLDIR, "ILLG DIR"
define_error ERR_BADTYPE, "! TYP"
define_error ERR_STRLONG, "STR>LNG"
.ifdef CONFIG_FILE
  .ifdef CBM1
define_error ERR_BADDATA, "! DAT"
  .else
define_error ERR_BADDATA, "!F DAT"
  .endif
.endif
define_error ERR_FRMCPX, "FRML>CPLX"
define_error ERR_CANTCONT, "NO CONT"
define_error ERR_UNDEFFN, "U'D FUNC"
.endif