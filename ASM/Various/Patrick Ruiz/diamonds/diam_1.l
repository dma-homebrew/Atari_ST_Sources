; DIAMONDS
; Version 1.00
; D�mo style "Jeu de la Vie" en Basse-r�solution.
; Remplit al�atoirement l'�cran puis affiche les g�n�rations.
; "Delete": R�initialise un nouvel �cran.
; "ESC"   : Fin du programme.

 ;SCRN_GRES
 move #4,-(SP)
 trap #14
 addq #2,SP
 cmpi #2,D0
 blo DEPART

FIN: ;PROG_END
 clr -(SP)
 trap #1

DEPART: move D0,res_orig
 ;SCRN_GPBASE
 move #2,-(SP)
 trap #14
 addq #2,SP
 move.l D0,ECR_N
 ;PROG_SUPER
 pea GETPALETTE
 move #38,-(SP)
 trap #14
 addq #6,SP
 ;efface le curseur CONS_OUT
ESC=27
 move #ESC,-(SP)
 move #2,-(SP)
 move #3,-(SP)
 trap #13
 move #"f",4(SP)
 trap #13
 addq #6,SP
 ;SCRN_SET
 move #0,-(SP)
 pea -1
 pea -1
 move #5,-(SP)
 trap #14
 adda #10,SP
 ;SCRN_SPALETTE
 pea palette
 move #6,-(SP)
 trap #14
 addq #6,SP
 ;initialiser ECR_M
 lea ECR_M+4+256,A0
 move.l A0,D0
 andi.l #$3FFF00,D0
 move.l D0,ECR_M
DIAMONDS:
 ;~~~ ---> TAB
 tst.b N_M
 beq \N
 lea TAB_N,A3
 bra \suite
\N lea TAB_M,A3
\suite movea.l A3,A4
 adda #322+1,A3
 move #320/2-1,D3 ;col.
 move #200-1,D4 ;lign.
 move #$F0F,D5 ;masque
\hz move #17,-(SP)
 trap #14
 addq #2,SP
 lsr.l #7,D0 ;allons savoir
 and D5,D0
 move D0,(A3)+
 dbra D3,\hz
 move #320/2-1,D3
 addq #2,A3
 dbra D4,\hz
;lign. -1 et 200
 movea.l A4,A3
 addq #1,A3
 move.l #200*322,D0
 move #320-1,D3
\L_1 move.b (A3,D0.L),(A3)+
 dbra D3,\L_1
 movea.l A4,A3
 adda.l #201*322+1,A3
 move #320-1,D3
 neg.l D0
\L200 move.b (A3,D0.L),(A3)+
 dbra D3,\L200
 ;col. -1 et 320
 movea.l A4,A3
 adda #322,A3
 move #200-1,D4
\C_1 move.b 320(A3),(A3)
 adda #322,A3
 dbra D4,\C_1
 movea.l A4,A3
 adda #322+320+1,A3
 move #200-1,D4
\C320 move.b -320(A3),(A3)
 adda #322,A3
 dbra D4,\C320
 bra remp
gen: ; CRISTAL 
 tst.b N_M
 beq \N
 lea TAB_M,A0
 lea TAB_N,A1
 bra \suite
\N lea TAB_N,A0
 lea TAB_M,A1
\suite:         ;A0=TAB srce
                ;A1=TAB dest
 movea.l A0,A2
 adda #322+1,A2 ;A2=ptr srce
 movea.l A1,A3
 adda #322+1,A3 ;A3=ptr dest
 move #320-1,D0 ;D0=col.
 move #200-1,D1 ;D1=lign.
 moveq #-  1,D2 ;D2=offset G
 moveq #   1,D3 ;D3=offset D
 movea # 322,A4 ;A4=offset H
 movea #-322,A5 ;A5=offset B
\np move.b (A2)+,D4 ;D4=coul pixel
 move.b D4,D5   ;D5=coul nouv pixel
 moveq #$F,D6   ;D6=masque mod16
 addq #1,D5
 and.b D6,D5
 cmp.b -1(A2,D2),D5
 beq \sq ;saut quantique!
 cmp.b -1(A2,D3),D5
 beq \sq
 cmp.b -1(A2,A4),D5
 beq \sq
 cmp.b -1(A2,A5),D5
 beq \sq
 move.b D4,D5 ;rien de neuf
\sq move.b D5,(A3)+
 dbra D0,\np
 addq #2,A2
 addq #2,A3
 move #320-1,D0
 dbra D1,\np

; report sph�rique
;lign. -1 et 200
 movea.l A1,A0 ;A1=TAB ... autres=brouillon
 addq #1,A0
 move.l #200*322,D0
 move #320-1,D1
