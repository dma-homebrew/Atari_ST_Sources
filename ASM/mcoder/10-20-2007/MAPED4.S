	output	MAPED.tos
	opt	o+
;
; multi-moulineur de Maps :
;
;	+0) nouveau fichier
;	+1) d�termine les vignettes utilis�es 1 ou 2 fois
;	+2) d�termine les blocks �gaux
;	+3) d�termine la taille de la Map la plus petite
;	+4) saisit une map 8 bits
;	5) mixe 2 maps 8 bits en une 16 bits
;	6) mixe 2 maps 8 bits en une 16 bits optimis�e !!!
;
NBCOL= 80

GETKEY:	MACRO
	MOVE	#7,-(SP)
	TRAP	#1
	ADDQ	#2,SP
	ENDM
PRINT:	MACRO
	PEA	\1
	MOVE	#9,-(SP)
	TRAP	#1
	ADDQ	#6,SP
	ENDM
PUTC	MACRO
	MOVE	\1,-(SP)
	MOVE	#2,-(SP)
	TRAP	#1
	ADDQ	#4,SP
	ENDM
HEXA	MACRO
	MOVE	\1,D0
	LSR	#4,D0
	CMP	#10,D0
	BLO.S	.\@1
	ADDQ	#7,D0
.\@1	ADD	#'0',D0
	PUTC	D0
	MOVEQ	#$F,D0
	AND	\1,D0
	CMP	#10,D0
	BLO.S	.\@2
	ADDQ	#7,D0
.\@2	ADD	#'0',D0
	PUTC	D0
	ENDM
;
; message de bienvenue
;
	PRINT	WELLCOME(PC)
;
; saisie du nom du fichier � mouliner
;
NEWFILE:
	PRINT	inputname(pc)
	bsr	INPUT
	tst.b	(a0)
	beq	finished		;exit si CR

	PRINT	CR(pc)
;
; entrer type de moulinette
;
restart:
	PRINT	inputtype(pc)
	PUTC	<#'$'>
	HEXA	FIXX
	PUTC	<#','>
	PUTC	<#'$'>
	HEXA	FIXY
	PRINT	ENTRETYPE(PC)
.reget	GETKEY
	sub	#'0',d0
	cmp	#6,d0
	bhi.s	.reget
	move	d0,-(sp)
	add	#'0',d0
	PUTC	d0
	PRINT	CR(pc)
	move	(sp)+,d0
	add	d0,d0
	add	d0,d0
	jmp	mouline(pc,d0.w)
mouline:
	BRA.W	NEWFILE
	bra.w	MOULINEUR0
	bra.w	MOULINEUR1
	bra.w	MOULINEUR2
	bra.w	MOULINEUR3
	bra.w	MOULINEUR4
	bra.w	MOULINEUR5
;
ERREUR:
	PRINT	CR(pc)
	bra	restart
finished:
	CLR	-(SP)
	TRAP	#1
;
; RECHERCHE DES BLOCKS INUTILISES
;
MOULINEUR0:
	MOVE.L	#'.MAP',D0
	LEA	TAMPON,A5
	bsr	READFILE

	LEA	FREQ,A5
	MOVEQ	#0,D0
	MOVEQ	#256/4-1,D1
CLRFR:	MOVE.L	D0,(A5)+
	DBRA	D1,CLRFR

	LEA	TAMPON+2,A6
	MOVE	(A6)+,D7
	MULU	(A6)+,D7
	SUBQ	#1,D7

	LEA	TAMPON+128,A6
	LEA	FREQ,A5
	MOVEQ	#0,D0
BCL:
	MOVE.B	(A6)+,D0
	ADDQ.B	#1,(A5,D0.W)
	BNE.S	NOT0
	SUBQ.B	#1,(A5,D0.W)
NOT0:
	DBRA	D7,BCL

	PRINT	BARRE(PC)
	PRINT	MESS0(PC)
	MOVEQ	#0,D6
	BSR.S	GOT_IT

	PRINT	MESS1(PC)
	MOVEQ	#1,D6
	BSR.S	GOT_IT
	PRINT	BARRE(PC)
	bra	restart

