 movea.l 4(sp),a0       ; a0 = adresse buffer caractere
 movea.l 8(sp),a1       ; a1 = ecran travail

 movea.l a0,a2          ; Sauvegarde de a0
 movea.l a1,a3          ; Et de a1

 moveq #14,d0           ; 15 lignes
scroll:
 roxl   (a2)+           ; Scroll datas...
 roxl 152(a3)
 roxl 144(a3)
 roxl 136(a3)
 roxl 128(a3)
 roxl 120(a3)
 roxl 112(a3)
 roxl 104(a3)           ; Scrolle tous les 1ers
 roxl 96(a3)            ; Plans d'une ligne !
 roxl 88(a3)
 roxl 80(a3)
 roxl 72(a3)
 roxl 64(a3)
 roxl 56(a3)
 roxl 48(a3)
 roxl 40(a3)
 roxl 32(a3)
 roxl 24(a3)
 roxl 16(a3)
 roxl 8(a3)
 roxl (a3)
 adda.l #160,a3         ;ligne suivante ...
 dbra d0,scroll

 moveq #14,d0           ; 15 lignes
 movea.l a1,a3
scroll1:
 roxl (a0)+             ;scroll datas...
 roxl 152(a3)
 roxl 144(a3)
 roxl 136(a3)
 roxl 128(a3)
 roxl 120(a3)
 roxl 112(a3)
 roxl 104(a3)           ;scrolle tous les 1ers
 roxl 96(a3)            ;plans d'une ligne !
 roxl 88(a3)
 roxl 80(a3)
 roxl 72(a3)
 roxl 64(a3)
 roxl 56(a3)
 roxl 48(a3)
 roxl 40(a3)
 roxl 32(a3)
 roxl 24(a3)
 roxl 16(a3)
 roxl 8(a3)
 roxl (a3)
 adda.l #160,a3         ;ligne suivante ...
 dbra d0,scroll1

 moveq.l #12,d0         ; 13 lignes
scroll2:
 moveq #0,d1            ; Mise a 0 de d1
 asl #1,d1              ; et de X
 adda.l #160,a1
 roxl 158(a1)
 roxl 150(a1)
 roxl 142(a1)
 roxl 134(a1)
 roxl 126(a1)
 roxl 118(a1)
 roxl 110(a1)           ;scrolle tous les 4emes
 roxl 102(a1)           ;plans d'une ligne !
 roxl 94(a1)
 roxl 86(a1)
 roxl 78(a1)
 roxl 70(a1)
 roxl 62(a1)
 roxl 54(a1)
 roxl 46(a1)
 roxl 38(a1)
 roxl 30(a1)
 roxl 22(a1)
 roxl 14(a1)
 roxl 6(a1)
 roxl #1,d1
 or d1,158(a1)
 dbra d0,scroll2
 rts

 end
 