DEFINITION MODULE MoreIO;

(* ----------------------------------------------------------------------------
 * AUTOR:    Dieter Hametner
 * ERSTELLT: 01.04.90 mit Megamax Modula-2 V2.2
 * ----------------------------------------------------------------------------
 * BESCHREIBUNG:
 * Dieses Modul stellt eine Erweiterung des Moduls TOSIO dar. Der Quelltext
 * von TOSIO ist fast vollstaendig erhalten geblieben.
 * (Dank an Thomas Tempelmann!)
 *
 * Konfiguriert den gesamten TOS-Bildschirm als Ausgabemedium f�r die
 * Funktionen aus 'InOut'.
 *
 * Das Modul wacht �ber die Zeilenumschaltungen (LF) und verh�lt sich
 * wie das Dateienansehen des Desktops. (�hnlich dem von UNIX bekannten MORE)
 *
 * Die Ein-/Ausgaben erfolgen durch Verwendung des 'Terminal'-Moduls
 * direkt �ber die BIOS-Routinen.
 *
 * Achtung: Wird dieses Modul statt 'GEMIO' eingebunden, d�rfen keine
 * GEM-Funktionen verwendet werden !
 *
 * Das gelinkte Programm sollte als Dateiendung 'TOS' oder 'TTP' statt 'PRG'
 * erhalten.
 *
 * Sollen die InOut-Ausgaben eines Programms auch unter der Shell �ber
 * den TOS-Bildschirm gehen, so ist dies Modul dort direkt vor (!)
 * dem InOut-Modul zu importieren. Desweiteren ist die Endung des Moduls
 * durch Verwendung der $E-Compileroption auf "MOS" bzw. "MTP" einzustellen.
 *
 * Beispiel:
 *
 *   MODULE Test; (*$E MOS *)
 *     IMPORT MOREIO;
 *     FROM InOut IMPORT Write, Read, WriteString;
 *   ... usw.
 *)

PROCEDURE ScrollOn;
PROCEDURE ScrollOff;
   
   (* Durch diese Prozeduren kann man im Programm bestimmen ob 'MOREIO'
    * aktiv ist ('ScrollOn') oder nicht ('ScrollOff').
    *
    * Defaulteinstellung: ScrollOff;
    *
    * Dr�ckt man eine beliebige Taste w�hrend 'MOREIO' nicht aktiv ist,
    * wird 'MOREIO' sofort aktiviert.
    *)

PROCEDURE ScreenOff;
PROCEDURE ScreenOn;

   (* 'ScreenOff' unterdr�ckt alle Ausgaben bis eine beliebige Taste
    * gedr�ckt wird. Beim Aufruf einer Eingabefunktion wird die Ausgabe
    * automatisch wieder eingeschaltet.
    *
    * Mit 'ScreenOn' kann die Ausgabe auch aus dem Programm eingeschaltet
    * werden.
    *)

END MoreIO.
