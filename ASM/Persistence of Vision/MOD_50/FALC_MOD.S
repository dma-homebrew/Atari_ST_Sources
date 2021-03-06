*** Falcon 030 50Khz 16 bit multiplexed mod player
*** Ripped/fixed by MSD/POV  28/12/94

	text
begin
		lea	bssstart,a0
		move.l	#bssend-bssstart,d0
clear_bss	clr.b	(a0)+
		sub.l	#1,d0
		bne.s	clear_bss

		clr.l	-(sp)		;supervisor
		move.w	#$20,-(sp)
		trap	#1
		addq.w	#6,sp
		move.l	d0,-(sp)
		move.l	#$3919,d0
		movec	d0,cacr
		move.l	(sp)+,d0
		bsr	setsnd

		moveq	#0,d0		;mode:  set left attenuation
		move.w	#0,d1		;data:  0dB
		bsr	sound_command

		moveq	#1,d0		;mode:  set right attenuation
		move.w	#0,d1		;data:  0dB
		bsr	sound_command

		moveq	#2,d0		;mode:  set left gain
		move.w	#0,d1		;data:  0dB
		bsr	sound_command

		moveq	#3,d0		;mode:  set right gain
		move.w	#0,d1		;data:  0dB
		bsr	sound_command

		moveq	#4,d0		;mode:  set 16bit adder to input source
		move.w	#2,d1		;data:  set input from MATRIX
		bsr	sound_command

		moveq	#5,d0		;mode:  set left/right channels of ADC
		move.w	#0,d1		;data:  ?!
		bsr	sound_command

		moveq	#6,d0		;mode:  set prescale
		move.w	#3,d1		;data:  set to 50Khz
		bsr	sound_command

		moveq	#1,d0		;set playback to 16 bit stereo
		bsr	setmode

		moveq	#0,d0		;set no of playback/record tracks
		moveq	#0,d1
		bsr	settracks

;defines which playback track is audible through the internal speaker
		moveq	#0,d0
		bsr	setmontracks

		moveq	#0,d0
		moveq	#1,d1
		bsr	setinterrupt

		moveq	#0,d0
		moveq	#8,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#1,d4
		bsr	devconnect

		move.b	#$12,$fffffc02.w

		bsr	start_isr


		jsr	muson
		jsr	get_key
		jsr	musoff

exit		bsr	sndstatus
		move.l	d0,-(a7)
		move.l	#$3111,d0	* Activate Cache
		movec	d0,cacr
		move.l	(a7)+,d0
		move.b	#8,$fffffc02.w
		move.w	#$20,-(a7)
		trap	#1
		addq.w	#6,a7
		pea	$4c0000
		trap	#1

setsnd		move.w	#$80,-(sp)	;lock sound system so no other app can access it
		trap	#14
		addq.w	#2,sp

		move.w	#1,-(sp)	;reset sound system
		move.w	#$8c,-(sp)
		trap	#14
		addq.w	#4,sp
		rts

;sndstatus can be used to test the error condition of the sound system
;and to completely reset it.
sndstatus	move.w	#1,-(sp)	;1=reset sound system
		move.w	#$8c,-(sp)
		trap	#$e
		addq.w	#4,sp
;return value %111111
;              ||++++--------- error condition
;              ||              0=no error
;              ||              1=Invalid control field
;              ||              2=Invalid sync format
;              ||              3=Clock out of range
;              |+--------------if set left chan clipping has occurred
;              +---------------If set right chan clipping has occurred
		move.w	#$81,-(sp)
		trap	#$e
		addq.w	#2,sp
		rts

sound_command	move.w	d1,-(sp)	;data
		move.w	d0,-(sp)	;mode
		move.w	#$82,-(sp)
		trap	#14
		addq.w	#6,sp
		rts

setmode		move.w	d0,-(sp)	;set playback mode to 16 bit stereo
		move.w	#$84,-(sp)
		trap	#$e
		addq.w	#4,sp
		rts

settracks	move.w	d1,-(sp)	;rectracks
		move.w	d0,-(sp)	;playtracks (0-3)
		move.w	#$85,-(sp)	;sets no of play/records tracks
		trap	#$e
		addq.w	#6,sp
		rts

