* Y-Schrumpfen von ganzen Bildschirmseiten
* Aufruf: yshrink(quelle,ziel,faktor,yoffset)
* <faktor>: neue H�he (1 bis 200), wenn negativ --> kopfstehend
* <offset> ist der Zeilenoffset
* offset <= 200-faktor

.text
.xdef _yshrink
_yshrink:               movem.l d0-d7/a0-a5,-(a7)
                        movea.l 60(a7),a0       *Quelle
                        movea.l 64(a7),a1       *Ziel
                        move.w  70(a7),d1       *Offset
                        muls    #160,d1         *Zeilenoffset berechnen
                        adda.l  d1,a1           *Neue Zieladresse
                        move.w  68(a7),d0       *Faktor
                        bmi.s   ysneg           *Negativ --> Kopfstehend

                        move.w  #100,d1         *Z�hler
                        move.w  #199,d2         *Z�hler f�r Zeilen

ysp_j1:                 add.w   d0,d1           *Z�hler erh�hen
                        cmp.w   #200,d1         *Z�hler >= 200 ?
                        blt.s   ysp_j3          *Nein --> Weiter

                        sub.w   #200,d1         *Z�hler == Z�hler - 200
                        move.w  #4,d3           *5*8 Langworte/Zeile

ysp_j2:                 movem.l (a0)+,d4-d7/a2-a5 *Laden
                        movem.l d4-d7/a2-a5,(a1)  *Zur�ckschreiben
                        adda.l  #32,a1            *Zeiger neu setzen
                        dbra    d3,ysp_j2         *In Schleife
                        bra.s   ysp_j4            *Weiter

ysp_j3:                 adda.l  #160,a0         *Quellz�hler erh�hen
ysp_j4:                 dbra    d2,ysp_j1       *Zur�ck in Schleife

                        movem.l (a7)+,d0-d7/a0-a5 *Zur�ckholen
                        rts

ysneg:                  neg.w   d0              *Betrag bilden
                        move.w  d0,d1           *Wert in d1
                        subq.w  #1,d1
                        muls    #160,d1         *zus�tzlicher Zeilenoffset
                        adda.l  d1,a1           *Zieladresse berechnen

                        move.w  #100,d1         *Z�hler
                        move.w  #199,d2         *Z�hler f�r Zeilen

ysn_j1:                 add.w   d0,d1           *Z�hler erh�hen
                        cmp.w   #200,d1         *Z�hler >= 200 ?
                        blt.s   ysn_j3          *Nein --> Weiter

                        sub.w   #200,d1         *Um 200 erniedrigen
                        move.w  #4,d3           *5*8 Langw�rter

ysn_j2:                 movem.l (a0)+,d4-d7/a2-a5 *Werte lesen
                        movem.l d4-d7/a2-a5,(a1)  *Werte schreiben
                        adda.l  #32,a1            *Zeilzeiger erh�hen
                        dbra    d3,ysn_j2         *Schleife
                        suba.l  #320,a1           *Zwei Zeilen zur�ck
                        bra.s   ysn_j4            *Weiter

ysn_j3:                 adda.l  #160,a0         *Quellzeiger erh�hen
ysn_j4:                 dbra    d2,ysn_j1       *Schleife

                        movem.l (a7)+,d0-d7/a0-a5
                        rts
