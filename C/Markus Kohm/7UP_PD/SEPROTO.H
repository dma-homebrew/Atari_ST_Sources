/* SE-Protokoll zur Kommunikation zwischen Shells zur Programmentwicklung
 * und Editoren. (c) DIRK STEINS @K2.MAUS.DE
 *
 * Dieses Protokoll dient dazu, unter Multitasking-Systemen die Shell
 * zur Compilierung und �hnlichen Sachen zu veranlassen, und um Fehler-
 * meldungen und/oder Fehlerdateien an den Editor zur�ckzugeben.
 *
 * Kommandos bzw. Nachrichten von der Shell zum Editor beginnen
 * mit SE_, Nachrichten vom Editor zur Shell beginnen mit ES_
 *
 * Da teilweise Zeiger auf Speicherbereiche �bergeben werden, ist vom
 * jeweiligen Absender der Nachricht darauf zu achten, da� diese
 * Speicherbereiche vom Empf�nger auch lesbar sind (Memory Protection!).
 * Daf�r sind diese als Readable zu allozieren!
 *
 * Version  Datum       �nderungen
 * =====================================================================
 *   0.1    10.1.94     Erster Entwurf
 *   0.2    17.1.94     SE_TERMINATE hinzugef�gt
 */

#define SE_INIT 0x4200
    /* Die Shell fragt an, ob ein Editor das SE-Protokoll
     * versteht.
     * Wort 3: Ein Bitset, welche Nachrichten die Shell versendet
     * Wort 4+5: Ein Bitset, welche Editorkommandos verstanden werden
     * Wort 6: Unterst�tze Versionsnummer des Protokolls
     * Als Antwort erh�lt es ein ES_OK vom  Editor.
     */
#define SE_OK 0x4201
    /* Die Shell sagt dem Editor, das sie das Protokoll
     * versteht.
     * Wort 3: Ein Bitset, welche Nachrichten die Shell versendet
     * Wort 4+5: Ein Bitset, welche Editorkommandos verstanden werden
     * Wort 6: Unterst�tze Versionsnummer des Protokolls
     * Wort 7: Die ApId des Programmes, dessen Nachricht beantwortet wird
     */
#define SE_ACK 0x4202
    /* Die Shell best�tigt den Empfang eines Editorkommandos und gibt
     * zur�ck, ob das Kommando ausgef�hrt wird.
     * Wort 3: TRUE: Kommando wird verstanden und ausgef�hrt.
     *         FALSE: Das Kommando wird nicht verstanden
     * Eine SE_ACK mit TRUE sagt nichts dar�ber aus, ob das Kommando erfolg-
     * reich ausgef�hrt wurde. Es sagt nur, da� die Shell das Kommando
     * versteht und ausf�hren wird!
     */
#define SE_OPEN 0x4203
    /* Die Shell sagt dem Editor, da� er einen Text �ffnen
     * soll. Als Antwort erh�lt die Shell ein ES_ACK
     * Wort 3+4: Ein Zeiger auf den Filenamen des zu �ffnenden Files
     */
#define SE_ERROR 0x4204
    /* Es ist ein Fehler beim Compilieren aufgetreten.
     * Wort 3+4: Ein Zeiger auf eine Infostruktur, die wie folgt
     *           aufgebaut ist:
     *           Wort 0+1: Ein Zeiger auf den Namen des compilierten Textes.
     *           Wort 2+3: Ein Zeiger auf den Text der Fehlermeldung
     *           Wort 4  : Die Fehlernummer
     *           Wort 5  : Die Fehlerspalte
     *           Wort 6+7: Die Fehlerzeile
     * Mit ES_ACK best�tigt der Editor die Meldung.
     */
#define SE_ERRFILE 0x4205
    /* Es sind Fehler aufgetreten. Die Fehlermeldungen stehen in einem
     * Errorfile, welches in der Message spezifiziert wird.
     * Wort 3+4: Ein Zeiger auf den Filenamen des Errorfiles mit den
     *           Fehlermeldungen
     * Wort 5+6: Ein Zeiger auf den Namen des compilierten Textes
     * Mit ES_ACK best�tigt der Editor die Meldung.
     */
