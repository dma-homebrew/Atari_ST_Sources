 ********************************************
 *             - D I G I T A L -            *
 *      - - --- ------ _ ------ --- - -     *
 *       _____ __  __ / \ _____ _____       *
 *      / ___// /_/ // . \\  _ \\  __\      *
 *     / /__ / __  //  _  \\ \\ \\__  \     *
 *    /____//_/ /_//__/ \__\\____\\____\    *      
 *    \    \\ \ \ \\  \ /  //    //    /    *
 *     \    \\ \ \ \\     //    //    /     *
 *     A Digital Chaos Production, 1994-5   *
**********************************************
* ---- Falcon DSP Operating System v1.1 ---- *
**********************************************
* Version 1.0 (March 1994) Steven Tattersall *
*   6 Derwent Drive, Littleborough, Lancs,   *
*  OL15 0BT, England. (Other credits below)  *
**********************************************
;  V1.2 - Fixed intermittent bug in sending OS program
;         immediately after reset
;  V1.3 - Potential fix for occasional crashes due to host interface
;         conflicts



; ------------------- MACROS ---------------------
os_wait_transmit	macro
		btst	#1,$ffffa202.w
		beq.s	*-6
		endm

os_wait_receive	macro
		btst	#0,$ffffa202.w
		beq.s	*-6
		endm



; ------------------- RESTART DSP ---------------------
	OPT	P+			;relocatable for easy INCBIN
Init_Dsp:
	BRA.W	Initialize
Send_Routine:
	BRA.W	Routine			;A0 = ADDRESS OF DATA
Run_Routine
	BRA	RRoutine		;A0 = ADDRESS OF ROUTINE IN DSP

; ------------------- RESTART DSP ---------------------
Initialize:
	MOVE.W	SR,-(A7)
	LEA	DspProg(PC),A0
	BSR	DspSendProg
	MOVE.W	(A7)+,SR
	RTS

; ------------------- SEND ROUTINE/DATA ---------------------
; A0 = address of routine

; FILE FORMAT:
; Byte	control: "X"/"Y"/"P"/null/-1
;	-1:   end
; else send 16bit address
;	null: next 16bit word address of where to jump
;	X/Y/P type of memory to access
;	      next 16bit word: address in memory
;	      next 16bit word: number of *words* to send
;                   then (words)*24bit words of data



Routine:
	MOVE.W	SR,-(A7)
	BSR	WaitReady
	LEA	$FFFFA200.W,A1
	 os_wait_transmit
	MOVE.L	#"ROU",4(A1)
.RoutineLoop:
	MOVE.L	#"ME ",D0
	MOVE.B	(A0)+,D0
	BMI.S	.RoutineFinished

	 os_wait_transmit
	MOVE.L	D0,4(A1)	; send command

	moveq	#0,d1
	MOVE.W	(A0)+,D1	; address data
	 os_wait_transmit
	MOVE.L	D1,4(A1)

	MOVE.W	(A0)+,D1	; number of words to send
	 os_wait_transmit
	MOVE.L	D1,4(A1)
	SUBQ.W	#1,D1
	BMI.S	.RoutineLoop
.SendData:
	subq.l	#1,a0
	 os_wait_transmit
	MOVE.L	(A0)+,4(A1)
	DBF	D1,.SendData
	BRA.S	.RoutineLoop

.RoutineFinished:
	 os_wait_transmit
	MOVE.L	#"END",$FFFFA204.W
	MOVE.W	(A7)+,SR
	RTS


RRoutine:
	MOVE.W	SR,-(A7)
	BSR	WaitReady
	LEA	$FFFFA200.W,A1
.RoutineLoop:
	 os_wait_transmit
	MOVE.L	#"RUN",4(A1)		;send command
	 os_wait_transmit
	MOVE.L	A0,4(A1)
	MOVE.W	(A7)+,SR
	RTS

DspSendProg:
;Reset the DSP for booting:
	MOVE.B	#$E,$FFFF8800.W		;PORT A
	MOVE.B	$FFFF8800.W,D0
	AND.B	#$EF,D0			;CLEAR BIT 4
	MOVE.B	D0,$FFFF8802.W
	BSR	DspWaitReset
	OR.B	#$10,D0
	MOVE.B	D0,$FFFF8802.W
	BSR	DspWaitReset
	AND.B	#$EF,D0			;CLEAR BIT 4
	MOVE.B	D0,$FFFF8802.W

	;CLR.B	$FFFFA200.W		;switch off host interrupts
	BRA	DspSendRawData

DspWaitReset:
	MOVE.W	#120,D1
.DspLittleWait:
	NOP
	NOP
	DBF	D1,.DspLittleWait
	RTS

; A0 = ADDRESS OF NO. OF *BYTES*, THEN RAW (UNPADDED) DATA:
; MUST BE *512 WORDS* THOUGH

DspSendRawData:
	MOVE.W	#512-1,D7
.SendToDsp1
	 os_wait_transmit
	MOVE.B	(A0)+,$FFFFA205.W
	MOVE.B	(A0)+,$FFFFA206.W
	MOVE.B	(A0)+,$FFFFA207.W
	DBF	D7,.SendToDsp1

.DspWaitReady
	BTST	#2,$FFFFA202.W
	BEQ.S	.DspWaitReady
.GetAgain
	 os_wait_receive
	MOVE.L	$FFFFA204.W,D0		;show track init done...
	CMP.W	#"K!",D0
	BNE.S	.GetAgain
	RTS

WaitTransmit
	BTST	#1,$FFFFA202.W
	BEQ.S	WaitTransmit
	RTS
WaitReceive
	BTST	#0,$FFFFA202.W
	BEQ.S	WaitReceive
	RTS
WaitReady
	BTST	#2,$FFFFA202.W
	BEQ.S	WaitReady
	RTS

	EVEN
DspProg:
	INCBIN	new_os3.dsb
	EVEN
DspEnd
	OPT	P-