setmontracks	move.w	d0,-(sp)	;defines which playback track
		move.w	#$86,-(sp)	;is audible through the internal speaker
		trap	#$e
		addq.w	#4,sp
		rts

;defines the conditions under which an interrupt is generated by the sound system
setinterrupt	move.w	d1,-(sp)	;interrupt at end of play
		move.w	d0,-(sp)	;mode 0 = timera   mfp i7 interrupt
		move.w	#$87,-(sp)
		trap	#$e
		addq.w	#6,sp
		rts


devconnect	move.w	d4,-(sp)	;protocol  0=handshake  1=nohandshake
		move.w	d3,-(sp)	;prescale  0=TT030/STE compat
					;          1=50K (49170 Hz)
					;          2=33K (32880 Hz)
					;          3=25K (24585 Hz)
					;          4=20K (19668 Hz)
					;          5=16K (16390 Hz)
					;          7=12K (12292 Hz)
					;          9=10K (9834 Hz)
					;         11= 8K (8195 Hz)
		move.w	d2,-(sp)	;clock  0=internal 25.175 MHz  1=External  2=Internal 32 MHz
		move.w	d1,-(sp)	;dest  1=DMA record  2=DSP receive  3=External out  4=DAC (speaker)
		move.w	d0,-(sp)	;source  0=DMA playback  1=DSP xmit  2=External i/p  3=microphone/Yam PSG
		move.w	#$8b,-(sp)
		trap	#$e
		adda.w	#$c,sp
		rts


get_key
;	move.w	#$700,$ffff8240.w
;	move.w	#$25,-(sp)
;	trap	#14
;	addq.w	#2,sp
;	rept	6350
;	nop
;	endr
;	move.w	#$123,$ffff8240.w
	move.w	#11,-(sp)
	trap	#1
	addq.w	#2,sp
	tst.l	d0
	bmi.s	yes
	bra	get_key
yes
	move.w	#7,-(a7)
	trap	#1
	addq.w	#2,sp
	rts



start_isr	move	#$2700,sr
		move.l	$70.w,-(a7)
		move.b	$fffffa07.w,-(a7)
		move.b	$fffffa09.w,-(a7)
		move.b	$fffffa17.w,-(a7)
		clr.b	$fffffa07.w
		move.b	#$60,$fffffa09.w
		bclr	#3,$fffffa17.w
		move.l	#null_rte,$70.w
		move	#$2300,sr
		moveq	#-1,d0
		andi.w	#$ffff,d0
.wait		dbf	d0,.wait
		move	#$2700,sr
		move.b	(a7)+,$fffffa17.w
		move.b	(a7)+,$fffffa09.w
		move.b	(a7)+,$fffffa07.w
		move.l	(a7)+,$70.w
		move	#$2300,sr
		rts
null_rte	rte


muson		bsr	vol		; Calculate volume tables
		bsr	incrcal		; Calculate tonetables
		jsr	init
		jsr	prepare
		move	#$2700,sr
		bset	#5,$fffffa07.w
		bset	#5,$fffffa13.w
		clr.b	$fffffa19.w
		move.b	#1,$fffffa1f.w
		move.b	#8,$fffffa19.w
		move.l	$134.w,oldtimera
		move.l	#timera,$134.w

;set start/stop of internal play/record sound buffer
		move.l	#sample1+392,-(sp)	;end address
		move.l	#sample1,-(sp)	;begin address
		move.w	#0,-(sp)	;mode  0=play  1=record
		move.w	#$83,-(sp)
		trap	#$e
		adda.w	#$c,sp

;set/reads state of hardware sound system
		move.w	#3,-(sp)	;Enable DMA and LOOP play buffer
		move.w	#$88,-(sp)
		trap	#$e
		addq.w	#4,a7
		move	#$2300,sr
		rts

musoff	move	#$2700,sr
	clr.b	$fffffa19.w		;stop timers
	move.l	oldtimera(pc),$134.w
	bclr	#5,$fffffa07.w
	bclr	#5,$fffffa13.w
	clr.b	$ffff8901.w		;stop DMA
	move	#$2300,sr
	rts