\L_1 move.b (A0,D0.L),(A0)+
 dbra D1,\L_1
 movea.l A1,A0
 adda.l #201*322+1,A0
 move #320-1,D1
 neg.l D0
\L200 move.b (A0,D0.L),(A0)+
 dbra D1,\L200
 ;col. -1 et 320
 movea.l A1,A0
 adda #322,A0
 move #200-1,D1
\C_1 move.b 320(A0),(A0)
 adda #322,A0
 dbra D1,\C_1
 movea.l A1,A0
 adda #322+320+1,A0
 move #200-1,D1
\C320 move.b -320(A0),(A0)
 adda #322,A0
 dbra D1,\C320
remp: ;TAB ---> ECR
 tst.b N_M
 beq \N
 lea TAB_N,A0
 movea.l ECR_N,A1
 bra \suite
\N lea TAB_M,A0
 movea.l ECR_M,A1
\suite adda #322+1,A0 ;A0=srce
                  ;A1=dest
 move #320/2-1,D0 ;D0=col. /2 car on traite 2 pixels � la fois
 move #200-1,D1   ;D1=lign.
 moveq #1,D5      ;D2/D3/D4/D5=plans avec D5 indic. d�bordement
\nsp move.b (A0)+,D6  ;D6=coul 1er pixel
 move.b (A0)+,D7  ;D7=coul 2�me pixel
 lsr.b #1,D6
 roxl #1,D2
 lsr.b #1,D6
 roxl #1,D3
 lsr.b #1,D6
 roxl #1,D4
 lsr.b #1,D6
 roxl #1,D5
 lsr.b #1,D7
 roxl #1,D2
 lsr.b #1,D7
 roxl #1,D3
 lsr.b #1,D7
 roxl #1,D4
 lsr.b #1,D7
 roxl #1,D5
 dbcs D0,\nsp
 move D2,(A1)+ ;vidage
 move D3,(A1)+
 move D4,(A1)+
 move D5,(A1)+
 moveq #1,D5
 dbra D0,\nsp
 addq #2,A0
 move #320/2-1,D0
 dbra D1,\nsp
basc: ;Normal <|> Miroir
 tst.b N_M
 beq \N
 movea.l ECR_N,A0
 bra \suite
\N movea.l ECR_M,A0
\suite move #-1,-(SP)
 pea (A0)
 pea -1
 move #5,-(SP) ;SCRN_SET
 trap #14
 adda #10,SP
 not.b N_M
 move #7,-(SP) ;BELl
 move #2,-(SP)
 move #3,-(SP)
 trap #13
 addq #6,SP
attente: ;CONS_GINSTAT
 move #2,-(SP)
 move #1,-(SP)
 trap #13
 addq #4,SP
 tst D0
 beq gen
 ;CONS_IN
 move #2,-(SP)
 move #2,-(SP)
 trap #13
 addq #4,SP
 cmpi.b #127,D0
 beq DIAMONDS
 cmpi.b #ESC,D0
 bne attente

EPILOGUE:
 ;efface l'�cran CONS_OUT
 move #ESC,-(SP)
 move #2,-(SP)
 move #3,-(SP)
 trap #13
 move #"E",4(SP)
 trap #13
 addq #6,SP
 ;SCRN_SET
 move res_orig,-(SP)
 move.l ECR_N,-(SP)
 pea -1
 move #5,-(SP)
 trap #14
 adda #10,SP
 ;SCREEN_SPALETTE
 pea palette_orig
 move #6,-(SP)
 trap #14
 addq #6,SP
 ;remet le curseur CONS_OUT
 move #ESC,-(SP)
 move #2,-(SP)
 move #3,-(SP)
 trap #13
 move #"e",4(SP)
 trap #13
 addq #6,SP
 bra FIN

GETPALETTE: lea $FFFF8240,A0
 lea palette_orig,A1
 moveq #15,D0
\t move (A0)+,(A1)+
 dbra D0,\t
 rts

 DATA
palette DC.W $000,$200,$300,$400,$500,$600,$700,$732
        DC.W $742,$752,$652,$552,$770,$773,$775,$777
N_M DC.B 0 ;indicateur Normal/Miroir 0/-1

 BSS
res_orig DS.W 1
palette_orig DS.W 16
ECR_N DS.L 1
ECR_M DS.L 1
 DS.B 32000+256
 DS.B 1 ;"r�aligner" les TAB
TAB_N DS.B (320+2)*(200+2)
TAB_M DS.B (320+2)*(200+2)
 END

 