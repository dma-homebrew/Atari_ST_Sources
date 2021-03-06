/**************************************************************************/
/* Definitionen f�r den xUFSL                                             */
/*                                                                        */
/* 10.09.94 Version 1.00                                                  */
/* 14.09.94 Erweitert um Definitionen des UFSL Version 0.91-0.97          */
/*          Event-Funktion aus dem xUFSL-Aufruf entfernt                  */
/*          R�ckgabewerte an UFSL angepa�t. Die Wert UFS_NO_FONTS und     */
/*          UFS_NO_FONTSIZE sind nur aus Kompatibilit�tsgr�nden defi-     */
/*          niert. Solche Fehler werden intern vom xUFSL abfangen (hof-   */
/*          fentlich...).                                                 */
/**************************************************************************/

#if !defined( __XUFSL__)

#define __XUFSL__

/**************************************************************************/
/* Kennung des xUfsl                                                      */
/**************************************************************************/
#define xUFS_ID           'xUFS'

/**************************************************************************/
/* R�ckgabewerte des xUfsl                                                */
/**************************************************************************/
#define UFS_RES_ERROR    -7       /* Aufl�sung kleiner als 640*400 Punkte */
#define UFS_NO_HANDLE    -6       /* Kein Handle frei                     */
#define UFS_NO_WINDOW    -5       /* Kein Fenster frei                    */
#define UFS_NO_FONTS     -4       /* Keine Fonts geladen                  */
#define UFS_NO_FONTSIZE  -3       /* Fontgr��e nicht identifizierbar      */
#define UFS_ACTIVE       -2       /* Fontselektor ist bereits aktiv       */
#define UFS_ERROR        -1       /* Speichermangel o.�.                  */
#define UFS_STOP          0       /* <Abbruch> gew�hlt                    */
#define UFS_OK            1       /* <Ok> gew�hlt                         */

/**************************************************************************/
/* Dialogtypen --> dialtyp, s.u.                                          */
/**************************************************************************/
#define UFS_DIALOG        0       /* Modaler Dialog                       */
#define UFS_WINDOW        1       /* Unmodaler Dialog                     */

/**************************************************************************/
/* Flags f�r xUFSL --> flags, s.u.                                        */
/**************************************************************************/
#define UFS_SIZE_CHANGE   0x0001  /* Schriftgr��e �nderbar?               */
#define UFS_WIDTH_CHANGE  0x0002  /* Schriftbreite �nderbar?              */
#define UFS_ATTR_CHANGE   0x0004  /* Schriftattribute w�hlbar?            */
#define UFS_SKEW_CHANGE   0x0008  /* Schriftneigung �nderbar?             */
#define UFS_COLOR_CHANGE  0x0010  /* Schriftfarbe �nderbar?               */
#define UFS_SIZE_DEFAULT  0x0020  /* Schriftgr��e "DEFAULT" erlaubt?      */
#define UFS_ATTR_INVERS   0x0040  /* Sonderattribut "invers" w�hlbar?     */
#define UFS_GDOS_FONTS    0x0100  /* GDOS-Fonts erlaubt?                  */
#define UFS_PROP_FONTS    0x0200  /* Proportionalfonts erlaubt?           */
#define UFS_WIND_DIALOG   0x1000  /* Dialog im Fenster?                   */

/**************************************************************************/
/* UFSL-Initialisierungsfunktion, nur aus Kompatibilit�tsgr�nden imple-   */
/* mentiert. Liefert immer SUCCESS.                                       */
/**************************************************************************/
typedef int cdecl (*UFSL_INIT)(void);

/**************************************************************************/
/* Standard-Fontselektor                                                  */
/**************************************************************************/
typedef int cdecl (*UFSL)(
  int,    /* Handle der VDI-Workstation                                   */
  int,    /* Gesamtzahl der geladenen Fonts                               */
  int,    /* 0=Alle Fonts, 1=Nur unproportionale Fonts                    */
  string, /* Infotext, wird ggf. auf 47 Zeichen gek�rzt                   */
  int *,  /* Gew�hlte Font-ID                                             */
  int *   /* Gew�hlte Font-Gr��e                                          */
);

/**************************************************************************/
/* Neuer Standard-Fontselektor ab UFSL 0.97                               */
/**************************************************************************/
typedef int cdecl (*NUFSL)(
  int,    /* Handle der VDI-Workstation                                   */
  int,    /* 0=Alle Fonts, 1=Nur unproportionale Fonts                    */
  string, /* Infotext, wird ggf. auf 47 Zeichen gek�rzt                   */
  int *,  /* Gew�hlte Font-ID                                             */
  int *   /* Gew�hlte Font-Gr��e                                          */
);

/**************************************************************************/
/* Redraw-Funktion                                                        */
/* Die Redraw-Funktion wird NICHT bei folgenden Ereignissen aufgerufen:   */
/* WM_TOPPED, WM_NEWTOP, WM_CLOSED.                                       */
/**************************************************************************/
typedef void cdecl (*MSGFUNC)(
  int,    /* Event                                                        */
  int *   /* Message-Puffer                                               */
);

/**************************************************************************/
/* Extended-Fontselektor                                                  */
/**************************************************************************/
typedef int cdecl (*XUFSL)(
  int,    /* Handle der VDI-Workstation                                   */
  long,   /* Flags zur Funktions�berwachung                               */
  string, /* Fenstertitel, wird ggf. auf 47 Zeichen gek�rzt               */
  string, /* Fensterinfozeile, wird ggf. auf 47 Zeichen gek�rzt           */
  int,    /* ID des SMALL-Zeichensatzes im xUFSL-Dialog                   */
  int,    /* ID des IBM-Zeichensatzes im xUFSL-Dialog                     */
  int *,  /* Voreingestellte/gew�hlte ID                                  */
  int *,  /* Voreingestellte/gew�hlte Gr��e                               */
  int *,  /* Voreingestellte/gew�hlte Breite                              */
  int *,  /* Voreingestellte/gew�hlte Attribute                           */
  int *,  /* Voreingestellte/gew�hlte Farbe                               */
  int *   /* Voreingestellte/gew�hlte Neigung                             */
);

/**************************************************************************/
/* Benutzerdefinierte Hilfefunktion, sofern gew�nscht. Nur wenn diese     */
/* ungleich NULL ist, wird der Hilfe-Knopf �berhaupt aktiviert.           */
/**************************************************************************/
typedef int cdecl (*UFSL_HELP)(void);

/**************************************************************************/
/* Eigentliche xUFSL-Struktur                                             */
/**************************************************************************/
typedef struct {
  unsigned long id;               /* Kennung des xUFSL (xUFS)             */
  unsigned int  version;          /* Version (BCD-Format)                 */
  unsigned int  dialtyp;          /* Dialogtyp                            */
  UFSL_INIT     font_selinit;     /* Initialisierungsfunktion (Dummy)     */
  UFSL          font_selinput;    /* Standard-Selektorfunktion            */
  OBJECT        *helpbutton;      /* Hilfe-Knopf (BOXTEXT), maximale      */
                                  /* Textl�nge 9 Zeichen (OHNE Pr�fung!). */
  UFSL_HELP     helpfunc;         /* Eigene Hilfefunktion                 */
  char          *examplestr;      /* Beispieltext f�r Fontdarstellung,    */
  																/* wird ggf. auf 52 Zeichen gek�rzt.    */
  MSGFUNC       msgfunc;          /* Redrawfunktion                       */
  NUFSL         fontsel_exinput;  /* Neuer Standard-Selektor              */
  XUFSL         font_selexinput;  /* Extended-Selektorfunktion            */
} xUFSL_struct; 

#endif
