



           G E M - M A N A G E R  Version 5.10 vom 30.11.1992
     ==============================================================










                Inhaltsverzeichnis
                ------------------
        
                1) Daten entpacken
                2) Was ist auf der Diskette drauf ?
                3) Das Handbuch
                4) �nderungen zur Version 5.03
                5) Installationshinweise im Falle eines Updates


1) Daten entpacken
==================

Der GEM-Manager ist mit der Zeit umfangreich geworden. Zus�tzlich wird
die Anleitung in in zwei Textverarbeitungsformaten und im ASCII-Format
mitgeliefert. Alles zusammen pa�t leider nicht mehr auf eine Diskette,
so da� die Daten gepackt werden m�ssen. Um sie zu entpacken, gehen Sie
bitte folgenderma�en vor:

a) Kopieren Sie die vorhandenen Dateien auf Festplatte (als ernsthafter
   Anwender haben Sie doch sowas??)

b) Starten Sie das Programm LHARC200.PRG mit folgenden Parametern:
                x -xm gem_510

c) Alle Dateien (und Ordnerhierarchien) werden jetzt extrahiert und 
   stehen Ihnen somit zur Verf�gung

d) Die unten beschriebenen Dateien und Verzeichnisse sind im neuen
   Ordner "<laufwerk>:\GEM.510" enthalten


2) Was ist auf der Diskette drauf?
==================================

GEM.510 \DOKUMENT\T_WORD\MANAGER.TWD (Anleitung Tempus-Word)
                         MANAGER.TW  (Anleitung That's Write)
                 \ASCII \MANAGER.TXT (Anleitung ASCII)
                        
        \EXT_LIB.C\      README      (Bindings zu Betriebs-
                         EXFORMDO.C   systemfunktionen, die
                         F_BUTTON.C   nicht im Mark Williams C
                         F_KEYBD.C    implementiert sind)
                         CRYSTAL.O

        \MW_C\           AESBIND.H   (Headerdateien, wie sie im
                         GEMDEFS.H    Mark Williams C benutzt
                         OSBIND.H     werden)
                         STDIO.H
                         VDIBIND.H

        \SOURCES\GEM_LIB\BUTTON.H   (Sources zum GEM-Manager)
                         EVENT.H
                         GEMSYS.H
                         WINDOW.H
                         BUT_MNGE.C
                         EVNT_LIB.C
                         FKTPOOL.C
                         MENU_LIB.C
                         MOVEBOX.C
                         POP_LIB.C
                         RESOURCE.C

                \GERUEST\PRG_SKEL.C  (Programmger�st GEM-Programme)
                
                \SAMPLE1\ ...        (Beispielprogramm zum
                                      GEM-Manager)
                
				\SAMPLE2\ ...        (Das gleiche Beispielprogramm
				                      wie unter "SAMPLE1", aber noch
									  zus�tzlich mit einer Dialogbox,
									  die in einem Fenster unterge-
									  bracht ist)




3) Das Handbuch
===============

Das Handbuch liegt in 3 Formaten vor:
        Tempus Word
        That's Write
        Ascii-Text.

Hinweise zum Tempus Word Dokument:
----------------------------------
Das Handbuch enth�lt einige Grafiken IMG-Format, die in Ihr Verzeichnis
f�r Bilder kopiert werden m�ssen. Das Dokument wurde mit einem  DIN A5-
Layout erstellt.

Hinweise zum That's Write Dokument:
-----------------------------------
Sollten Sie das TWRITE-Dokument benutzen, ben�tigen Sie die Grafiken
nicht, da sie schon in den Text eingebunden sind. Das Handbuch hat
DIN A5-Format.

Hinweise zum Ascii Dokument:
----------------------------
Das ASCII-Format dient eigentlich nur zu �bernahme des Handbuchs in ein
anderes Textverarbeitungsprogramm. Nat�rlich sind alle Attribute und
sonstigen Einstellungen verlorengegangen. An den entsprechenen Stellen
wurden Hinweise auf den Dateinamen des Bildes eingebaut, das sie in Ihr
Textsystem �bernehmen k�nnen.

Der ASCII-Text ist als Flie�text gespeichert, d.h. ein Absatz ist  e i n e
Zeile. Das Absatzende wird durch eine Leerzeile erkannt. So d�rfte es
recht einfach sein, den Text absatzgerecht einzulesen und den Wortumbruch
durchzuf�hren.