GOT_IT:
	MOVEQ	#0,D5
	LEA	FREQ,A5
	MOVEQ	#0,D7
TST0:
	CMP.B	(A5)+,D6
	BNE.S	NO0

	MOVEQ	#$F,D0
	AND	D5,D0
	BNE.S	.NOT0
	CLR	D7
	PRINT	CR(PC)
.NOT0
	TST	D7
	BEQ.S	NOVIRG
	PUTC	<#','>
NOVIRG:
	HEXA	D5
	ADDQ	#1,D7
	CMP	#NBCOL/3,D7
	BLO.S	NO0
	CLR	D7
	PRINT	CR(PC)
NO0:
	ADDQ	#1,D5
	CMP	#256,D5
	BLO.S	TST0

	PRINT	CR(PC)
	RTS

	SECTION	DATA
MESS0:	DC.B	"VIGNETTES INUTILISEES :",13,10,0
MESS1:	DC.B	"VIGNETTES UTILISEES UNE FOIS :",13,10,0
	SECTION	BSS
	EVEN
FREQ:	DS.B	256

	SECTION	TEXT
;
; INDIQUE LES VIGNETTES DOUBLES
;
MOULINEUR1:
	MOVE.L	#'.BLK',D0
	LEA	TAMPON,A5
	BSR	READFILE
;
; a5=d�but fichier
; a6=fin fichier
;
	PRINT	BARRE(PC)
	PRINT	MESS2(PC)
	MOVEQ	#-1,D7		;VIGNETTE 0
	CLR	D5
	MOVEQ	#128/4-1,D0
.VER0	TST.L	-(A6)
	BNE	INTERNAL2
	DBRA	D0,.VER0
;	LEA	-128(A6),A6	;128 OCTETS A LA FIN !!!
NOCOMP:
	ADDQ	#1,D7
	LEA	128(A5),A5
	CMP.L	A6,A5
	BHS	FINI
	MOVE.L	A5,A4
	MOVE	D7,D6
COMP1:	LEA	128(A4),A4
	ADDQ	#1,D6
	CMP.L	A6,A4
	BHS.S	NOCOMP
	CMP	#256,D6		;BUG ???
	BHS	INTERNAL1

	MOVE.L	(A5),D2
	CMP.L	(A4),D2
	BNE.S	COMP1

	MOVEQ	#128/4-1,D2
	MOVE.L	A5,A1
	MOVE.L	A4,A2
COMP2:	CMPM.L	(A1)+,(A2)+
	BNE.S	COMP1
	DBRA	D2,COMP2
;
; PRINT D7 ET D6
;
	TST	D5
	BEQ.S	.NOVIRG
	PUTC	<#','>
.NOVIRG
	HEXA	D7
	PUTC	<#'='>
	HEXA	D6

	ADDQ	#1,D5
	CMP	#NBCOL/6,D5
	BLO.S	.NO0
	CLR	D5
	PRINT	CR(PC)
.NO0:
	BRA	COMP1
FINI:
	PRINT	CR(PC)
	PRINT	BARRE(PC)
	bra	restart

INTERNAL1:
	PRINT	INTERR1(PC)	;BLOCK > 256 ???
	BRA	ERREUR
INTERNAL2:
	PRINT	INTERR2(PC)	;DERNIER BLOCK NON NUL
	BRA	ERREUR

	SECTION	DATA
MESS2:	DC.B	"BLOCKS EN DOUBLE :",13,10,0
INTERR1:DC.B	"ERREUR INTERNE 1",0
INTERR2:DC.B	"ERREUR INTERNE 2",0

	SECTION	TEXT
;
; MOULINETTE DE MAPS
;
MOULINEUR2:
	MOVE.L	#'.MAP',D0
	LEA	TAMPON,A5
	BSR	READFILE
	MOVE.L	A5,A0
	BSR	REDUCE_MAP

	BRA	restart

