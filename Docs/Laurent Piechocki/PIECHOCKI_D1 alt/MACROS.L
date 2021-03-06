;     MACROS INSTRUCTIONS (GEMDOS)
;     更更更更更更更更更�
 
          TEXT

TERM      macro               ;TERM
          clr.w     -(sp)
          trap      #1
          endm
CCONIN    macro               ;attente et affichage d'une touche
          move.w    #1,-(sp)
          trap      #1
          addq.l    #2,sp
          endm
CCONOUT   macro     $\1
          move.w    \1,-(sp)   ;\1=Caract�re � afficher
          move.w    #2,-(sp)
          trap      #1
          addq.l    #4,sp
          endm
WAIT      macro               ;Attente d'une touche,retour dans d0
          move.w    #7,-(sp)
          trap      #1
          addq.l    #2,sp
          endm
PRINTLINE macro     $\1
          pea       \1        ;\1=adresse de la chaine de carac � afficher
          move.w    #9,-(sp)
          trap      #1
          addq.l    #6,sp
          endm
SUPER     macro
          clr.l     -(sp)       ;passage en mode SUPERVISEUR
          move.w    #$20,-(sp)
          trap      #1
          addq.l    #6,sp
          move.l    d0,sauv_sp  ;on sauve SP pour USER
          endm
USER      macro
          move.l    sauv_sp,-(sp) ;on restore SP
          move.w    #$20,-(sp)    ;passage en MODE UTILISATEUR
          trap      #1
          addq.l    #6,sp
          endm
KEEP      macro     $\1
          clr.w     -(sp)
          move.l    #\1,-(sp)    ;\1=nb d'octets � prot�ger puis TERM
          move.w    #$31,-(sp)
          trap      #1
          addq.l    #8,sp
          endm
CREER     macro     $\1,$\2,$\3
          move.w    #\1,-(sp)    ;\1=mode
          pea       \2           ;\2=adresse du nom de fichier
          move.w    #$3c,-(sp)
          trap      #1
          addq.l    #8,sp
          move.w    d0,\3        ;sauvegarde de d0 = handle en \3
          endm
OUVRIR    macro     $\1,$\2,$\3
          move.w    #\1,-(sp)    ;\1=mode d'ouverture
          pea       \2           ;\2=adresse du nom de fichier
          move.w    #$3d,-(sp)
          trap      #1
          addq.l    #8,sp
          move.w    d0,\3        ;sauvegarde de d0 = handle en \3
          endm
FERMER    macro     $\1
          move.w    \1,-(sp)     ;\1=nr� handle
          move.w    #$3e,-(sp)
          trap      #1
          addq.l    #4,sp
          endm
LIRE      macro     $\1,$\2,$\3
          pea       \1           ;\1=adresse du buffer
          move.l    \2,-(sp)     ;\2=nb d'octets � lire
          move.w    \3,-(sp)     ;\3=nr� handle
          move.w    #$3f,-(sp)
          trap      #1
          adda.l    #12,sp
          endm
ECRIRE    macro     $\1,$\2,$\3
          pea       \1           ;\1=adresse des donn�es
          move.l    \2,-(sp)     ;\2=nb de donn�es � �crire
          move.w    \3,-(sp)     ;\3=nr� handle
          move.w    #$40,-(sp)
          trap      #1
          adda.l    #12,sp
          endm
INKEY     macro
          move.w    #$ff,-(sp)   ;test du clavier
          move.w    #6,-(sp)
          trap      #1
          addq.l    #4,sp
          endm
READLINE  macro     $\1
          pea       \1           ;\1=adresse de la chaine de carac
          move.w    #$0a,-(sp)
          trap      #1
          addq.l    #6,sp
          endm
DRIVE     macro     $\1
          move.w    \1,-(sp)    ;\1=nr� du drive � activer
          move.w    #$0e,-(sp)
          trap      #1
          addq.l    #4,sp
          endm
WATHDRIVE macro
          move.w    #$19,-(sp)  ;retour dans d0
          trap      #1
          addq.l    #2,sp
          endm
PEXEC     macro     $\1,$\2,$\3,$\4
          pea       \1        ;\1=adresse environnement
          pea       \2        ;\2=adresse ligne de commande
          pea       \3        ;\3=adresse du nom de fichier
          move.w    \4,-(sp)  ;\4=mode
          move.w    #$4b,-(sp)
          trap      #1
          adda.l    #16,sp
          endm