Die Bilder zum Handbuch liegem im IMG-Formate bei. Im ASCII-File ist 
an den entsprechenden Stellen ein Vermerk - << Bild: ".." >> - mit
Dateinamen angegeben.




4) �nderungen zur Version 5.03
==============================

Folgende �nderungen wurden gegen�ber der alten Version vorgenommen:

a)  Allgemeine Funktionen:

    -   Es liegt ein Programmger�st bei, welches die Grundstruktur
        eines GEM-Programms unter Benutzung des GEM-Managers darstellt.

    -   Vom GEM-Manager wird das globales Feld "Prog_End" bereitgestellt.
        Durch die Funktion "gem_init()" wird dieses Feld auf FALSE ge-
        setzt. Es kann - mu� aber nicht - genutzt werden, indem es auf
        TRUE gesetzt wird, wenn das Programm beendet werden soll (siehe
        Beispielprogramm und Programmger�st).

    -   Neue Funktion "rect_overlay" zum Feststellen, ob zwei Recht-
        ecke sich �berschneiden und berechnen der Schnittfl�che.
    
    -   Neue Funktion "rect_equal" zum Feststellen, ob zwei Rechtecke
        identisch sind.
    
    -   Neue Funktion "is_cookie" zum Feststellen, ob ein bestimmtes
        Cookiejar installiert ist.
    
    -   neues Memberfeld in aktuell "multitsk"; ist TRUE, wenn ein 
        Multitasking-System vorliegt, ansonsten FALSE. Z.Zt. Wird
        vom Window-Manager genutzt.


b)  Window-Manager:

    -   Die "windows"-Tabelle wird jetzt dynamisch angelegt. Dadurch
        ergeben sich folgende �nderungen:
        
        --  Die max. Anzahl Fenster mu� mit "win_init()" �bergeben
            werden. Anhand dieser Anzahl wird der Speicher reserviert.
            R�ckgabe: TRUE/FALSE

        --  Neues Memberfeld in aktuell "max_user_wind" enth�lt die
            mit win_init() �bergebene max. Fensteranzahl

        --  "open_window()" �bergibt nicht mehr den Fensterhandle, 
            sondern den Index, unter dem die Daten des neuen Fensters
            abgelegt werden.
            ACHTUNG:    aktuell.handle enth�lt immer die Handle-Nr.

        --  Neue Funktion zum Freigeben des reservierten Speichers:
            "win_exit()"

        --  neues Memberfeld in aktuell "max_user_wind"; enth�lt
            die mit win_init() vorgegebene Maximalanzahl von Fenstern

        --  neue Funktion "int  handle_to_index(w_handle)" zum
            ermitteln des Index zum Fensterhandle
            
        --  Den Funktionen des Window-Managers (z.B. wm_call(),
            wind_info_set()) mu� der von open_window() zur�ckgegebene
            Index �bergeben werden (also nicht mehr das Fensterhandle)



        
    -   Fehlerbeseitigung beim Einsatz unter einem Multitasking-System.
        Ist ein Multitasking-System installiert, dann:

        --  wird kein automatischer Redraw durchgef�hrt.

        --  werden Fensterausgaben nur noch �ber Rechteckliste 
            ausgef�hrt (vorher wurden andere Fenster �bermalt).

    -   GEM-Array global[12] eingef�gt (globale Definition in
        gemprog.c), in restlichen Modulen mu� dieses Array importiert
        werden.
    
    -   Konstante MAXWIND zwar noch vorhanden, wird aber nicht mehr
        vom Window-Manager unterst�tzt
        ==> Kann AES kein Fenster mehr �ffnen, bringt open_window()
            den R�ckgabewert -2

    -   Fehlerbeseitigung beim Clipping; Clipping wurde nach Full-
        Redraw nicht gel�scht
        
    -   wm_call() um WM_FREDRAW erweitert. Damit wird ein Full-Redraw
        erzwungen.


c)  Men�-Manager:

    -   Der Mauszeiger kann den Bereich des Popup-Men�s nicht mehr 
        verlassen.
        
    -   Popup-Men� funktionierte nicht, wenn der Mauszeiger sich �ber
        Fensterelementen befand.

d)	Form-Manager:

	-	Dialogboxen k�nnen jetzt in Fenster gelegt werden





5) Installationshinweise im Falle eines Updates
===============================================

Sollten Sie den GEM-Manager noch nicht besitzen, lesen Sie bitte nur
die Installationshinweise im Handbuch.