MOULINEUR3:
	MOVE.L	#'.BLK',D0
	LEA	TAMPON,A5
	MOVE.L	A5,DEBBUF1
	BSR	READFILE
	MOVE.L	A6,A5
	MOVE.L	#'.MAP',D0
	MOVE.L	A5,DEBBUF2
	BSR	READFILE
	MOVE.L	A6,A5
	MOVE.L	A5,DEBBUF3
	MOVE.L	DEBBUF1,A6
	MOVE.L	DEBBUF2,A4

	CMP	#'01',(A6)
	BNE	ERREUR4
	CMP	#'01',(A4)
	BNE	ERREUR4
;
; A6=POINTEUR BLOCKS
; A4=POINTEUR MAP
;
; 1) REDUIT LA MAP
;
	MOVE.L	DEBBUF2,A0

	MOVE	FIXX,D0
	MOVE	FIXY,D1
	MOVE	D0,D2
	OR	D1,D2
	BNE.S	FIXIT
	BSR	REDUCE_MAP
FIXIT:
	MOVE	D0,(A5)+	;TAILLE DE LA MAP EN LARGEUR
	MOVE	D1,(A5)+	;TAILLE DE LA MAP EN HAUTEUR
	MOVE	D0,TAILLEX
	MOVE	D1,TAILLEY

	MOVE	62(A6),D0
	MULU	#128,D0

	MOVE	D0,(A5)+	;NB OCTETS DE MAP
	LSR	#2,D0
	SUBQ	#1,D0
	LEA	128(A6),A6
;
; 2) COPIE LES BLOCS
;
COPY1:	MOVE.L	(A6)+,(A5)+
	DBRA	D0,COPY1
;
; ON SAUTE LA DERNIERE VIGNETTE
;
	MOVEQ	#128/4-1,D0
TSTLAST:TST.L	(A6)+
	BNE.S	ERREUR4
	DBRA	D0,TSTLAST

	CMP.L	DEBBUF2,A6
	BNE.S	ERREUR4

	MOVE	2(A4),D6	;NB COLONNES
	MOVE	4(A4),D7	;NB LIGNES
	MOVE	TAILLEY,D7
	LEA	128(A4),A4

	MOVE.L	A4,A0

	MOVE	D6,D0
	MULU	D7,D0

	MOVE	D6,D1

	ADD.L	D0,A4

	SUBQ	#1,D7
	BMI.S	ERREUR4
	SUBQ	#1,D6
	BMI.S	ERREUR4
;
; 3) COPIE LA MAP
;
	MOVE	TAILLEY,D7
	SUBQ	#1,D7
COPYLIG:
	MOVE	TAILLEX,D0
	SUBQ	#1,D0
	SUB	D1,A4
	MOVE.L	A4,A1
COPY2:	MOVE.B	(A1)+,(A5)+
	DBRA	D0,COPY2
	DBRA	D7,COPYLIG

	CMP.L	A0,A4
	BNE.S	ERREUR4

	MOVE.L	DEBBUF3,A4	;A4=DEBUT
				;A5=FIN
	MOVE.L	#'.IMG',D0
	BSR	SAVEFILE
	BRA	restart

ERREUR4:
	PRINT	ERROR4(PC)
	BRA	ERREUR
;
; CALCULE LA TAILLE DE LA MAP
;
; ENTREE :
;	A0=POINTE SUR LE DEBUT DE LA MAP
; SORTIE :
;	D0=NB COL
;	D1=NB LIG
;
REDUCE_MAP:
	MOVE	2(A0),D6	;TAILLE EN X
	MOVE	4(A0),D7	;TAILLE EN Y
	MOVE	D6,D4
	MOVE	D7,D5
	LEA	128(A0),A1

	MOVE	D7,D0
	MULU	D6,D0
	MOVE.L	A1,A0
	ADD.L	D0,A0
LINE:
	MOVE	D6,D0
	SUBQ	#1,D0
