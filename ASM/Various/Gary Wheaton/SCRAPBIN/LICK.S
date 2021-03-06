 CLR.L -(SP)       
 MOVE.W #$20,-(SP) ; Super.
 TRAP #1
 ADDQ.L #6,SP
 MOVE.L D0,SUPER   ; Save old status.


F EQU 2
P EQU 1792
R equ 2
J EQU 8
I EQU 4
H EQU 16
W EQU 1
X EQU 2
T EQU 4
Q EQU 8
Z EQU 2
U EQU 8
O EQU 2

SL EQU $FF8800
SD EQU $FF8802
 move.b #7,sl
 move.b #%11111000,sd


VBI movem.l d0-d5/a0-a2,-(sp)
;\\\\\\\\\\\\\
 MOVE.L UPTO,A2
 MOVE CUNT,D3
 MOVE.B 33(A2),D4
SSU SUBQ.W #1,D3
 BPL.S PART1
 MOVE.L #1,PNT0
 MOVE.L #1,PNT1
 MOVE.L #1,PNT2
 MOVE.L #1,PNT3
 MOVE.L #1,PNT4
 ADD.L #36,a2
 CMP.L #CHAN0,A2
 BNE.S LLA
 LEA DOTH,A2
LLA
 MOVE 34(A2),D3
 MOVE.B 33(A2),D4
PART1
 CLR.B D2
 BTST #1,D4
 BEQ.S W1
 MOVE.L (A2),A1
 MOVE.L 4(A2),A0
 BSR CHAN0
W1 BTST #2,D4
 BEQ.S W2
 MOVE.L 8(A2),A1
 MOVE.L 12(A2),A0
 BSR CHAN0
W2 MOVE.B #1,D2
 BTST #3,D4
 BEQ.S W3
 MOVE.L 16(A2),A1
 MOVE.L 20(A2),A0
 BSR CHAN0
W3 BTST #4,D4
 BEQ.S W4
 MOVE.L 24(A2),A1
 MOVE.L 28(A2),A0
 BSR CHAN0
W4 MOVE.L A2,UPTO
 MOVE D3,CUNT
;--END OF VBI
;--------EXIT
 movem.l (sp)+,d0-d5/a0-a2
 ;killer jmp $ffff

 move.b $469,d0
dd cmp.b $469,d0
 beq.s dd
 cmp.b #97,$fffc02
 bne vbi


	lea	$ff8800,a0	get sound chip 
	move.b	#7,(a0)
	move.b	#%11111111,2(a0) cut out lingering noise
	move.l #$8000000,$ff8800 
	move.l #$9000000,$ff8800 
	move.l #$a000000,$ff8800 

 MOVE.L SUPER,-(SP)
 MOVE.W #$20,-(SP)
 TRAP #1
 ADDQ.L #6,SP

 CLR -(SP)
 TRAP #1

SUPER DC.L 0


UPTO DC.L EE-36
CUNT DC.W 0
 EVEN
;\\RUNNING ORDER SEQUENCE
EE

DOTH

 DC.L PNT4,test
 DC.L PNT1,b2
 DC.L PNT2,b1 
 DC.L PNT3,DRMM
 DC.B 1,%0001110
 DC.W 147

 DC.L PNT4,null
 DC.L PNT1,null
 DC.L PNT2,null 
 DC.L PNT3,null
 DC.B 1,%0001110
 DC.W 255




CHAN0
;\\\\\\\\\\\\\\\\\\\\\\
 MOVE (A1),D0
 ADD D0,A0
 MOVE.L (A0),D1  ;GET NOTE 0 & DURATION
 MOVE.B 13(A1),D5
 EXT.W D5
 SWAP D1
 ADD D5,D1
 SWAP D1
 CMP #$FFFF,D1
 BNE CON2
 CLR (A1)        ;RESET TO START
 SUB D0,A0
 MOVE.L (A0),D1
CON2
 SUBQ.B #1,3(A1)    ;NP0
 BNE STILLON
 MOVE.L D1,6(A1) ;TMP0 \D1.W IS DURATION
 MOVE.L D1,20(A1);TEMP HOLD NOTE
 MOVE.B 26(A1),4(A1)  ;VOL0
 MOVE D1,2(A1)   ;NP0  \SET NEW DURATION
 ADDQ.W #4,(A1)     ;& INC POINTER
STILLON
;\\VOLUME
RFF
;\\\\\\\\\EFFECTS\\\\\\\\\\
NV0 MOVE.B 2(A1),D0
 CMP.B #4,D0
 BNE DOIT
 ADDQ.B #1,4(A1)
 RTS
DOIT TST.B D2
 BEQ FCC
 CMP.B #3,D0
 BNE DZZ
 BSR DRUM
 BRA.S FCC