timera		move	#$2500,sr
		bclr	#5,$fffffa0f.w
		movem.l	a0-a6/d0-d7,-(a7)
		move.l	samp1(pc),d0
		move.l	samp2(pc),samp1
		move.l	d0,samp2
		lea	$ffff8907.w,a0
		move.l	samp1(pc),d0
		move.b	d0,(a0)
		lsr.w	#8,d0
		move.l	d0,-5(a0)
		move.l	samp1(pc),d0
		move.l	#$188,d1
		add.l	d1,d1
		add.l	d1,d0
		move.b	d0,12(a0)
		lsr.w	#8,d0
		move.l	d0,7(a0)
		subq.w	#1,getnew_counter
		bpl.s	.nomus
		move.w	#4,getnew_counter
		bsr	music
.nomus		lea	itab(pc),a5
		lea	vtab(pc),a3
		moveq	#0,d0
		moveq	#0,d4

v1	movea.l	wiz2lc(pc),a0
	move.w	wiz2pos(pc),d0
	move.w	wiz2frc(pc),d1
	move.w	aud2per(pc),d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d2
	movea.w	2(a5,d7.w),a4
	move.w	aud2vol(pc),d7
	asl.w	#8,d7
	lea	0(a3,d7.w*2),a2

	movea.l	wiz3lc(pc),a1
	move.w	wiz3pos(pc),d4
	move.w	wiz3frc(pc),d5
	move.w	aud3per(pc),d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d6
	movea.w	2(a5,d7.w),a5

	move.w	aud3vol(pc),d7
	asl.w	#8,d7
	lea	(a3,d7.w*2),a3

	movea.l	samp1(pc),a6
	bsr	do_calc

	cmp.l	wiz2len(pc),d0
	blt.s	.ok2
	sub.w	wiz2rpt(pc),d0
.ok2	move.w	d0,wiz2pos
	move.w	d1,wiz2frc

	cmp.l	wiz3len(pc),d4
	blt.s	.ok3
	sub.w	wiz3rpt(pc),d4
.ok3	move.w	d4,wiz3pos
	move.w	d5,wiz3frc

	lea	itab(pc),a5
	lea	vtab(pc),a3
	moveq	#0,d0
	moveq	#0,d4
v2	movea.l	wiz1lc(pc),a0
	move.w	wiz1pos(pc),d0
	move.w	wiz1frc(pc),d1
	move.w	aud1per(pc),d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d2
	movea.w	2(a5,d7.w),a4

	move.w	aud1vol(pc),d7
	asl.w	#8,d7
	lea	(a3,d7.w*2),a2

	movea.l	wiz4lc(pc),a1
	move.w	wiz4pos(pc),d4
	move.w	wiz4frc(pc),d5
	move.w	aud4per(pc),d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d6
	movea.w	2(a5,d7.w),a5

	move.w	aud4vol(pc),d7
	asl.w	#8,d7
	lea	(a3,d7.w*2),a3

	movea.l	samp1(pc),a6
	subq.w	#2,a6
	bsr	do_calc

	cmp.l	wiz1len(pc),d0
	blt.s	.ok1
	sub.w	wiz1rpt(pc),d0
.ok1	move.w	d0,wiz1pos
	move.w	d1,wiz1frc

	cmp.l	wiz4len(pc),d4
	blt.s	.ok4
	sub.w	wiz4rpt(pc),d4
.ok4	move.w	d4,wiz4pos
	move.w	d5,wiz4frc
	movem.l	(a7)+,a0-a6/d0-d7
	rte

do_calc	swap	d0
	move.w	d5,d0
	swap	d0
	swap	d2
	move.w	a5,d2
	swap	d2
	move.w	#$1b,d3
	moveq	#0,d5
	move.l	d0,-(a7)
	move.l	#$1101,d0
	movec	d0,cacr
	move.l	(a7)+,d0