TSTL:
	TST.B	-(A0)
	BNE.S	FINL
	DBRA	D0,TSTL
	SUBQ	#1,D5		;DECREMENTE NB LIGNES
	BNE.S	LINE
	BRA.S	ERREUR4
FINL:

ROW:
	MOVE.L	A1,A0
	ADD	D4,A0
	SUBQ	#1,A0
	MOVE	D5,D0
	SUBQ	#1,D0
TSTROW:
	TST.B	(A0)
	BNE.S	FINROW
	ADD	D6,A0
	DBRA	D0,TSTROW
	SUBQ	#1,D4
	BNE.S	ROW
	BRA.S	ERREUR4
FINROW:
	MOVE	D4,D0
	MOVE	D5,D1
	MOVE	D0,FIXX
	MOVE	D1,FIXY
	RTS
	section	data
	even
FIXX	DC.W	0
FIXY	DC.W	0
TAILLEX:DC.W	0
TAILLEY:DC.W	0
DEBBUF1:DC.L	0
DEBBUF2:DC.L	0
DEBBUF3:DC.L	0
ERROR4:	DC.B	"MOULINETTE CAN'T WORK",13,10,0

	SECTION	TEXT
;
; COLLEUR DE MAPS
;
; REGROUPE 2 MAPS 8 BITS DE MEME TAILLE EN 1 MAP 16 BITS
;
MOULINEUR4:
;
; saisie du nom du fichier � mouliner
;
.NEWFILE:
	PRINT	COLLAGE(PC)
	bsr	INPUT2
	tst.b	(a0)
	beq	restart		;exit si CR

	PRINT	CR(pc)

	MOVE.L	#'.IMG',D0
	LEA	TAMPON,A5
	MOVE.L	A5,DEBBUF1
	BSR	READFILE
	MOVE.L	A6,A5
	MOVE.L	A5,DEBBUF2
	LEA	filename2(PC),A6
	MOVE.L	#'.IMG',D0
	BSR	READFILE2
	MOVE.L	A6,A5
	MOVE.L	A5,DEBBUF3

	MOVE.L	DEBBUF1,A0
	MOVE.L	DEBBUF2,A1
	MOVE.L	DEBBUF3,A2

	MOVE	(A0)+,D0
	MOVE	D0,TAILLEX
	CMP	(A1)+,D0
	BNE	ERREUR5

	MOVE	(A0)+,D1
	MOVE	D1,TAILLEY
	CMP	(A1)+,D1
	BNE.S	ERREUR5

	MOVE	D0,(A2)+
	MOVE	D1,(A2)+

	SUB	#128,(A1)	;-1ere vignette

	MOVEQ	#0,D0
	MOVE	(A0),D0
	MOVEQ	#0,D1
	MOVE	(A1),D1
	ADD.L	D1,D0
	MOVE.L	D0,(A2)+

	MOVE	(A0)+,D0
	MOVE	D0,CORRECT
	SUBQ	#1,D0
.COPY1:
	MOVE.B	(A0)+,(A2)+
	DBRA	D0,.COPY1

	MOVE	(A1)+,D0
	LEA	128(A1),A1
	SUBQ	#1,D0
.COPY2:
	MOVE.B	(A1)+,(A2)+
	DBRA	D0,.COPY2

	MOVE	CORRECT,D7
	LSR	#7,D7
	SUBQ	#1,D7

	MOVE	TAILLEX,D0
	MULU	TAILLEY,D0
	SUBQ	#1,D0
	MOVE.L	A2,A3
MERGE1:
	CLR	D1
	MOVE.B	(A0)+,D1
	BNE.S	MERGE2
	MOVE.B	(A1),D1
	BEQ.S	MERGE2
	ADD	D7,D1
MERGE2:
	ASL	#7,D1
	ADDQ	#1,A1
	MOVE	D1,(A2)+
	DBRA	D0,MERGE1

	MOVE.L	DEBBUF3,A4	;DEBUT
	MOVE.L	A2,A5		;FIN
	MOVE.L	#'.BIN',D0
	BSR	SAVEFILE
	bra	restart