DZZ
 MOVE.B #7,SL
 MOVE.B #%11111000,SD
 BRA.S FCC
EFCT
 DC.L FINK,VIB,WARB,DRUM,HOLD,WB1
 DC.L wrp,slw,SLR,HOLD,VIB
FCC
 AND.L #15,D0
 ASL #2,D0
 MOVE.L EFCT(PC,D0),A0
 JSR (A0)
MAZ CMP #2,20(A1)
 BNE.S DIP
 MOVE.B #35,4(A1)
DIP
 ADDQ.B #1,4(A1)          ;VOL0
 MOVE.B 11(A1),SL
 MOVE.B 21(A1),SD   ;TMP0+1
 MOVE.B 12(A1),SL
 MOVE.B 20(A1),SD   ;TMP0
 CLR D0
 MOVE.B 4(A1),D0
 MOVE.B 10(A1),SL
 MOVE.B 28(A1,D0),SD    ;VOL0
FINK RTS

 DC.B " (C) G.WHEATON.  45 GOLDRILL AVE BOLTON. LANCS, U.K. "
;-------EFFECTS ROUTINES--------
;1-256---DELAYED--VIBRATO-------
VV EOR.B #1,MC
 BEQ.S SDC
VIB CMP.B #8,4(A1)
 BLT SDC
 SUB.B #1,24(A1)
 BNE SDC
 MOVE.B 25(A1),24(A1)
 MOVE 16(A1),D1
 ADD D1,18(A1)
 MOVE 14(A1),D1
 CMP 18(A1),D1
 BLT.S RIST
KJ NEG D1
 CMP 18(A1),D1
 BGT.S RIST
SAZ MOVE 6(A1),D1
 ADD 18(A1),D1
 MOVE D1,20(A1)
SDC RTS
RIST NEG 16(A1)
 BRA.S SAZ
;2-512------WARB DW-----------
WARB
 EOR.B #1,MIN
 BEQ SAX
 SUBQ.B #1,4(A1)
SAX ASL 20(A1)
 CMP #560,20(A1)
 BLT.S PLOP
 MOVE 6(A1),20(A1)
PLOP RTS

;3--768--------DRUM-----------
DRUM SUBQ.B #4,19(A1)
 MOVE.B #7,SL
 MOVE.B #%11011000,SD
 MOVE.B #6,SL
 MOVE.B 19(A1),SD
 MOVE.B #5,SL
 MOVE.B 32(A2),SD
 MOVE.B #4,SL
 MOVE.B 19(A1),D0
 ASL.B #5,D0
 MOVE.B D0,SD
 RTS
;4 DRUM
;5--1280--WARB CONSTANT VOLUME
WB1 MOVE.B #5,4(A1)
 BRA.S SAX

;6--1536-----WARB UP---------
WRP 
SDX LSR 20(A1)
 CMP #27,20(A1)
 BGT PLAP
 MOVE 6(A1),20(A1)
PLAP BRA VV RTS 


;7--1792---SLIDE-UP--WARBLE
SLW CMP.B #7,4(A1)
 BLT.S WRP
 SUBQ.W #2,6(A1)
 BRA.S WRP

;8--2048---SLIDE UP VIB
SLR CMP.B #7,4(A1)
 BLT.S PES
 SUB.W #116,20(A1)
PES RTS

;9--2304-------HOLD----------
HOLD 
 move #30,4(A1)
 RTS


MC DC.B 1,1
MIN DC.B 1,0
;\\\\\\\\\\\\\\DATAS\\\\\\\\\\\\\\\
;\\NOTE 1ST WORD. DURATION 2ND WORD
;\\\LEAD
PNT0 DC.W 0
NP0 DC.W 1
 DC.W 0
 DC.L 0
 DC.B 10,4,5
 DC.B 0      ;ADD TO NOTE
 DC.W 6      ;VIB LIMIT
 DC.W 3      ;16(A1)  ADD
 DC.W 0      ;VIB 18(A1)
 DC.L 0      ;TMP NOTE 20(A1)
 DC.B 1,1    ;VIB RATE 24(A1)
 DC.B 0,0    ;INITIAL VOL
;ADSR  28(A1)
 DC.B 15,15,14,13,12,11,9,8,9
 DC.B 10,12,10,8,10,12,10,8,10,10
 DC.B 11,10,10,9,8,7,5,5,6,7,7
 DC.B 6,5,4,3,2,1 
 REPT 70
 DS.B 1
 ENDR

 EVEN