l34	move.b	0(a0,d0.w),d5
	move.w	(a2,d5.w*2),d7
	move.b	0(a1,d4.w),d5
	add.w	(a3,d5.w*2),d7
	addq.w	#2,a6
	add.w	a4,d1
	addx.l	d2,d0
	addx.w	d6,d4
	move.w	d7,(a6)+
	move.b	0(a0,d0.w),d5
	move.w	(a2,d5.w*2),d7
	move.b	0(a1,d4.w),d5
	add.w	(a3,d5.w*2),d7
	addq.w	#2,a6
	add.w	a4,d1
	addx.l	d2,d0
	addx.w	d6,d4
	move.w	d7,(a6)+
	move.b	0(a0,d0.w),d5
	move.w	(a2,d5.w*2),d7
	move.b	0(a1,d4.w),d5
	add.w	(a3,d5.w*2),d7
	addq.w	#2,a6
	add.w	a4,d1
	addx.l	d2,d0
	addx.w	d6,d4
	move.w	d7,(a6)+
	move.b	0(a0,d0.w),d5
	move.w	(a2,d5.w*2),d7
	move.b	0(a1,d4.w),d5
	add.w	(a3,d5.w*2),d7
	addq.w	#2,a6
	add.w	a4,d1
	addx.l	d2,d0
	addx.w	d6,d4
	move.w	d7,(a6)+
	move.b	0(a0,d0.w),d5
	move.w	(a2,d5.w*2),d7
	move.b	0(a1,d4.w),d5
	add.w	(a3,d5.w*2),d7
	addq.w	#2,a6
	add.w	a4,d1
	addx.l	d2,d0
	addx.w	d6,d4
	move.w	d7,(a6)+
	move.b	0(a0,d0.w),d5
	move.w	(a2,d5.w*2),d7
	move.b	0(a1,d4.w),d5
	add.w	(a3,d5.w*2),d7
	addq.w	#2,a6
	add.w	a4,d1
	addx.l	d2,d0
	addx.w	d6,d4
	move.w	d7,(a6)+
	move.b	0(a0,d0.w),d5
	move.w	(a2,d5.w*2),d7
	move.b	0(a1,d4.w),d5
	add.w	(a3,d5.w*2),d7
	addq.w	#2,a6
	add.w	a4,d1
	addx.l	d2,d0
	addx.w	d6,d4
	move.w	d7,(a6)+
	dbf	d3,l34
	move.l	d0,-(a7)
	move.l	#$3111,d0
	movec	d0,cacr
	move.l	(a7)+,d0
	swap	d0
	move.w	d0,d5
	clr.w	d0
	swap	d0
	swap	d2
	movea.w	d2,a5
	swap	d2
	rts

;-------------------------------------------- Hardware-registers & data --
wiz1lc		dc.l	sample1
wiz1len		dc.l	0
wiz1rpt		dc.w	0
wiz1pos		dc.w	0
wiz1frc		dc.w	0

wiz2lc		dc.l	sample1
wiz2len		dc.l	0
wiz2rpt		dc.w	0
wiz2pos		dc.w	0
wiz2frc		dc.w	0

wiz3lc		dc.l	sample1
wiz3len		dc.l	0
wiz3rpt		dc.w	0
wiz3pos		dc.w	0
wiz3frc		dc.w	0

wiz4lc		dc.l	sample1
wiz4len		dc.l	0
wiz4rpt		dc.w	0
wiz4pos		dc.w	0
wiz4frc		dc.w	0

aud1lc		dc.l	dummy
aud1len		dc.w	0
aud1per		dc.w	0
aud1vol		dc.w	0
		ds.w	3

aud2lc		dc.l	dummy
aud2len		dc.w	0
aud2per		dc.w	0
aud2vol		dc.w	0
		ds.w	3

aud3lc		dc.l	dummy
aud3len		dc.w	0
aud3per		dc.w	0
aud3vol		dc.w	0
		ds.w	3

aud4lc		dc.l	dummy
aud4len		dc.w	0
aud4per		dc.w	0
aud4vol		dc.w	0

dmactrl		dc.w	0

dummy		dc.l	0

samp1		dc.l	sample1
samp2		dc.l	sample2
;========================================================= EMULATOR END ==


;--------------------------------------------------------- Volume table --
vol	moveq	#0,d0
	moveq	#0,d4
	move.w	#255,d4
	move.w	#64,d0
	lea	mod,a0
.ploop	move.w	#255,d1
.mloop	move.w	d1,d2
	ext.l	d2
	subi.l	#$80,d2
	lsl.w	#6,d2
	move.w	d0,d3
	lsl.w	#2,d3
	muls	d3,d2
	divs	d4,d2
	move.w	d2,-(a0)
	dbf	d1,.mloop
	dbf	d0,.ploop
	rts


;------------------------------------------------------ Increment-table --
incrcal	lea	stab(pc),a0
	move.w	#$30,d1
	move.w	#$039F-$30,d0
	move.l	#$477cec,d2