#define SE_PROJECT 0x4206
    /* Die Shell teilt dem Editor mit, da� das Projekt
     * ge�ndert wurde. Der Filename des aktuellen
     * Projektfiles wird als Parameter �bergeben
     * Wort 3+4: Ein Zeiger auf den Namen des Projektfiles
     * Der Editor best�tigt mit ES_ACK.
     * Eine vern�nftige Reaktion des Editors w�re es in dem Fall,
     * ebenfalls das Projekt zu wechseln, sofern er diese unterst�tzt.
     */
#define SE_QUIT 0x4207
    /* Die Shell teilt dem Editor mit, da� sie jetzt beendet wird.
     * Der Editor sollte in dem Fall die Shell als Kommunikationspartner
     * vergessen.
     * Parameter gibt es keine.
     * Es wird keine Antwort erwartet!
     */
#define SE_TERMINATE 0x4208
    /* Die Shell teilt dem Editor mit, da� dieser sich beenden soll.
     * Der Editor sollte in dem Fall sich selbst beenden und seinen ganz
     * normalen Terminierungsproze� durchlaufen (und in dem auch ein
     * ES_QUIT schicken!). Der Grund f�r so eine Meldung der Shell k�nnte
     * zum Beispiel zu wenig Speicher zum compilieren sein.
     * Mit ES_ACK best�tigt der Editor die Meldung.
     */

#define ES_INIT 0x4240
    /* Ein Editor fragt an, ob eine Shell das SE-Protokoll versteht.
     * Wort 3: Ein Bitset, welche Shellnachrichten verstanden werden
     * Wort 4+5: Ein Bitset, welche Editorkommandos versendet werden
     * Wort 6: Unterst�tze Versionsnummer des Protokolls
     * Als Antwort erh�lt es SE_OK von der Shell
     */
#define ES_OK 0x4241
    /* Der Editor beantwortet die Anfrage der Shell nach dem Protokoll.
     * Wort 3: Ein Bitset, welche Shellnachrichten verstanden werden
     * Wort 4+5: Ein Bitset, welche Editorkommandos versendet werden
     * Wort 6: Unterst�tze Versionsnummer des Protokolls
     * Wort 7: Die ApId des Programmes, dessen Nachricht beantwortet wird
     */
#define ES_ACK 0x4242
    /* Der Editor best�tigt den Empfang des Kommandos
     * Wort 3: TRUE: Kommando wird verstanden und ausgef�hrt.
     *         FALSE: Das Kommando wird nicht verstanden
     * Eine ES_ACK mit TRUE sagt nichts dar�ber aus, ob das Kommando erfolg-
     * reich ausgef�hrt wurde. Es sagt nur, da� der Editor das Kommando
     * versteht und ausf�hren wird!
     */
#define ES_COMPILE 0x4243
    /* Der Editor sagt der Shell, da� sie ein File �bersetzen soll.
     * Ein Pointer auf den Dateinamen wird in der Message �bergeben.
     * Wort 3+4: Zeiger auf den Namen der zu compilierenden Datei.
     * Diese Nachricht mu� mit SE_ACK best�tigt werden.
     */
#define ES_MAKE 0x4244
    /* Der Editor sagt der Shell, da� sie ein Make ausf�hren soll.
     * Ein Filename kann in der Message �bergeben werden, mu� aber
     * nicht gesetzt sein und mu� von der Shell auch nicht beachtet
     * werden!
     * Wort 3+4: Zeiger auf den Namen des Makefiles (oder NULL)
     * Die Shell best�tigt mit SE_ACK.
     */
#define ES_MAKEALL 0x4245
    /* Der Editor sagt der Shell, da� ein komplettes Make All ausgef�hrt
     * werden soll. Ein Filename f�r das Makefile kann (mu� nicht) in
     * der Message �bergeben werden.
     * Wort 3+4: Zeiger auf den Namen des Makefiles (oder NULL)
     * Die Shell best�tigt mit SE_ACK.
     */