SEARCH    macro     $\1,$\2,$\3
          pea       \1          ;\1=adresse du DTA
          move.w    #$1a,-(sp)
          trap      #1
          addq.l    #6,sp
          move.w    \2,-(sp)    ;\2=attribut
          pea       \3          ;\3=adresse du nom de fichier
          move.w    #$4e,-(sp)
          trap      #1
          addq.l    #8,sp
          endm
FATRIB    macro     $\1,$\2,$\3
          move.w    \1,-(sp)    ;\1=attribut
          move.w    \2,-(sp)    ;\2=#0=lire ou #1=�crire
          pea       \3          ;\3=adresse du nom de fichier
          move.w    #$43,-(sp)
          trap      #1
          adda.l    #10,sp
          endm
RENAME    macro     $\1,$\2
          pea       \1          ;\1=adresse nouveau nom
          pea       \2          ;\2=adresse ancien nom
          clr.w     -(sp)
          move.w    #$56,-(sp)
          trap      #1
          adda.l    #12,sp
          endm
;                              (BIOS)

CHANGED   macro     $\1
          move.w    \1,-(sp)   ;\1=nr� drive, retour dans d0
          move.w    #9,-(sp)
          trap      #13
          addq.l    #4,sp
          endm
NBD       macro                ;retour dans d0
          move.w    #10,-(sp)
          trap      #13
          addq.l    #2,sp
          endm
GETSHIFT  macro     $\1
          move.w    \1,-(sp)   ;#-1 =lecture des touches, retour dans d0.B
          move.w    #11,-(sp)
          trap      #13
          addq.l    #4,sp
          endm
;                                (XBIOS)

PHYSBASE  macro
          move.w    #2,-(sp)  ;physbase dans a0
          trap      #14
          addq.l    #2,sp
          endm
LOGBASE   macro
          move.w    #3,-(sp)  ;logbase dans a0
          trap      #14
          addq.l    #2,sp
          endm
GETREZ    macro
          move.w    #4,-(sp)  ;r�solution dans d0
          trap      #14
          addq.l    #2,sp
          endm
SETSCREEN macro     $\1,$\2,$\3
          move.w    \1,-(sp)     ;\1=r�solution
          move.l    \2,-(sp)     ;\2=adresse physbase
          move.l    \3,-(sp)     ;\3=adresse logbase  (#-1 pour inchang�)
          move.w    #5,-(sp)
          trap      #14
          adda.l    #12,sp
          endm
PALETTE   macro     $\1
          pea       \1           ;\1=adresse nouvelle palette
          move.w    #6,-(sp)
          trap      #14
          addq.l    #6,sp
          endm
COLOR     macro     $\1,$\2
          move.w    \1,-(sp)     ;\1=nouvelle couleur
          move.w    \2,-(sp)     ;\2=nr� couleur
          move.w    #7,-(sp)
          trap      #14
          addq.l    #6,sp
          endm
RANDOM    macro
          move.w    #17,-(sp)   ;random dans d0
          trap      #14
          addq.l    #2,sp
          endm
HARDCOPY  macro
          move.w    #20,-(sp)   ;screen dump
          trap      #14
          addq.l    #2,sp
          endm
SETTIME   macro     $\1
          move.l    \1,-(sp)    ;\1=heure+date
          move.w    #22,-(sp)
          trap      #14
          addq.l    #6,sp
          endm
GETTIME   macro
          move.w    #$17,-(sp)  ;heure+date dans d0
          trap      #14
          addq.l    #2,sp
          endm
DOSOUND   macro     $\1
          move.l    \1,-(sp)    ;\1=adresse donn�es du son
          move.w    #32,-(sp)
          trap      #14
          addq.l    #6,sp
          endm
KEYRATE   macro     $\1,$\2
          move.w    \1,-(sp)    ;\1=r�p�tition/20 ms
          move.w    \2,-(sp)    ;\2=retard/20 ms
          move.w    #32,-(sp)
          trap      #14
          addq.l    #6,sp
          endm
VSYNC     macro
          move.w    #37,-(sp)   ;VBL Synchro
          trap      #14
          addq.l    #2,sp
          endm
          END

 