;
ERREUR5:
	PRINT	ERROR5(PC)
	BRA	ERREUR

	SECTION	DATA
	EVEN
CORRECT:DC.W	0
COLLAGE:DC.B	"Nom du fichier � coller : ",0
ERROR5:	DC.B	"MAPS DE TAILLES DIFFERENTES",13,10,0

	SECTION	TEXT
;
; OPTIMISEUR DE MAP 16 BITS
;
COMPTEUROPT:DC.W 0
MOULINEUR5:
	MOVE.L	#'.BIN',D0
	LEA	TAMPON,A5
	BSR	READFILE

	LEA	TAMPON,A5
	MOVE	(A5)+,TAILLEX
	MOVE	(A5)+,TAILLEY

	MOVE.L	(A5)+,A6
	ADD.L	A5,A6
	MOVE.L	A5,START
	MOVE.L	A6,ENDSEG

	MOVE	TAILLEX,D0
	MULU	TAILLEY,D0
	ADD.L	D0,D0
	ADD.L	A6,D0
	MOVE.L	D0,ENDVIG
	CLR	COMPTEUROPT
ITERE:
	MOVE.L	START,A5
	MOVE.L	ENDSEG,A6
	MOVEQ	#0,D0		;VIGNETTE 0
	BRA.S	.SEARCH
.NOCOMP:
	LEA	128(A5),A5
	ADDQ	#1,D0
.SEARCH:
	CMP.L	A6,A5
	BHS	.FINI
	MOVE.L	A5,A0
	MOVE	D0,D1
.COMP1:	LEA	128(A0),A0
	ADDQ	#1,D1
	CMP.L	A6,A0
	BHS.S	.NOCOMP

	MOVE.L	(A5),D2
	CMP.L	(A0),D2
	BNE.S	.COMP1

	MOVEQ	#128/4-1,D2
	MOVE.L	A5,A1
	MOVE.L	A0,A2
.COMP2:	CMPM.L	(A1)+,(A2)+
	BNE.S	.COMP1
	DBRA	D2,.COMP2
;
; D1=VIGNETTE A DEGAGER ET REMPLACER PAR D0
;
	MOVEM.L	D0-D7/A0-A6,-(SP)
	MOVE	D0,D6
	MOVE	D1,D7

	TST	COMPTEUROPT
	BEQ.S	.NOVIG
	PUTC	<#','>
.NOVIG
	HEXA	D6
	PUTC	<#'='>
	HEXA	D7
	ADDQ	#1,COMPTEUROPT
	CMP	#NBCOL/6,COMPTEUROPT
	BLO.S	.NOCR
	CLR	COMPTEUROPT
	PRINT	CR(PC)
.NOCR
	MOVEM.L	(SP)+,D0-D7/A0-A6

	LEA	128(A0),A1

	SUB.L	#128,TAMPON+4
	SUB.L	#128,ENDSEG
	SUB.L	#128,ENDVIG

	CMP.L	A6,A1
	BHS.S	.OKDEL
.DEL:
	MOVE.L	(A1)+,(A0)+
	CMP.L	A6,A1
	BLO.S	.DEL
.OKDEL:
	CMP.L	ENDSEG,A0
	BNE.S	INTERNAL3
;
; RENUMEROTATION DES VIGNETTES
;
	ASL	#7,D0
	ASL	#7,D1
	MOVE	TAILLEX,D3
	MULU	TAILLEY,D3
	SUBQ	#1,D3
.DEL2:	MOVE	(A1)+,D2
	CMP	D1,D2
	BLO.S	.GOODVIG
	BNE.S	.SUBIT
	MOVE	D0,D2
	BRA.S	.GOODVIG
.SUBIT:
	SUB	#128,D2
.GOODVIG:
	MOVE	D2,(A0)+	;TRANSFERE LES VIGNETTES 16 BITS
	DBRA	D3,.DEL2

	CMP.L	ENDVIG,A0
	BNE.S	INTERNAL4
