
          TEXT

          INCLUDE   "INIT_TOS.L"
          INCLUDE   "MACROS.L"

          SETBLOCK

          PRINTLINE DIR

          SEARCH    DTA,#0,PRG
          tst       d0
          bne       FIN
          PRINTLINE DTANOM
          CCONOUT   #13
          CCONOUT   #10


BOUCLE    move      #$4f,-(SP)
          trap      #1
          addq.l    #2,SP
          tst       d0
          bne       FIN
          PRINTLINE DTANOM
          CCONOUT   #13
          CCONOUT   #10
          jmp       BOUCLE

FIN       PRINTLINE FINI
          WAIT
          TERM

          DATA

PRG       DC.B      'A:\*.*',0
DIR       DC.B      27,'E','LE DIRECTORY DE CETTE DISQUETTE EST:',10,13,0
FINI      DC.B      13,10,7,'Voil� pour cette Disquette...',0

          BSS

          DS.B      2000
PILE      DS.B      1
          ALIGN.W            ;SPECIFIQUE � PROFIMAT !!!
DTA       DS.B      30
DTANOM    DS.B      14
ZERO      DS.B      1

          END


 