recalc	swap	d2
	moveq	#0,d3
	move.w	d2,d3
	divu	d1,d3
	move.w	d3,d4
	swap	d4
	swap	d2
	move.w	d2,d3
	divu	d1,d3
	move.w	d3,d4
	move.l	d4,(a0)+
	addq.w	#1,d1
	dbf	d0,recalc
	rts

prepare		lea	workspc,a6

		movea.l	samplestarts(pc),a0
		movea.l	end_of_samples(pc),a1
tostack		move.b	-(a1),d0
		addi.b	#$80,d0
		move.b	d0,-(a6)
		cmpa.l	a0,a1		; Move all samples to stack (workspace)
		bgt.s	tostack

		lea	samplestarts(pc),a2
		lea	mod,a1
		movea.l	(a2),a0			; Start of samples
		movea.l	a0,a5			; Save samplestart in a5

		move.w	#31-1,d7
		subq.w	#1,d7
roop		move.l	a0,(a2)+	;sample position

		tst.w	42(a1)
		beq.s	samplok		; Len=0 -> no sample

		tst.w	46(a1)		; Test repstrt
		bne.s	repne		; Jump if not zero

repeq		move.w	42(a1),d0	;length of sample
		move.w	d0,d4
		subq.w	#1,d0

		movea.l	a0,a4
fromstk		move.w	(a6)+,(a0)+	; Move all samples back from stack
		dbf	d0,fromstk
		bra.s	rep

repne		move.w	46(a1),d0
		move.w	d0,d4
		subq.w	#1,d0
		movea.l	a6,a4
get1st		move.w	(a4)+,(a0)+	; Fetch first part
		dbf	d0,get1st
		adda.w	42(a1),a6
		adda.w	42(a1),a6

rep		movea.l	a0,a5
		moveq	#0,d1
toosmal		movea.l	a4,a3
		move.w	48(a1),d0
		subq.w	#1,d0
moverep		move.w	(a3)+,(a0)+	; Repeatsample
		addq.w	#2,d1
		dbf	d0,moverep

		cmp.w	#320,d1		; Must be > 320
		blt.s	toosmal

		move.w	#320/2-1,d2
last320		move.w	(a5)+,(a0)+	; Safety 320 bytes
		dbf	d2,last320

done		add.w	d4,d4

		move.w	d4,42(a1)	;length
		move.w	d1,48(a1)	;replen

		clr.w	46(a1)
samplok		lea	30(a1),a1
		dbf	d7,roop

		cmpa.l	#workspc,a0
		bgt.s	.nospac
		rts

.nospac		illegal
end_of_samples	dc.l	0

;------------------------------------------------------ Main replayrout --
init		lea	mod,a0
		lea	$3b8(a0),a1

		moveq	#$7f,d0
		moveq	#0,d1
loop		move.l	d1,d2
		subq.w	#1,d0
lop2		move.b	(a1)+,d1
		cmp.b	d2,d1
		bgt.s	loop
		dbf	d0,lop2
		addq.b	#1,d2

		lea	samplestarts(pc),a1
		asl.l	#8,d2
		asl.l	#2,d2
		add.l	#$43c,d2
		add.l	a0,d2
		movea.l	d2,a2

		move.w	#31-1,d0
lop3		clr.l	(a2)
		move.l	a2,(a1)+
		moveq	#0,d1
		move.w	42(a0),d1
		add.l	d1,d1
		adda.l	d1,a2
		adda.l	#$1e,a0
		dbf	d0,lop3
		move.l	a2,end_of_samples
		rts

music		lea	mod,a0
		addq.w	#1,counter
		move.w	counter(pc),d0
		cmp.w	speed(pc),d0
		blt.s	nonew
		clr.w	counter
		bra	getnew

nonew		lea	voice1(pc),a4
		lea	aud1lc(pc),a3
		bsr	checkcom
		lea	voice2(pc),a4
		lea	aud2lc(pc),a3
		bsr	checkcom
		lea	voice3(pc),a4
		lea	aud3lc(pc),a3
		bsr	checkcom
		lea	voice4(pc),a4
		lea	aud4lc(pc),a3
		bsr	checkcom
		bra	endr