;\\\MIDDLE
PNT1 DC.W 0
 DC.W 1       ;EFFECT & DURATION 2(A1)
 DC.B 0,0
 DC.L 0
 DC.B 9,2,3
 DC.B 1       ;ADD  13(A1)
 DC.W 6       ;VIB LIMIT
 DC.W 2       ;VIB ADD 16(A1)
 DC.W 0       ;VIB 18(A1)
 DC.L 0       ;TEMP NOTE 20(A1)
 DC.B 1,1     ;VIB RATE  24)A1)
 DC.B 0,0     ;INITIAL VOL
;ADSR  28(A1)
 DC.B 15,15,9,13,12,15,14,13,12,12
 DC.B 11,11,11,11,10,10,10,10,10,10
 DC.B 12,12,11,11,10,9,8,7,9,7,10,7,11,10,10,9,10
 DC.B 9,8,7,6,5,4,3,2,1
 REPT 90
 DC.B 1
 ENDR

 EVEN
;\\\BASS
PNT2 DC.W 0
 DC.W 1          ;2(A1) DURATION
 DC.B 0,0        ;4(A1)
 DC.L 0          ;6
 DC.B 10,4,5     ;10(A1) VOL REG
 DC.B 2          ;ADD TO NOTE 13(A1)
 DC.W 6          ;VIB LIMIT
 DC.W 2          ;VIBRATO ADD 16(A1)
CC DC.W 2       ;VIB 18(A1)
 DC.L 0          ;TMP NOTE 20(A1)
 DC.B 2,2        ;VIB RATE
 DC.B 0,0        ;INITIAL VOL 26(A1)
;\ADSR  28(A1)
ADSR
 DC.B 15,15,14,14,14,13,13,13,13,13
 DC.B 13,13,12,12,11,11,10,10,10,9
 DC.B 8,7,6,5,4,3,4,2,1

 REPT 80
 DC.B 1
 ENDR

 EVEN
PNT3 DC.W 0
NP3 DC.W 1      ;2(A1) DURATION
 DC.B 0,0        ;4(A1)
 DC.L 0          ;6
 DC.B 10,6,11    ;10(A1) VOL REG
 DC.B -1         ;ADD  13(A1)
 DC.W 10         ;VIB LIMIT
 DC.W 4          ;VIBRATO ADD 16(A1)
 DC.W 0          ;VIB 18(A1)
 DC.L 0          ;TMP NOTE 20(A1)
 DC.B 1,1        ;VIB RATE
 DC.B 0,0        ;INITIAL VOL 26(A1)
;\ADSR  28(A1)
 DC.B 15,15,15,14,13,12
 DC.B 11,10,9,8,7,5,3,3
 DC.B 4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,15,15,15
 EVEN


PNT4 DC.W 0
NP4 DC.W 1      ;2(A1) DURATION
 DC.B 0,0        ;4(A1)
 DC.L 0
 DC.B 8,0,1      ;10(A1) VOL REG
 DC.B 0          ;ADD 13(A1)
 DC.W 115          ;VIB LIMIT
 DC.W 72          ;VIBRATO ADD 16(A1)
 DC.W 0          ;VIB 18(A1)
 DC.L 0          ;TMP NOTE 20(A1)
 DC.B 1,1        ;VIB RATE
 DC.B 0,0        ;INITIAL VOL 26(A1)
;\ADSR  28(A1)
 DC.B 15,15,15,14,13,12,12,13,14,15,15,15,14,13,12,12
 DC.B 13,14,15,15,15,14,13,12,12,13,13,13,13,13,13,13
 DC.B 12,11,11,10,10,11,11,12,12,11,11,10,10,9,9,10
 DC.B 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 DC.B 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 DC.B 8,8,8,9,9,9,10,10,10,10,10
 DC.B 11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11
 DC.B 12,13,14,15,14,13,12,11,10
 DC.B 12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12
 DS.B 20
 EVEN

;-----------MUSIC DATA

c=256
b1 
 dc.w 108*8,16+c
 dc.w 144*8,6+c
 dc.w 0,4+c
 dc.w 144*8,8+c
 dc.w 182*8,16+c
 dc.w 144*8,16+c
 dc.w 121*8,16+c
 dc.w 30,162
 DC.W $FFFF,$FFFF

b2
 dc.w 243*4,10*8+256,60,164


d=256
test 
 DC.W 108*T,8+d
 DC.W 121*T,8+d
 DC.W 128*T,8+d
 DC.W 144*T,8+d
 DC.W 162*T,8+d
 DC.W 182*T,8+d
 DC.W 193*T,8+d
 DC.W 217*T,8+d
 DC.W 243*T,16+d
 DC.W 30,164

 DC.W $FFFF,$FFFF


DRMM 
 DC.W 2,16+1024,4,8+768,2,8+1024
 DC.W 2,16+1024,16,4+768,2,12+1024

 DC.W $FFFF,$FFFF 


null dc.w 2,255+2304
 DC.W $FFFF,$FFFF 
