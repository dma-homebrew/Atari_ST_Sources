
               TEXT

               INCLUDE       "LINEQU.L"
               INCLUDE       "INIT_TOS.L"
               INCLUDE       "MACROS.L"

               SETBLOCK

               DC.W          $A000

               move.l        #CONTROL,ticontrol(a0)
               move.l        #INTIN,tiintin(a0)
               move.l        #PTSIN,tiptsin(a0)
               move.l        #INTOUT,tiintout(a0)
               move.l        #PTSOUT,tiptsout(a0)


               PRINTLINE     SOURIS
               WAIT

               lea           INTIN,a6

               move          #0,6(a6)
               move          #1,8(a6)

               lea           DONNEES,a5

               move          #31,d0
               adda.l        #10,a6

BOUCLE         move          (a5)+,(a6)+

               dbf           d0,BOUCLE

               DC.W          $A00B

               move          #0,intin
               DC.W          $A009

               PRINTLINE     MESSAGE

               WAIT
               TERM


               DATA

SOURIS         DC.B          27,'E','Je change la forme du curseur de la'
               DC.B          ' souris ...',0

MESSAGE        DC.B          27,'E','Bougez la SOURIS SVP ...',7,0

 
DONNEES        DC.W          %0000001110000000
               DC.W          %0000011111000000
               DC.W          %0000111111100000
               DC.W          %0000111111100000
               DC.W          %0000111111100000
               DC.W          %0000111111100000
               DC.W          %0000111111100000
               DC.W          %0000111111100000
               DC.W          %0000111111100000
               DC.W          %0000111111100000
               DC.W          %0000011111000000
               DC.W          %0000001110000000
               DC.W          %0000011111000000
               DC.W          %0000111111100000
               DC.W          %0000011111000000
               DC.W          %0000001110000000

               DC.W          %0000000000000000
               DC.W          %0000001110000000
               DC.W          %0000011111000000
               DC.W          %0000011111000000
               DC.W          %0000011111000000
               DC.W          %0000011111000000
               DC.W          %0000011111000000
               DC.W          %0000011111000000
               DC.W          %0000011111000000
               DC.W          %0000011111000000
               DC.W          %0000001110000000
               DC.W          %0000000000000000
               DC.W          %0000001110000000
               DC.W          %0000011111000000
               DC.W          %0000001110000000
               DC.W          %0000000000000000


               BSS

               INCLUDE       "TABLEAU.L"

               END


 