arpeggio	moveq	#0,d0
		move.w	counter(pc),d0
		divs	#3,d0
		swap	d0
		tst.w	d0
		beq.s	arp2
		cmp.w	#2,d0
		beq.s	arp1
		moveq	#0,d0
		move.b	3(a4),d0
		lsr.b	#4,d0
		bra.s	arp3
arp1		moveq	#0,d0
		move.b	3(a4),d0
		andi.b	#$f,d0
		bra.s	arp3
arp2		move.w	16(a4),d2
		bra.s	arp4
arp3		add.w	d0,d0
		moveq	#0,d1
		move.w	16(a4),d1
		lea	periods(pc),a0
		moveq	#$24,d4
arploop		move.w	0(a0,d0.w),d2
		cmp.w	(a0),d1
		bge.s	arp4
		addq.l	#2,a0
		dbf	d4,arploop
		rts

arp4	move.w	d2,6(a3)
	rts

getnew		lea	mod+$43C,a0
		lea	-$43C+12(a0),a2
		lea	-$43C+$03B8(a0),a1

	moveq	#0,d0
	move.l	d0,d1
	move.b	songpos(pc),d0
	move.b	0(a1,d0.w),d1
	asl.l	#8,d1
	asl.l	#2,d1
	add.w	pattpos(pc),d1
	clr.w	dmacon

	lea	aud1lc(pc),a3
	lea	voice1(pc),a4
	bsr.s	playvoice
	lea	aud2lc(pc),a3
	lea	voice2(pc),a4
	bsr.s	playvoice
	lea	aud3lc(pc),a3
	lea	voice3(pc),a4
	bsr.s	playvoice
	lea	aud4lc(pc),a3
	lea	voice4(pc),a4
	bsr.s	playvoice
	bra	setdma

playvoice	move.l	0(a0,d1.l),(a4)
		addq.l	#4,d1
		moveq	#0,d2
		move.b	2(a4),d2
		andi.b	#$f0,d2
		lsr.b	#4,d2
		move.b	(a4),d0
		andi.b	#$f0,d0
		or.b	d0,d2
		tst.b	d2
		beq.s	setregs
		moveq	#0,d3
		lea	samplestarts(pc),a1
		move.l	d2,d4
		subq.l	#1,d2
		asl.l	#2,d2
		mulu	#$1e,d4
		move.l	0(a1,d2.l),4(a4)
		move.w	0(a2,d4.l),8(a4)
		move.w	2(a2,d4.l),18(a4)
		move.w	4(a2,d4.l),d3
		tst.w	d3
		beq.s	noloop
		move.l	4(a4),d2
		add.w	d3,d3
		add.l	d3,d2
		move.l	d2,10(a4)
		move.w	4(a2,d4.l),d0
		add.w	6(a2,d4.l),d0
		move.w	d0,8(a4)
		move.w	6(a2,d4.l),14(a4)
		move.w	18(a4),8(a3)
		bra.s	setregs
noloop		move.l	4(a4),d2
		add.l	d3,d2
		move.l	d2,10(a4)
		move.w	6(a2,d4.l),14(a4)
		move.w	18(a4),8(a3)
setregs		move.w	(a4),d0
		andi.w	#$fff,d0
		beq	checkcom2
		move.b	2(a4),d0
		andi.b	#$f,d0
		cmp.b	#3,d0
		bne.s	setperiod
		bsr	setmyport
		bra	checkcom2
setperiod	move.w	(a4),16(a4)
		andi.w	#$fff,16(a4)
		move.w	20(a4),d0
		move.w	d0,dmactrl
		clr.b	27(a4)
		move.l	4(a4),(a3)
		move.w	8(a4),4(a3)
		move.w	16(a4),d0
		andi.w	#$fff,d0
		move.w	d0,6(a3)
		move.w	20(a4),d0
		or.w	d0,dmacon
		bra	checkcom2

setdma		move.w	dmacon(pc),d0
		btst	#0,d0
		beq.s	wz_nch1
		move.l	aud1lc(pc),wiz1lc
		moveq	#0,d1
		moveq	#0,d2
		move.w	aud1len(pc),d1
		move.w	voice1+$0E(pc),d2
		add.l	d2,d1
		move.l	d1,wiz1len
		move.w	d2,wiz1rpt
		clr.w	wiz1pos