;	PEA	MESS(PC)
;	MOVE	#9,-(SP)
;	TRAP	#1
;	ADDQ	#6,SP
	BRA	ITERE
.FINI:
	TST	COMPTEUROPT
	BEQ.S	.NOCR2
	PRINT	CR(PC)
.NOCR2
	LEA	TAMPON,A4
	MOVE.L	ENDVIG,A5
	MOVE.L	#'.BIN',D0
	BSR	SAVEFILE
	bra	restart
INTERNAL3:
	PRINT	INTERR3(PC)
	BRA	ERREUR
INTERNAL4:
	PRINT	INTERR4(PC)
	BRA	ERREUR

	SECTION	DATA
	EVEN
;TAILLEX:DC.W	0
;TAILLEY:DC.W	0
START:	DC.L	0
ENDSEG:	DC.L	0
ENDVIG:	DC.L	0
;MESS:	DC.B	"DESTRUCTION",13,10,0
INTERR3:DC.B	"INTERNAL ERROR 3",0
INTERR4:DC.B	"INTERNAL ERROR 4",0

;------------------------------------------------------------------------
;
;  ROUTINES UTILES
;
;------------------------------------------------------------------------

	section	text
;
; rajouter suffixe
;
SUFFIXE:
	move.l	a6,a0
.end	tst.b	(a0)+
	bne.s	.end

	subq	#5,a0
	move.b	(a0)+,d1
	asl	#8,d1
	move.b	(a0)+,d1
	swap	d1
	move.b	(a0)+,d1
	asl	#8,d1
	move.b	(a0)+,d1
	and.l	#$ffdfdfdf,d1
	cmp.l	D1,d0
	beq.s	okwrk
	CMP.L	#'.MAP',D1
	BEQ.S	.DEL
	CMP.L	#'.IMG',D1
	BEQ.S	.DEL
	CMP.L	#'.BIN',D1
	BEQ.S	.DEL
	CMP.L	#'.BLK',D1
	BNE.S	.NODEL
.DEL	SUBQ	#4,A0
.NODEL
	rol.l	#8,d0
	move.b	d0,(a0)+
	rol.l	#8,d0
	move.b	d0,(a0)+
	rol.l	#8,d0
	move.b	d0,(a0)+
	rol.l	#8,d0
	move.b	d0,(a0)+
	clr.b	(a0)+
okwrk:	rts

genhexa:
	move.b	#'$',(a5)+
	moveq	#8-1,d1
.hex1
	rol.l	#4,d0
	moveq	#15,d2
	and	d0,d2
	bne.s	.hex2
	dbra	d1,.hex1
	move.b	#'0',(a5)+
	rts
.hex4	rol.l	#4,d0
	moveq	#15,d2
	and	d0,d2
.hex2
	cmp	#10,d2
	blo.s	.hex3
	addq	#7,d2
.hex3	add	#'0',d2
	move.b	d2,(a5)+
	dbra	d1,.hex4
	rts

INPUT:
	PEA	filename-2(pc)
	move	#$a,-(sp)
	trap	#1
	addq	#6,sp
	lea	filename-1(pc),a0
	clr	d0
	move.b	(a0)+,d0
	clr.b	(a0,d0.w)
	rts
INPUT2:
	PEA	filename2-2(pc)
	move	#$a,-(sp)
	trap	#1
	addq	#6,sp
	lea	filename2-1(pc),a0
	clr	d0
	move.b	(a0)+,d0
	clr.b	(a0,d0.w)
	rts

DECIMAL:
	CLR	-(SP)
DECIM1:
	DIVU	#10,D7
	SWAP	D7
	ADD	#'0',D7
	MOVE	D7,-(SP)
	CLR	D7
	SWAP	D7
	TST.L	D7
	BNE.S	DECIM1
	MOVE	(SP)+,D7
DECIM2:	MOVE.B	D7,(A6)+
	MOVE	(SP)+,D7
	BNE.S	DECIM2
	RTS
