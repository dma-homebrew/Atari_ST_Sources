
               TEXT

               INCLUDE       "INIT_TOS.L"
               INCLUDE       "MACROS.L"
               INCLUDE       "MACROS_2.L"

               SETBLOCK

               PRINTLINE     EXEMPLE

               WAIT

               move.l        #$AFBEC,d0
               jsr           AFFICHEX
               move.l        #%111010101101,d0
               jsr           AFFICHBIN
               move.l        #5246,d0
               jsr           AFFICHEX
               move.l        #$ABCDEF,d0

               WAIT
               TERM

AFFICHEX       HEXA          d0
               CCONOUT       #13
               CCONOUT       #10

               rts

AFFICHBIN      BINAIRE       d0
               CCONOUT       #13
               CCONOUT       #10

               rts


               DATA

EXEMPLE        DC.B          27,'E','Voil� un exemple d',39,'utilisation'
               DC.B          ' des macros du fichier MACROS_2.L',13,10
               DC.B          'Regardez le listing de ce PRG ... (fichier'
               DC.B          ' EXEMPLE.L) :d0=',13,10,13,10,0

               BSS

               DS.B          100
PILE           DS.B          1

               END


 