wz_nch1		btst	#1,d0
		beq.s	wz_nch2
		move.l	aud2lc(pc),wiz2lc
		moveq	#0,d1
		moveq	#0,d2
		move.w	aud2len(pc),d1
		move.w	voice2+$0E(pc),d2	;
		add.l	d2,d1
		move.l	d1,wiz2len
		move.w	d2,wiz2rpt
		clr.w	wiz2pos
wz_nch2		btst	#2,d0
		beq.s	wz_nch3
		move.l	aud3lc(pc),wiz3lc
		moveq	#0,d1
		moveq	#0,d2
		move.w	aud3len(pc),d1
		move.w	voice3+$0E(pc),d2	;
		add.l	d2,d1
		move.l	d1,wiz3len
		move.w	d2,wiz3rpt
		clr.w	wiz3pos

wz_nch3		btst	#3,d0
		beq.s	wz_nch4
		move.l	aud4lc(pc),wiz4lc
		moveq	#0,d1
		moveq	#0,d2
		move.w	aud4len(pc),d1
		move.w	voice4+$0E(pc),d2	;
		add.l	d2,d1
		move.l	d1,wiz4len
		move.w	d2,wiz4rpt
		clr.w	wiz4pos

wz_nch4		addi.w	#$10,pattpos
		cmpi.w	#$400,pattpos
		bne.s	endr
nex		clr.w	pattpos
		clr.b	break
		addq.b	#1,songpos
		andi.b	#$7f,songpos
		move.b	songpos(pc),d1
		lea	mod+$3b8,a4
		cmp.b	-2(a4),d1
		bne.s	endr
		moveq	#0,d1
		move.b	d1,songpos
endr		tst.b	break
		bne.s	nex
		rts

setmyport	move.w	(a4),d2
		andi.w	#$fff,d2
		move.w	d2,24(a4)
		move.w	16(a4),d0
		clr.b	22(a4)
		cmp.w	d0,d2
		beq.s	clrport
		bge.s	rt
		move.b	#1,22(a4)
		rts

clrport		clr.w	24(a4)
rt		rts

myport		move.b	3(a4),d0
		beq.s	myslide
		move.b	d0,23(a4)
		clr.b	3(a4)
myslide		tst.w	24(a4)
		beq.s	rt
		moveq	#0,d0
		move.b	23(a4),d0
		tst.b	22(a4)
		bne.s	mysub
		add.w	d0,16(a4)
		move.w	24(a4),d0
		cmp.w	16(a4),d0
		bgt.s	myok
		move.w	24(a4),16(a4)
		clr.w	24(a4)
myok		move.w	16(a4),6(a3)
		rts

mysub		sub.w	d0,16(a4)
		move.w	24(a4),d0
		cmp.w	16(a4),d0
		blt.s	myok
		move.w	24(a4),16(a4)
		clr.w	24(a4)
		move.w	16(a4),6(a3)
		rts

vib		move.b	3(a4),d0
		beq.s	vi
		move.b	d0,26(a4)
vi		move.b	27(a4),d0
		lea	sin(pc),a1
		lsr.w	#2,d0
		andi.w	#$1f,d0
		moveq	#0,d2
		move.b	0(a1,d0.w),d2
		move.b	26(a4),d0
		andi.w	#$f,d0
		mulu	d0,d2
		lsr.w	#6,d2
		move.w	16(a4),d0
		tst.b	27(a4)
		bmi.s	vibmin
		add.w	d2,d0
		bra.s	vib2
vibmin		sub.w	d2,d0
vib2		move.w	d0,6(a3)
		move.b	26(a4),d0
		lsr.w	#2,d0
		andi.w	#$3c,d0
		add.b	d0,27(a4)
		rts

nop		move.w	16(a4),6(a3)
		rts

checkcom	move.w	2(a4),d0
		andi.w	#$fff,d0
		beq.s	nop
		move.b	2(a4),d0
		andi.b	#$f,d0
		tst.b	d0
		beq	arpeggio
		cmp.b	#1,d0
		beq.s	portup
		cmp.b	#2,d0
		beq	portdown
		cmp.b	#3,d0
		beq	myport
		cmp.b	#4,d0
		beq	vib
		cmp.b	#5,d0
		beq	port_toneslide
		cmp.b	#6,d0
		beq	vib_toneslide
		move.w	16(a4),6(a3)
		cmp.b	#$a,d0
		beq.s	volslide
		rts

