* SOURCE CODE TO REMOVE BOTTOM BORDER, BY POWER MAN OF THE WILD BOYS *

* INTO SUPERVISOR MODE

	CLR.L -(A7)
	MOVE.W #32,-(A7)
	TRAP #1
	ADDQ.L #6,A7
	MOVE.L D0,STACK
	MOVE.L #MY,A7

* SAVE VECTORS AND OTHER SHIT

	LEA STORAGE,A0
	MOVE.L $70.W,(A0)+
	MOVE.L $120.W,(A0)+
	MOVE.B $FFFFFA1B.W,(A0)+
	MOVE.B $FFFFFA21.W,(A0)+
	MOVE.B $FFFFFA07.W,(A0)+
	MOVE.B $FFFFFA09.W,(A0)+
	MOVE.B $FFFFFA13.W,(A0)+
	ADDQ.L #1,A0			MAKE ADDRESS EVEN
	MOVE.W $FFFF8240.W,(A0)+
	MOVE.W $FFFF8242.W,(A0)+

	MOVE.W #2,-(A7)
	TRAP #14
	ADDQ.L #2,A7
	MOVE.L D0,PHYSIC

	MOVE.W #3,-(A7)
	TRAP #14
	ADDQ.L #2,A7
	MOVE.L D0,LOGIC

	MOVE.W #4,-(A7)
	TRAP #14
	ADDQ.L #2,A7
	MOVE.W D0,RES

* HIDE MOUSE

	DC.W $A000
	DC.W $A00A
	
* SET SCREEN ADDRESS, LOW RES

	CLR.W -(A7)			LOW RES
	PEA $70000			PHYSICAL SCREEN ADDRESS
	PEA $70000			LOGICAL SCREEN ADDRESS
	MOVE.W #5,-(A7)
	TRAP #14
	LEA 12(A7),A7

* FILL SCREEN WITH COLOUR 1 (VERTICAL LINE PATTERN)

	LEA $70000,A0
	MOVE.W #64000/8-1,D0		TWO SCREENS LENGTH
FILL	MOVE.L #$F0F00000,(A0)+
	MOVE.L #0,(A0)+
	DBF D0,FILL
	CLR.W $FFFF8240.W
	MOVE.W #$777,$FFFF8242.W
	
* SET UP NEW VECTORS

	MOVE.W #$2700,SR		STOP INTERRUPTS
	MOVE.L #VBL,$70.W		NEW VBL VECTOR
	MOVE.L #TIMER_B,$120.W		NEW TIMER B INTERRUPT HANDLER
	CLR.B $FFFFFA07.W		MFP RESET
	CLR.B $FFFFFA09.W
	ORI.B #1,$FFFFFA07.W		ENABLE TIMER B
	ORI.B #1,$FFFFFA13.W
	CLR.B $FFFFFA1B.W		STOP TIMER B
	MOVE.W #$2300,SR		ENABLE INTERRUPTS
WAIT	CMPI.B #57,$FFFFFC02.W		SPACE BAR?
	BNE WAIT
	
* RESTORE VECTORS AND SHIT

	MOVE.W #$2700,SR
	LEA STORAGE,A0
	MOVE.L (A0)+,$70.W
	MOVE.L (A0)+,$120.W
	MOVE.B (A0)+,$FFFFFA1B.W
	MOVE.B (A0)+,$FFFFFA21.W
	MOVE.B (A0)+,$FFFFFA07.W
	MOVE.B (A0)+,$FFFFFA09.W
	MOVE.B (A0)+,$FFFFFA13.W
	ADDQ.L #1,A0
	MOVE.W (A0)+,$FFFF8240.W
	MOVE.W (A0)+,$FFFF8242.W

* SHOW MOUSE

	DC.W $A000
	DC.W $A009
	MOVE.W #$2300,SR

* SET SCREEN ADDRESS, INTO USER MODE AND EXIT

	MOVE.W RES,-(A7)
	MOVE.L PHYSIC,-(A7)
	MOVE.L LOGIC,-(A7)
	MOVE.W #5,-(A7)
	TRAP #14
	LEA 12(A7),A7
		
	MOVE.L STACK,-(A7)
	MOVE.W #32,-(A7)
	TRAP #1
	ADDQ.L #6,A7
	CLR.L -(A7)
	TRAP #1

* VBL INTERRUPT HANDLER

VBL	CLR.B $FFFFFA1B.W		STOP TIMER B
	MOVE.B #199,$FFFFFA21		OCCUR ON LAST SCANLINE
	MOVE.B #8,$FFFFFA1B.W		START TIMER B
	RTE				PISS OFF

TIMER_B CLR.B $FFFFFA1B.W		STOP TIMER
	MOVEM.L D0/A0,-(A7)	
	MOVEA.W #$FA21,A0
	MOVE.B #200,(A0)
	MOVE.B #8,$FFFFFA1B.W		START TIMER
	MOVE.B (A0),D0
WAIT2	CMP.B (A0),D0			
	BEQ WAIT2
	CLR.B $FFFF820A.W		INTO 60 HZ
	MOVEQ.W #2,D0
LOOP1	NOP
	DBF D0,LOOP1
	MOVE.B #2,$FFFF820A.W		INTO 50 HZ
	MOVEM.L (A7)+,D0/A0
	BCLR #0,$FFFFFA0F.W		ACKNOWLEDGE
	RTE				BUGGER OFF
		
STORAGE	DS.B 18
	DS.L 63
MY	DS.L 1
RES	DS.W 1
LOGIC	DS.L 1
PHYSIC	DS.L 1
STACK	DS.L 1
		