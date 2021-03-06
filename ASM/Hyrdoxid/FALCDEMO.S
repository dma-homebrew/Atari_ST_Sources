 	LEA.L 	PILE,SP
	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	CLR.B	$484.W
	MOVE.B	#18,$FFFFC02
	BSR	INITS
	BSR	CLS
	BSR	VBL
	BSR	CLR_REGISTERS
	BSR	AFF_GFX
*	BSR	AFF_PAL
	BSR	CLR_REGISTERS
	MOVE.W	#0,$FFFF8240
	MOVE.L	#$AAAA00AA,$FFFF9804
	MOVE.L	#$FFFF00FF,$FFFF9808
	MOVE.L	#$FFFF00FF,$FFFF980C
	

LOOP
*	CLR.L	$FFFF9800
*	MOVE.W	#$777,$FFFF8240
	MOVEM.L	A1-A2,-(SP)		; syncro ecran
	MOVE.L	AFFECR,A1
	MOVE.L	WORKECR,A2
	MOVE.L	A2,AFFECR
	MOVE.L	A1,WORKECR
	move.b affecr+1,$ffff8201.w
	move.b affecr+2,$ffff8203.w
	MOVEM.L	(SP)+,A1-A2
	CMPI.B	#56,$FFFFC02
	BNE.S	NO_ALT
	MOVE.L	#$FF,$FFFF9800
NO_ALT
	BSR	VBL
	CMPI.B	#57,$FFFFC02
	BNE	LOOP
	BRA	SORTIE
***************************INITIALISATIONS*********************************************************
INITS
*	MOVEC	CACR,D0			
*	MOVE.L	D0,OLD_CACR
*	MOVE.L	#$3111,D0		; cache on ... 
*	MOVEC	D0,CACR			

	MOVE.W	#2,-(SP)
	TRAP	#14
	ADDQ.L	#2,SP
	MOVE.L	D0,OLDXBIOS2
	
	MOVE.W	#-1,-(SP)		
	MOVE.W	#88,-(SP)		
	TRAP	#14			
	ADDQ.L	#4,SP			
	MOVE.W	D0,OLDMODECODE	

	MOVE.L	#SCREEN,D0	
	ADD.L	#10000,D0
	ANDI.L	#$FFFFFF00,D0
	MOVE.L	D0,SCREEN_ADD

;		  XXXXXXXFSOPV8NNN : flags pour rezs
 	MOVE.W	#%0000000001100011,-(SP)	
	MOVE.W	#3,-(SP)
	MOVE.L	SCREEN_ADD,-(SP)
	MOVE.L	SCREEN_ADD,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	14(SP),SP

	move	#50,$FFFF82A8.w		;OVER HAUT
	move	#611,$FFFF82AA.w	;BAS

 	move.l $44e.w,d0
	MOVE.L	d0,A1
	add.l	#108032,d0
	MOVE.L	d0,A2
	MOVE.L	A1,AFFECR
	MOVE.L	A2,WORKECR
	RTS

*******************************SOUS ROUTINES*****************************************
AFF_PAL
	MOVE.W	#7,D2
	MOVE.L	#$FFFF8240,A0
	LEA	GFX+32000,A1
PAL
	MOVE.L	(A1)+,(A0)+
	DBF	D2,PAL
	RTS
AFF_GFX
	LEA	GFX,A0
	MOVE.L	WORKECR,A1
	MOVE.L	AFFECR,A2
	MOVE.W	#7999,D1
AFF
	MOVE.L	(A0),(A1)+
	MOVE.L	(A0)+,(A2)+
	DBF	D1,AFF
	RTS
VBL:
	MOVE.L	D0,-(SP)
	move.l	$466.w,d0		
VSYNC:	cmp.l	$466.w,d0
	BEQ.S	VSYNC
	MOVE.L	(SP)+,D0
	RTS
CLS
	MOVEM.L	D0/A0-a1,-(SP)
	MOVE.L	AFFECR,A0
	move.l workecr,a1
	MOVEQ.L	#0,D1
	MOVE.W	#18269,D0
OK
	MOVE.L	D1,(A0)+
	MOVE.L	D1,(A1)+
	DBF	D0,OK
	MOVEM.L	(SP)+,D0/A0-a1
	RTS
CLR_REGISTERS
	movem.l	clr,d0-d6/a0-a6
	rts
SORTIE
	MOVE.B	#15,$484.W
	MOVE.B	#8,$FFFFC02
	MOVE.W	OLDMODECODE,-(SP)
	MOVE.W	#3,-(SP)	
	MOVE.L	OLDXBIOS2,-(SP)
	MOVE.L	OLDXBIOS2,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	14(SP),SP		
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#2,SP
	CLR.W	-(SP)
	TRAP	#1

	SECTION DATA
AFFECR:		DC.L 	0
WORKECR:		DC.L 	0
OLDXBIOS2:		DC.L	0
OLDMODECODE	DC.W	0
SCREEN_ADD		DC.L	0
GFX		INCBIN	"F:\BORDEL\LOGOVER3.PNT"
	SECTION	BSS
CLR		DS.L	17
		DS.L	2000
PILE		DS.L	10
SCREEN		DS.W	250000
	END
	 	  																																		  																																																														