volslide	moveq	#0,d0
		move.b	3(a4),d0
		lsr.b	#4,d0
		tst.b	d0
		beq.s	voldown
		add.w	d0,18(a4)
		cmpi.w	#$40,18(a4)
		bmi.s	vol2
		move.w	#$40,18(a4)
vol2		move.w	18(a4),8(a3)
		rts

voldown		moveq	#0,d0
		move.b	3(a4),d0
		andi.b	#$f,d0
		sub.w	d0,18(a4)
		bpl.s	vol3
		clr.w	18(a4)
vol3		move.w	18(a4),8(a3)
		rts

portup		moveq	#0,d0
		move.b	3(a4),d0
		sub.w	d0,16(a4)
		move.w	16(a4),d0
		andi.w	#$fff,d0
		cmp.w	#$71,d0
		bpl.s	por2
		andi.w	#$f000,16(a4)
		ori.w	#$71,16(a4)
por2		move.w	16(a4),d0
		andi.w	#$fff,d0
		move.w	d0,6(a3)
		rts

port_toneslide	bsr	myslide
		bra.s	volslide

vib_toneslide	bsr	vi
		bra.s	volslide

portdown	clr.w	d0
		move.b	3(a4),d0
		add.w	d0,16(a4)
		move.w	16(a4),d0
		andi.w	#$fff,d0
		cmp.w	#$358,d0
		bmi.s	por3
		andi.w	#$f000,16(a4)
		ori.w	#$358,16(a4)
por3		move.w	16(a4),d0
		andi.w	#$fff,d0
		move.w	d0,6(a3)
		rts

checkcom2	move.b	2(a4),d0
		andi.b	#$f,d0
		cmp.b	#$d,d0
		beq.s	pattbreak
		cmp.b	#$b,d0
		beq.s	posjmp
		cmp.b	#$c,d0
		beq.s	setvol
		cmp.b	#$f,d0
		beq.s	setspeed
		rts

pattbreak	st	break
		rts

posjmp		move.b	3(a4),d0
		subq.b	#1,d0
		move.b	d0,songpos
		st	break
		rts

setvol		moveq	#0,d0
		move.b	3(a4),d0
		cmp.w	#$40,d0
		ble.s	vol4
		move.b	#$40,3(a4)
vol4		move.b	3(a4),9(a3)
		move.b	3(a4),19(a4)
		rts

setspeed	cmpi.b	#$1f,3(a4)
		ble.s	sets
		move.b	#$1f,3(a4)
sets		move.b	3(a4),d0
		beq.s	rts2
		move.w	d0,speed
		clr.w	counter
rts2		rts

	section data
sin	DC.B $00,$18,$31,$4A,$61,$78,$8D,$A1,$B4,$C5,$D4,$E0,$EB,$F4,$FA,$FD
	DC.B $FF,$FD,$FA,$F4,$EB,$E0,$D4,$C5,$B4,$A1,$8D,$78,$61,$4A,$31,$18

periods	DC.W $0358,$0328,$02FA,$02D0,$02A6,$0280,$025C,$023A,$021A,$01FC,$01E0
	DC.W $01C5,$01AC,$0194,$017D,$0168,$0153,$0140,$012E,$011D,$010D,$FE
	DC.W $F0,$E2,$D6,$CA,$BE,$B4,$AA,$A0,$97,$8F,$87
	DC.W $7F,$78,$71,$00,$00

speed		dc.w	6
counter		dc.w	0
songpos		dc.b	0
break		dc.b	0
pattpos		dc.w	0
dmacon		dc.w	0

voice1	ds.w	10
	dc.w	1
	ds.w	3

voice2	ds.w	10
	dc.w	2
	ds.w	3

voice3	ds.w	10
	dc.w	4
	ds.w	3

voice4	ds.w	10
	dc.w	8
	ds.w	3


bssstart
samplestarts	ds.l	31
getnew_counter	ds.w	1
oldtimera	ds.l	1
sample1		ds.b	784
sample2		ds.b	784
itab		ds.b	192
stab		ds.b	3520
vtab		ds.b	33280
bssend

mod	incbin	"f:\ripped\am.mod"

		ds.b	32768
workspc		ds.l	1