Zuerst sollten sie die neue Version des GEM-Managers installieren,
wie es im Handbuch beschrieben ist. Danach kommt leider etwas Arbeit
auf Sie zu, da die �nderungen gerade beim Window-Manager umfangreich
waren und Modifikationen an den bestehenden Programmen erfordern.

a)  Die Fensterdaten zum Window-Manager werden jetzt in einem zu
    reservierenden Speicherbereich abgelegt. Daraus ergeben sich
    folgende programmtechnische �nderungen:
    
    -   die "EXTERN"-Deklaration f�r die Fensterdaten hei�t jetzt:
            extern  WIND_DATA   *windows;
    
    -   Funktion win_init() wurde ge�ndert:
            int win_init(max_window)
                int max_window;

        max_window =>   Max. Anzahl von Fenstern, die erlaubt sind.
                        Anhand dieses Wertes wird Speicher f�r die
                        Fensterdaten reserviert.

        R�ckgabewerte:  TRUE  ==>   Speicher reserviert
                        FALSE ==>   kein Speicher vorhanden, Window-
                                    Manager kann nicht benutzt werden
    
    -   open_window() gibt nicht mehr den Fensterhandle, sondern den 
        Index mit, unter dem die Fensterdaten im reservierten 
        Speicher abgelegt sind, z.B. windows[w_index].doc_x. Da in 
        den vorigen Versionen der Handle auch als Index genutzt 
        wurde, d�rften sich daraus keine �nderungen ergeben. Trotzdem 
        sollten Sie pr�fen, ob sie den R�ckgabewert aus open_window() 
        nicht noch anderweitig nutzen. Au�erdem sollte Sie ber�ck-
        sichtigen, da� jetzt der Index "0" vorkommen kann (ein Handle 
        "0" gab es ja bisher nicht).
    
    -   Den Funktionen den Window-Managers darf nicht der Fenster-
        handle, sondern der von open_window() bereitgestellte Index
        �bergeben werden. Sollte nur der Fensterhandle bekannt sein,
        z.B. aktuell.handle, dann ist die Funktion handle_to_index()
        zu benutzen.

    -   Vor dem Aufruf von gem_exit() sollte die neu geschaffene 
        Funktion win_exit() aufgerufen werden, um so alle Fenster zu 
        schlie�en und den f�r die Fensterdaten reservierten Speicher
        wieder freizugeben.
        
b)  L�uft das Programm unter einem Multitasking-System, wird kein
    automatischer Redraw mehr durchgef�hrt, egal was open_window()
    mitgegeben wurde. Dies ist notwendig, da im Multitasking Fenster-
    inhalte ge�ndert werden k�nnen, obwohl die Prozesse und damit
    die Fenster nicht aktuell sind. Ein automatischer Redraw w�rde
    dar�berliegende Fenster "�berklatschen", da es sich ja nur um
    Kopiervorg�nge aus gesichterten Fensterbereichen handelt.




c)  Die Strukturvariable "aktuell" wurde um die Felder multitsk und
    max_user_wind erweitert. Au�erdem wurden so ziemlich alle 
    Funktionen irgendwie ge�ndert. Daher m�ssen alle Programme, die
    eine "EXTERN"-Deklaration auf "aktuell" haben oder den GEM-
    Manager aufrufen, neu compiliert werden.
    

d)	Die Strukturvariable "windows" wurde um eine Struktur bereichert, die
	das Bearbeiten von Dialogboxen in Fenstern erm�glichen (RSCDATA).
	Bitte beachten Sie in jedem Falle, da� diese Daten zur Zwischenspeicherung
	von Werten der Form_do()-Routine ben�tigt wird und nur READONLY sind.
	Eine Ver�nderung der Werte wird mit ziemlicher Sicherheit einen System-
	stillstand hervorrufen! Alle Module, die den Window-Manager ben�tigen oder
	durch externe Verweise auf dieses Datenfeld zugreifen, m�ssen neu kom-
	piliert werden.


----------------------------------------

Sollten Sie den GEM-Manager erweitert haben oder auf Fehler gesto�en 
sein, so schreiben Sie bitte an eine der unten aufgef�hrten Adressen. 
Wir sind jederzeit bem�ht, soweit uns unser Job Zeit l��t, den GEM-
Manager zu pflegen und zu erweitern.


          Michael Kovar                    Volker Nawrath
        Waldmannstra�e 17              Tirschenreuther Ring 72
         1000 Berlin 46                    1000 Berlin 48
MausNet: Michael Kovar @ B		 