#define ES_LINK 0x4246
    /* Der Editor sagt der Shell, da� das Programm
     * gelinkt werden soll. Ein Filename kann
     * in der Message �bergeben werden, mu� aber
     * nicht unbedingt beachtet werden von der Shell!
     * Wort 3+4: Zeiger auf den Namen der Source, die gelinkt werden soll
     *           (oder NULL)
     * Die Shell best�tigt mit SE_ACK.
     */
#define ES_EXEC 0x4247
    /* Der Editor sagt der Shell, da� das Programm
     * zu der Source ausgef�hrt werden soll. Ein
     * Filename kann �bergeben werden, mu� von der
     * Shell aber nicht beachtet werden.
     * Wort 3+4: Zeiger auf den Namen des auszuf�hrenden Files (oder NULL)
     *           Bei einer Sourcedatei ist diese ggf. noch zu
     *           compilieren und/oder zu linken
     * Die Shell best�tigt mit SE_ACK.
     */
#define ES_MAKEEXEC 0x4248
    /* Die Shell soll ein Make ausf�hren und danach das Programm ausf�hren.
     * Ein Filename f�r das Makefile kann (mu� nicht) in der Message
     * �bergeben werden.
     * Wort 3+4: Zeiger auf den Namen des Makefiles (oder NULL)
     * Die Shell best�tigt mit SE_ACK.
     */
#define ES_PROJECT 0x4249
    /* Der Editor teilt der Shell mit, da� das Project
     * ge�ndert/gewechselt wurde. Der Filename des
     * Projektfiles wird als Parameter in der Message
     * �bergeben.
     * Wort 3+4: Zeiger auf den Namen des Projektfiles
     * Die Shell best�tigt mit SE_ACK.
     * Eine vern�nftige Reaktion der Shell w�re in dem Fall, ebenfalls
     * das Projekt zu wechseln, sofern es diese unterst�tzt.
     */
#define ES_QUIT 0x424A
    /* Der Editor teilt der Shell mit, da� er jetzt beendet wird.
     * Die Shell sollte in dem Fall den Editor als Kommunikationspartner
     * vergessen.
     * Parameter gibt es keine.
     * Es wird keine Antwort erwartet!
     */

#define SE_DATA 0
    /* Nur f�r Typdeklaration benutzt, eigentlich �berfl�ssig
     */

#define SEPROTOVERSION 0x0100 /* Die Versionsnummer des Protokolls.
                               * Highbyte ist die Major Number
                               * Lowbyte ist die Lower Number
                               */

/* Typdefinitionen f�r die Nachrichten
 */

/* Dies definiert die einzelnen Bits, welche Nachrichten unterst�tzt werden
 */
#define seInit     0x0001
#define seOk       0x0002
#define seAck      0x0004
#define seOpen     0x0008
#define seError    0x0010
#define seErrfile  0x0020
#define seProject  0x0040

#define esInit     0x0001
#define esOk       0x0002
#define esAck      0x0004
#define esCompile  0x0008
#define esMake     0x0010
#define esMakeall  0x0020
#define esLink     0x0040
#define esExec     0x0080
#define esMakeexec 0x0100
#define esProject  0x0200

typedef struct
{
   char *errfile; /* Zeiger auf den Namen der compilierten Datei */
   char *errmess; /* Zeiger auf die Fehlermeldung */
   WORD  errnum;  /* Die Fehlernummer */
   WORD  errcol;
   LONG  errline;
}ERRINFO;

/*
TYPE    tShellCommands = (seInit, seOk, seAck, seOpen, seError, seErrfile,
                          seProject);

        tEditCommands  = (esInit, esOk, esAck, esCompile, esMake, esMakeall,
                          esLink, esExec, esMakeexec, esProject);

        tPtrString  = POINTER TO ARRAY [0..255] OF CHAR;
        /* Zeiger auf einen nullterminierten String
         */

        LONGBITSET  = SET OF [0..31];
        /* Leider kennt das nicht jeder Compiler
         */

        tErrInfo     = RECORD
                        errFile : tPtrString;
                        /* Zeiger auf den Namen der compilierten Datei
                         */
                        errMess : tPtrString;
                        /* Zeiger auf die Fehlermeldung
                         */
                        errNum  : INTEGER;
                        /* Die Fehlernummer
                         */
                      END;
        tPtrErrInfo = POINTER TO tErrInfo;


        /* �ber diese Recorddefinition kann man alle
         * Messages des Protokolls behandeln
         */

        tMessRec    = RECORD
                        msg     : INTEGER;
                        /* Messagenummer, Wort 0 */
                        apId    : INTEGER;
                        /* Applikation ID des Senders, Wort 1 */
                        overLen : INTEGER;
            /* �berl�nge der Nachricht (immer 0 f�r SE-Protokoll), Wort 2 */
                        CASE : CARDINAL OF
                          SE_INIT,
                          ES_INIT   : shellBits: BITSET;
                          /* Bits, die angeben, welche Shell-Nachrichten
                           * unterst�tzt werden (Wort 3)
                           */
                                      editBits : LONGBITSET;
                          /* Bits, die angeben, welche Editor-Nachrichten
                           * unterst�tzt werden (Worte 4 und 5)
                           */
                                      version  : CARDINAL;
                          /* Unterst�tze Versionsnummer des Protokolls
                           * Aktuell: $100
                           */
                        | SE_OK,
                          ES_OK     : okShellBits: BITSET;
                          /* Bits, die angeben, welche Shell-Nachrichten
                           * unterst�tzt werden (Wort 3)
                           */
                                      okEditBits : LONGBITSET;
                          /* Bits, die angeben, welche Editor-Nachrichten
                           * unterst�tzt werden (Worte 4 und 5)
                           */
                                      okVersion: CARDINAL;
                          /* Unterst�tze Versionsnummer des Antwortenden
                           * Aktuell: $100
                           */
                                      otherId  : INTEGER;
                          /* Die ApId des Senders, auf das dies eine Antwort
                           * ist (Wort 7)
                           */
                        | SE_ACK,
                          ES_ACK    : acknowledge:  BOOLEAN;
                          /* TRUE: Kommando wurde akzeptiert,
                           * FALSE: Kommando konnte nicht ausgef�hrt werden
                           */
                        | SE_OPEN   : namePtr   : tPtrString;
                          /* Zeiger auf den Namen des zu ladenden Textes
                           * (Worte 3 und 4)
                           */
                        | SE_ERROR  : errorPtr  : tPtrErrInfo;
                          /* Zeiger auf Speicherbereich, der die
                           * Fehlermeldung spezifiziert.
                           */
                                      errorRow  : INTEGER;
                          /* Die Spalte, in der der Fehler aufgetreten ist
                           * (Wort 5)
                           */
                                      errorLine : LONGINT;
                          /* Die Zeile, in der der Fehler aufgetreten ist
                           * (Worte 6 und 7)
                           */
                        | SE_ERRFILE : errPtr   : tPtrString;
                          /* Zeiger auf den Namen des Errorfiles */
                                       fnamePtr : tPtrString;
                          /* Zeiger auf den Namen der compilierten Datei */
                        | SE_PROJECT,
                          ES_COMPILE,
                          ES_MAKE,
                          ES_MAKEALL,
                          ES_LINK,
                          ES_EXEC,
                          ES_MAKEEXEC,
                          ES_PROJECT : filePtr  : tPtrString;
                          /* Zeiger auf den Filenamen des Files, welches
                           * behandelt werden soll
                           */
                        | SE_QUIT,
                          SE_TERMINATE,
                          ES_QUIT,
                          SE_DATA:     data     : ARRAY [0..4] OF INTEGER;
                          /* Definition f�r Maximall�nge des Records
                           */
                        END;
                      END;

        tPtrMessRec = POINTER TO tMessRec;
        /* Ein Zeiger auf diese Messageblock
         */
*/