;
; charge le fichier filename
;
; entr�e :
;	d0=suffixe
;	a5=d�but du fichier
; sortie :
;	a5=d�but du fichier
;	a6=fin du fichier
;
READFILE:
	lea	filename(pc),a6
READFILE2:
	BSR	SUFFIXE
	PRINT	MESS3(PC)	;LOADING FILE
	PRINT	(A6)
	PRINT	CR(PC)
	CLR	-(SP)		;OPEN LECTURE
	PEA	(A6)		;FILENAME
	MOVE	#$3D,-(SP)
	TRAP	#1
	ADDQ	#8,SP
	MOVE.L	D0,D7		;D7=HANDLE
	BMI.S	ERREUR1
	PEA	(A5)		;ADRESSE
	PEA	200000		;LONGUEUR
	MOVE	d7,-(SP)	;HANDLE
	MOVE	#$3F,-(SP)
	TRAP	#1
	LEA	12(SP),SP
	MOVE.L	D0,D6		;D6=NB BYTES
	BMI.s	ERREUR1
	move.l	a5,a6
	ADD.L	D6,A6
	MOVE	d7,-(SP)	;HANDLE
	MOVE	#$3E,-(SP)
	TRAP	#1
	ADDQ	#4,SP
	RTS
ERREUR1:
	PRINT	ERROR1(PC)
	BRA	ERREUR
	SECTION	DATA
MESS3:	DC.B	"LOADING FILE ",0
ERROR1:	DC.B	'FILE NOT FOUND...',0
	SECTION	TEXT
;
; A4=DEBUT
; A5=FIN
;
SAVEFILE:
	lea	filename(pc),a6
	BSR	SUFFIXE
	PRINT	MESS4(PC)		;SAVING FILE
	PRINT	(a6)
	PRINT	CR(PC)
	PEA	(a6)
	MOVE	#$41,-(SP)
	TRAP	#1
	ADDQ	#6,SP
	CLR	-(SP)
	PEA	(a6)
	MOVE	#$3C,-(SP)
	TRAP	#1
	ADDQ	#8,SP
	MOVE.L	D0,D7			;D7=HANDLE
	BMI.s	ERREUR2
	SUB.L	A4,A5
	PEA	(a4)		;ADRESSE
	PEA	(a5)		;LONGUEUR
	MOVE	d7,-(SP)	;HANDLE
	MOVE	#$40,-(SP)
	TRAP	#1
	LEA	12(SP),SP
	MOVE.L	D0,D6			;D6=NB BYTES
	BMI.s	ERREUR2
	MOVE	d7,-(SP)	;HANDLE
	MOVE	#$3E,-(SP)
	TRAP	#1
	ADDQ	#4,SP
	RTS
ERREUR2:
	PRINT	ERROR2(PC)
	BRA	ERREUR
	SECTION	DATA
MESS4:	dc.b	"SAVING FILE ",0
ERROR2:	DC.B	'ERROR DURING WRITING',0

;INTERR1:	DC.B	"ERREUR INTERNE 1",0

CR:	DC.B	13,13,10,0
BARRE:	DCB.B	NBCOL-1,"-"
	DC.B	13,10,0
WELLCOME:DC.B	27,"EMoulinette .BLK/.MAP version 1.0",13,10
	dc.b	10,10,0
inputname:dc.b	"Nom du fichier � mouliner (CR=quit):",13,10,0
inputtype:
	DC.B	"0->nouveau fichier",13,10
	dc.b	"1->affiche vignettes inutilis�es",13,10
	dc.b	"2->affiche bloc �gaux",13,10
	dc.b	"3->calcule taille Map",13,10
	dc.b	"4->saisie Map 8 bits",13,10
	dc.b	"5->collage de map 8 bits",13,10
	dc.b	"6->optimisation map 16 bits",13,10
	DC.B	"taille Map : "
	DC.B	0
ENTRETYPE:
	DC.B	13,10,"Quel type (0-9) : ",0

	EVEN
	dc.b	38,0
filename:
	ds.b	40
	dc.b	38,0
filename2:
	ds.b	40
	section	bss
	even
TAMPON:
