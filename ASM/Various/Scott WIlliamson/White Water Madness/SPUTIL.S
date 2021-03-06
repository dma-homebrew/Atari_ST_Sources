;------------------------------------------------------------------------------
;                FIND CHAR NUMBER UNDER SPRITE
;
; IN D0 LONGWORD CONTAINS SPRITE XCORD
;  A0 POINTS TO SPRITE PARM TABLE
; OUT D0 CONTAINS CHAR #
;------------------------------------------------------------------------------
;
FIND_CHAR:
 LEA MAP,A1 
 LSR.W #4,D0
 LSL.W #1,D0
 ADDA.W D0,A1
 MOVE.W YCORD(A0),D0
 AND.W #$FFF0,D0 ;*16
 MOVE.W D0,D1
 LSL.W #2,D0  ;*64
 ADD.W D1,D0  ;*16 + *64 = *80
 ADDA.L D0,A1
 MOVE.W (A1),D0
 RTS

;------------------------------------------------------------------------------
;                GET CHAR NUMBER UNDER SPRITE
;
; IN D0 LONGWORD CONTAINS SPRITE XCORD
;  D1 LONGWORD CONTAINS SPRITE YCORD
; OUT D0 CONTAINS CHAR #
;------------------------------------------------------------------------------
;
GET_CHAR:
 LEA MAP,A1 
 LSR.W #4,D0
 LSL.W #1,D0
 ADDA.W D0,A1
 AND.W #$FFF0,D1 ;*16
 MOVE.W D1,D2
 LSL.W #2,D1  ;*64
 ADD.W D2,D1  ;*16 + *64 = *80
 ADDA.L D1,A1
 MOVE.W (A1),D0
 RTS

;------------------------------------------------------------------------------
;  GENERATE RANDOM NUMBER - FAST RETURNED IN D0.L
;------------------------------------------------------------------------------
;
FRANDOM:
        MOVE.B  $FFFF8209,D0
        MOVE.B  $FFFF8207,D1
        EOR.B   D1,D0
        EORI.B  #%10011001,D0
        RTS

; MOVE.B $FFFF8209,D0 ;GET SCREEN POSITION
; LSL.W #08,D0  ;
; MOVE.B $FFFF8207,D0 ;
; SWAP D0  ;
; MOVE.B $FFFF8207,D0 ;GET SCREEN POSITION
; LSL.W #08,D0  ;
; MOVE.B $FFFF8209,D0 ;
; EORI.L #$87654321,D0 ;
; RTS

 END
 